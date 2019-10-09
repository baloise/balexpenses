import * as functions from 'firebase-functions';

const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

exports.getData = functions.https.onRequest(async (req, res) => {
    firestore
        .collection('user')
        .doc('SRcshXlZKdOvpG9WHZbCREf6PBg1')
        .collection('invoices')
        .get()
        .then((result: any) => {
            res.send(result.docs.map((d: any) => d._fieldsProto.sum));
        });
});
