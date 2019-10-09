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
