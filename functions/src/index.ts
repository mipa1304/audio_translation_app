/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {defineSecret} from "firebase-functions/params";
import {HttpsError, onCall} from "firebase-functions/https";
import {initializeApp} from "firebase-admin/app";
import {getAuth} from "firebase-admin/auth";
import {getFirestore} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

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
initializeApp();

const deepgramApiKey = defineSecret("DEEPGRAM_API_KEY");

export const getDeepgramToken = onCall(
  {secrets: [deepgramApiKey], maxInstances: 5},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Sign in before requesting a transcription token.",
      );
    }

    const response = await fetch("https://api.deepgram.com/v1/auth/grant", {
      method: "POST",
      headers: {
        "authorization": `Token ${deepgramApiKey.value()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ttl_seconds: 30}),
    });

    if (!response.ok) {
      logger.error("Deepgram token request failed", {
        status: response.status,
        uid: request.auth.uid,
      });
      if (response.status === 401 || response.status === 403) {
        throw new HttpsError(
          "failed-precondition",
          "Deepgram rejected the configured API key. Set " +
            "DEEPGRAM_API_KEY to a valid key with Member or higher " +
            "permissions, then redeploy the function.",
        );
      }
      throw new HttpsError(
        "unavailable",
        "Could not start transcription. Please try again.",
      );
    }

    const grant = (await response.json()) as {access_token?: unknown};
    if (typeof grant.access_token !== "string" || !grant.access_token) {
      logger.error("Deepgram returned an invalid token grant", {
        uid: request.auth.uid,
      });
      throw new HttpsError(
        "internal",
        "Could not start transcription. Please try again.",
      );
    }

    return {accessToken: grant.access_token};
  },
);

export const deleteMyData = onCall(
  {maxInstances: 5},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "Sign in before deleting your data.",
      );
    }

    const translations = getFirestore()
      .collection("translations")
      .where("userId", "==", request.auth.uid);
    let page = await translations.limit(400).get();
    while (!page.empty) {
      const batch = getFirestore().batch();
      for (const document of page.docs) {
        batch.delete(document.ref);
      }
      await batch.commit();
      page = await translations.limit(400).get();
    }

    await getAuth().deleteUser(request.auth.uid);
    return {deleted: true};
  },
);
