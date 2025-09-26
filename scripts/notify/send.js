// Send a test FCM message to a token or topic
// Usage (PowerShell):
//   $env:GOOGLE_APPLICATION_CREDENTIALS="C:\\path\\to\\serviceAccount.json"
//   $env:FIREBASE_PROJECT_ID="unique-school-system-d2961"
//   cd scripts/notify
//   npm install
//   # To a token
//   node send.js --token <DEVICE_TOKEN> --title "Hello" --body "Test notification"
//   # To a topic (e.g. class name -> class_class_5)
//   node send.js --topic class_class_5 --title "Update" --body "New message for Class 5"

const admin = require('firebase-admin');
const args = require('node:process').argv.slice(2);

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: process.env.FIREBASE_PROJECT_ID,
});

function arg(name) {
  const i = args.indexOf(`--${name}`);
  return i >= 0 ? args[i + 1] : undefined;
}

const token = arg('token');
const topic = arg('topic');
const title = arg('title') || 'Notification';
const body = arg('body') || 'Hello from FCM!';

if (!token && !topic) {
  console.error('Provide --token <DEVICE_TOKEN> or --topic <TOPIC>');
  process.exit(1);
}

const message = {
  notification: { title, body },
  data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' },
};

(async () => {
  if (token) {
    const res = await admin.messaging().send({ token, ...message });
    console.log('Sent to token:', res);
  } else {
    const res = await admin.messaging().send({ topic, ...message });
    console.log('Sent to topic:', res);
  }
})().catch((e) => { console.error(e); process.exit(1); });
