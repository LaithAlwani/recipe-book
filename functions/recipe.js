const {onCall, HttpsError} = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getStorage } = require("firebase-admin/storage");


const db = getFirestore();
const storage = getStorage();

exports.createRecipe = onCall(
  async (req) => {
    // 🔐 Optional auth check
    if (!req.auth) {
      throw new HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const { recipeId, recipe } = req.data;
    console.log(recipeId, recipe);

    if (!recipeId || !recipe) {
      throw new HttpsError(
        "invalid-argument",
        "recipeId and recipe payload are required"
      );
    }

    try {
      const recipeRef = db.collection("recipes").doc(recipeId);

      await recipeRef.set(
        {
          ...recipe,
          ownerId: req.auth.uid,
          createdAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true }
      );

      return { success: true };
    } catch (error) {
      console.error("Error creating recipe:", error);

      throw new HttpsError(
        "internal",
        "Failed to create recipe"
      );
    }
  }
);

exports.updateRecipe = onCall(async (request) => {
  const { data, auth } = request;

  if (!auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const { recipeId, recipe } = data;

  if (!recipeId || !recipe) {
    throw new HttpsError(
      "invalid-argument",
      "recipeId and recipe payload are required"
    );
  }

  const recipeRef = db.collection("recipes").doc(recipeId);
  const snapshot = await recipeRef.get();

  if (!snapshot.exists) {
    throw new HttpsError("not-found", "Recipe does not exist");
  }

  const existingRecipe = snapshot.data();

  // Ownership check
  if (existingRecipe?.ownerId !== auth.uid) {
    throw new HttpsError("permission-denied", "Not owner of recipe");
  }

  // Handle image removal if provided
  const removeImageUrls = recipe.removeImageUrls || [];
  if (removeImageUrls.length > 0) {
    for (const url of removeImageUrls) {
      try {
        const decodedPath = decodeURIComponent(
          new URL(url).pathname.replace("/v0/b/" + storage.bucket().name + "/o/", "")
        );
        await storage.bucket().file(decodedPath).delete();
      } catch (e) {
        console.warn("Failed to delete image:", url, e);
      }
    }
  }

  // Build updated imageUrls list
  const keepImageUrls = recipe.keepImageUrls || [];
  const updatedImageUrls = [...keepImageUrls];

  if (recipe.imageUrls && Array.isArray(recipe.imageUrls)) {
    updatedImageUrls.push(...recipe.imageUrls);
  }

  // Prepare updated data
  const updatedData = {
    ...recipe,
    imageUrls: updatedImageUrls,
    updatedAt: FieldValue.serverTimestamp(),
  };

  // Remove helper fields so they don't overwrite Firestore
  delete updatedData.keepImageUrls;
  delete updatedData.removeImageUrls;

  await recipeRef.set(updatedData, { merge: true });

  return { success: true };
});

