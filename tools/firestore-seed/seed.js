// Firestore seeding script using Firebase Admin SDK
// Usage (PowerShell):
//   $env:GOOGLE_APPLICATION_CREDENTIALS="C:\\path\\to\\serviceAccountKey.json"
//   cd tools/firestore-seed
//   npm install
//   npm run seed

const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

// Initialize Admin SDK using Application Default Credentials (service account via env var)
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  // projectId is inferred from the service account; optionally override via env FIREBASE_PROJECT_ID
  projectId: process.env.FIREBASE_PROJECT_ID,
});

const db = admin.firestore();

function maybeConvertTimestamps(obj) {
  if (obj && typeof obj === 'object' && !Array.isArray(obj)) {
    for (const [k, v] of Object.entries(obj)) {
      if (
        (k.toLowerCase() === 'createdat' || k.toLowerCase() === 'updatedat') &&
        typeof v === 'string'
      ) {
        obj[k] = admin.firestore.Timestamp.fromDate(new Date(v));
      } else if (typeof v === 'object') {
        maybeConvertTimestamps(v);
      }
    }
  }
  return obj;
}

(async () => {
  const dataPath = path.join(__dirname, 'seed-data.json');
  const raw = fs.readFileSync(dataPath, 'utf8');
  const payload = JSON.parse(raw);

  const collections = Object.keys(payload);
  console.log(`Seeding collections: ${collections.join(', ')}`);

  // Use batched writes with a safe batch size
  const BATCH_LIMIT = 450; // under Firestore 500 write limit

  for (const [collectionName, docs] of Object.entries(payload)) {
    let batch = db.batch();
    let count = 0;

    for (const [docId, docData] of Object.entries(docs)) {
      const ref = db.collection(collectionName).doc(docId);
      batch.set(ref, maybeConvertTimestamps(docData), { merge: true });
      count++;
      if (count % BATCH_LIMIT === 0) {
        await batch.commit();
        batch = db.batch();
      }
    }

    if (count % BATCH_LIMIT !== 0) {
      await batch.commit();
    }

    console.log(`✔ Seeded ${count} document(s) into '${collectionName}'`);
  }

  console.log('✅ Firestore seeding complete.');
  process.exit(0);
})().catch((err) => {
  console.error('❌ Seeding failed:', err.message);
  process.exit(1);
});
