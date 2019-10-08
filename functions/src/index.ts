const functions = require('firebase-functions');
const path = require('path');
const admin = require('firebase-admin');

admin.initializeApp();

exports.onUploadedObject = functions.storage.object().onFinalize((object: any) => {
    // Determine the bucket and path that triggered us
    const fileBucket = object.bucket;
    const filePath = object.name;

    // Get the UID and file name from the path
    const uid = path.dirname(filePath).substring(filePath.indexOf('/') + 1);
    const fileName = path.basename(filePath);

    console.log('--->' + uid + ' ' + fileName);
    console.log('fileBucket' + fileBucket);
});
