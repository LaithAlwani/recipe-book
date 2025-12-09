/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
/* eslint-disable */ 
const {setGlobalOptions} = require("firebase-functions");
// const {onRequest} = require("firebase-functions/https");
// const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const {getStorage} = require("firebase-admin/storage")

initializeApp();

const db = getFirestore();
const bucket = getStorage();

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
      recipies: [],
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

