import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
admin.initializeApp(functions.config().firebase);

exports.newSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onCreate(async e => {
        const topic = "note"
        const message = {
            notification: {
                title: 'У нас новый заказ!',
                body: e.get('description')+' '+ e.get('title')
            },
                topic: topic
        }

        return admin.messaging().send(message)
            .then((response) => {
            // Response is a message ID string.
            console.log('Successfully sent message:', response);
            })
            .catch((error) => {
            console.log('Error sending message:', error);
            });
    });
    exports.updateSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onUpdate(async e => {
        const topic = "note"
        const message = {
            notification: {
                title: 'Заказ изменен',
                body: e.after.get('description')+' '+ e.after.get('title')
            },
                topic: topic
        }

        return admin.messaging().send(message)
            .then((response) => {
            // Response is a message ID string.
            console.log('Successfully sent message:', response);
            })
            .catch((error) => {
            console.log('Error sending message:', error);
            });
    });

    exports.deleteSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onDelete(async e => {
        const topic = "note"
        const message = {
            notification: {
                title:  e.get('description'),
                body: 'Заказ удален'
            },
                topic: topic
        }

        return admin.messaging().send(message)
            .then((response) => {
            // Response is a message ID string.
            console.log('Successfully sent message:', response);
            })
            .catch((error) => {
            console.log('Error sending message:', error);
            });
    });