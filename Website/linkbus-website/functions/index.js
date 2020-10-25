const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();
const express = require('express');
const cors = require('cors')({origin: true});
const app = express();

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

app.get('/', async (req, res) => {
  const snapshot = await db.collection('alerts').get();
  let alerts = [];
  snapshot.forEach(doc => {
    const id = doc.id;
    const data = doc.data();
    alerts.push({id, ...data});
  });
  res.status(200).send(JSON.stringify(alerts));
});

app.use(cors);

exports.alert = functions.https.onRequest(app);