"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
admin.initializeApp(functions.config().firebase);
exports.newSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onCreate(async (e:any) => {
    const topic = "note";
    const message = {
        notification: {
            title: 'У нас новый заказ!',
            body: e.get('description') + ' ' + e.get('title'),
        },
        topic: topic,
        data: {
            id: e.id,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };
    return admin.messaging().send(message)
        .then((response: any) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    })
        .catch((error: any) => {
        console.log('Error sending message:', error);
    });
});
exports.updateSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onUpdate(async (e: any) => {
    const topic = "note";
    const message = {
        notification: {
            title: 'Заказ изменен',
            body: e.after.get('description') + ' ' + e.after.get('title')
        },
        topic: topic,
        data: {
            id: e.after.id,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };
    return admin.messaging().send(message)
        .then((response: any) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    })
        .catch((error: any) => {
        console.log('Error sending message:', error);
    });
});
exports.deleteSpilNotification = functions.firestore
    .document('events/{eventId}')
    .onDelete(async (e: any) => {
    const topic = "note";
    const message = {
        notification: {
            title: e.get('description'),
            body: 'Заказ удален'
        },
        topic: topic
    };
    return admin.messaging().send(message)
        .then((response: any) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    })
        .catch((error: any) => {
        console.log('Error sending message:', error);
    });
});
//# sourceMappingURL=index.js.map