const {onCall, HttpsError} = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

const db = getFirestore();


exports.createUser = onCall(async (req) => {
  const {uid, displayName, email, photoUrl} = req.data;
  const userRef = db.collection("users").doc(uid);
    if (!uid || !displayName || !email) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required user fields: uid, name, email",
    );
  }
  try {
    //  check if user exsists
    const doc = await userRef.get();
    if (doc.exists) {
      throw new HttpsError(
          "already-exists",
          "User already exists",
      );
    }   

    //  create new user
    await userRef.set({
      uid: uid,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
      recipes: [],
      favorites: [],
      followers: [],
      following: [],
      role: "user",
      bio: "",
      isVarified: "",
      location: null,
    });
  } catch (err) {
    console.error("Error creating user:", err);
    throw new HttpsError("internal", err.message);
  }
});

exports.updateUserProfile = onCall(async (req) => {
  const { uid, displayName, email, photoUrl } = request.data;

  if (!request.auth || request.auth.uid !== uid) {
    throw new Error("unauthenticated or invalid UID");
  }

  if (!uid) {
    throw new Error("Missing user UID");
  }

  const userRef = db.collection("users").doc(uid);
  const updateData = {
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  if (displayName) updateData.displayName = displayName;
  if (email) updateData.email = email;
  if (photoUrl) updateData.photoUrl = photoUrl;
  userRef.update(updateData);
  return { success: true };
});

