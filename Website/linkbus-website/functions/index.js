const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();
const express = require('express');
const cors = require('cors')({origin: true});
const app = express();

const adminUserId = "mZK3hiDTGbaejz9vBfdm9d92kdf1"

app.get('/alerts', async (req, res) => {
  const snapshot = await db.collection("alerts")
      .where('uid', '==', adminUserId)
      .where('active', '==', true)
      .get()
  let alerts = processResponse(snapshot);
  const alertsJson = {alerts: alerts};
  res.status(200).send(JSON.stringify(alertsJson));
});

app.get('/routes', async (req, res) => {
  const snapshot = await db.collection("routes")
      .where('uid', '==', adminUserId)
      .get()
  let routes = processResponse(snapshot);
  const routesJson = {routes: routes};
  res.status(200).send(JSON.stringify(routesJson));
});

const processResponse = (snapshot) => {
  let docs = [];
  snapshot.forEach(doc => {
    const id = doc.id;
    const data = doc.data();
    docs.push({id, ...data});
  });
  return docs;
}

app.get('/', async (req, res) => {
  const alertsSnapshot = await db.collection("alerts")
      .where('uid', '==', adminUserId)
      .where('active', '==', true)
      .get()
  const routesSnapshot = await db.collection("routes")
      .where('uid', '==', adminUserId)
      .get()
  let alerts = processResponse(alertsSnapshot);
  let routes = processResponse(routesSnapshot);
  const json = {alerts: alerts, routes: routes}
  res.status(200).send(JSON.stringify(json));
});

app.use(cors);

exports.api = functions.https.onRequest(app);