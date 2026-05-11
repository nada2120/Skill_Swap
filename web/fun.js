const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.endSessions = functions.pubsub
    .schedule("every 1 minutes")
    .onRun(async () => {
        const now = admin.firestore.Timestamp.now();

        const sessions = await admin.firestore()
            .collection("sessions")
            .where("status", "==", "active")
            .where("endTime", "<=", now)
            .get();

        if (sessions.empty) {
            console.log("No sessions to end.");
            return null;
        }

        const batch = admin.firestore().batch();
        sessions.forEach(doc => {
            batch.update(doc.ref, { status: "ended" });
        });

        await batch.commit();
        console.log("Sessions ended:", sessions.size);
        return null;
    });