const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const bodyParser = require('body-parser');

admin.initializeApp();

const app = express();
const db = admin.firestore();

app.use(bodyParser.json());

app.post('/mpesaCallback', async (req, res) => {
  try {
    const payload = req.body;

    
    await db.collection('mpesa_transactions').add(payload);

    console.log('M-Pesa transaction data:', payload);
    res.status(200).send('Callback received successfully');
  } catch (error) {
    console.error('Error processing M-Pesa callback:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Expose the Express app as a Cloud Function
exports.mpesaCallback = functions.https.onRequest(app);
