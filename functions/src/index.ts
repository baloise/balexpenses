const functions = require('firebase-functions');
const path = require('path');
const admin = require('firebase-admin');

admin.initializeApp();

export const helloWorld = functions.https.onRequest((request:any, response:any) => {
    response.send("Hello from Firebase!");
});

exports.scanReceipt = functions.storage.object().onFinalize((object: any) => {
    // Determine the bucket and path that triggered us
    const fileBucket = object.bucket;
    const filePath = object.name;

    // Get the UID and file name from the path
    const uid = path.dirname(filePath).substring(filePath.indexOf('/') + 1);
    const fileName = path.basename(filePath);

    console.log('--->' + uid + ' ' + fileName);
    console.log('fileBucket' + fileBucket);

    // // Call Cloud Vision to find text in the receipt
    // const visionClient = new vision.ImageAnnotatorClient();
    // return visionClient.textDetection(`gs://${fileBucket}/${filePath}`).then(([result]) => {
    //     const detections = result.textAnnotations;
    //
    //     // Find the total amount in this receipt
    //     const amount = receipt.findTotal(detections);
    //
    //     // Determine the document to write the amount from this receipt to
    //     let expenseDoc = admin.firestore().doc(`users/${uid}/expenses/${fileName}`);
    //
    //     // Write the amount to this new document
    //     return expenseDoc.set({
    //         created_at: admin.firestore.FieldValue.serverTimestamp(),
    //         item_cost: amount
    //     });
    // });
});
