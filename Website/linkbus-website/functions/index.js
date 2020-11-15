const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();
const express = require('express');
const cors = require('cors')({origin: true});
const app = express();


const production = false; // PRODUCTION VARIABLE
const staging = false; // STAGING VARIABLE
const development = true; // DEVELOPMENT VARIABLE
let adminUserId = ""
if(production) {
  adminUserId = "mZK3hiDTGbaejz9vBfdm9d92kdf1"
} else if(staging) {
  adminUserId = "0ZUHsGrupYcTLfxMXuriAZZEElp2"
} else if(development) {
  adminUserId = "1J6yYtccJ3c7ZeiAqUOuDpAgZvo1"
}

const now = () => { return admin.firestore.Timestamp.now() }

app.get('/alerts', async (req, res) => {
  const snapshot = await db.collection("alerts")
      .where('uid', '==', adminUserId)
      .where('active', '==', true)
      .where('start', '<=', now())
      .get()
  let alerts = processAlertsResponse(snapshot);
  const alertsJson = {alerts: alerts};
  res.status(200).send(JSON.stringify(alertsJson));
});

app.get('/routes', async (req, res) => {
  const snapshot = await db.collection("routes")
      .where('uid', '==', adminUserId)
      .get()
  let routes = processRoutesResponse(snapshot);
  const routesJson = {routes: routes};
  res.status(200).send(JSON.stringify(routesJson));
});

const processAlertsResponse = (snapshot) => {
  let docs = [];
  snapshot.forEach(doc => {
    const data = doc.data();
    if(data.end === "" || now() <= data.end) {
      const id = doc.id;
      docs.push({id, ...data});
    }
  });
  return docs;
}
const processRoutesResponse = (snapshot) => {
  let docs = [];
  snapshot.forEach(doc => {
    const data = doc.data();
    const id = doc.id;
    docs.push({id, ...data});
  });
  return docs;
}

app.get('/', async (req, res) => {
  const alertsSnapshot = await db.collection("alerts")
      .where('uid', '==', adminUserId)
      .where('active', '==', true)
      .where('start', '<=', now())
      .get()
  const routesSnapshot = await db.collection("routes")
      .where('uid', '==', adminUserId)
      .get()
  let alerts = processAlertsResponse(alertsSnapshot);
  let routes = processRoutesResponse(routesSnapshot);
  const json = {alerts: alerts, routes: routes}
  res.status(200).send(JSON.stringify(json));
});

app.use(cors);

exports.api = functions.https.onRequest(app);