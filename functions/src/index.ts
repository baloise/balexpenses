import * as functions from 'firebase-functions';
const admin = require("firebase-admin");
admin.initializeApp();
const firestore = admin.firestore();
firestore.settings({timestampsInSnapshots: true});

exports.getData = functions.https.onRequest(async (req, res) => {
    console.log(req.query);
    firestore
        .collection('user')
        .doc(req.query.uid)
        .collection('invoices')
        .orderBy('date')
        .get()
        .then((result: any) => {
            console.log(result.docs);

            const _document = result.docs
                .reduce((acc: any, curr: any) => {
                    const convertedDate = curr.get("date").toDate();
                    const currYear = convertedDate.getFullYear().toString();
                    const currMonth = convertedDate.getMonth().toString();
                    if (!acc.hasOwnProperty(currYear)) {
                        acc[currYear] = 0;
                    }
                    if(!acc.hasOwnProperty(currMonth)){
                        acc[currYear + 'M' + currMonth] = 0;
                    }
                    acc[currYear] += curr.get("sum");
                    acc[currYear + 'M' + currMonth] += curr.get("sum");

                    return acc;
                }, {});

            firestore
                .collection('user')
                .doc(req.query.uid)
                .set(_document);
            res.send(
                _document
            );
        });
});

exports.calculateSum = functions.firestore.document('user/{userId}/invoices/{invoiceId}').onWrite((change, context) => {

    console.log(`Yeeehaaaa - I was triggered!`);

    const userId = context.params.userId;
    const invoiceId = context.params.invoiceId;

    // Get an object with the previous document value (for update or delete)
    const oldDocument = change.before.data();

    // Get an object with the current document value.
    // If the document does not exist, it has been deleted.
    const document = change.after.exists ? change.after.data() : null;

    // Check if the new document was deleted or created / updated
    if(document) {
        if(oldDocument) {
           console.log(`User ${userId} has updated an existing invoice ${invoiceId} => updating sums...`);
        } else {
           console.log(`User ${userId} has created a new invoice ${invoiceId} => updating sums...`);
        }
    } else {
        console.log(`User ${userId} has deleted invoice ${invoiceId}.`);
    }

    return `End of Function`;
});
