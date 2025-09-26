// Firestore seed for array-based input; supports NOW placeholder
// Usage (PowerShell):
//   # Production (service account)
//   $env:GOOGLE_APPLICATION_CREDENTIALS="C:\\path\\to\\serviceAccountKey.json"
//   $env:FIREBASE_PROJECT_ID="your-project-id"   # if not present in service account
//   cd scripts/firestore-seed
//   npm install
//   npm run seed
//
//   # Emulator (no creds needed)
//   firebase emulators:start --only firestore     # in another terminal
//   $env:FIRESTORE_EMULATOR_HOST="127.0.0.1:8080"
//   $env:FIREBASE_PROJECT_ID="demo-unique-school"
//   cd scripts/firestore-seed
//   npm install
//   npm run seed

const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');
const slugify = require('slugify');

const useEmulator = !!process.env.FIRESTORE_EMULATOR_HOST;
if (useEmulator) {
  admin.initializeApp({ projectId: process.env.FIREBASE_PROJECT_ID || 'demo-unique-school' });
  console.log(`Using Firestore emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
} else {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: process.env.FIREBASE_PROJECT_ID, // optional override
  });
}

const db = admin.firestore();

const ts = (v) => {
  if (typeof v === 'string' && v.toUpperCase() === 'NOW') {
    return admin.firestore.FieldValue.serverTimestamp();
  }
  if (typeof v === 'string') {
    return admin.firestore.Timestamp.fromDate(new Date(v));
  }
  return v;
};

const toId = (s) => slugify(String(s || ''), { lower: true, strict: true, replacement: '_' });

(async () => {
  const dataPath = path.join(__dirname, 'seed-data.json');
  const payload = JSON.parse(fs.readFileSync(dataPath, 'utf8'));

  const batchLimit = 450;
  const commitBatch = async (b) => { if (b._ops && b._ops.length) await b.commit(); };

  // classes
  if (Array.isArray(payload.classes)) {
    let batch = db.batch(); let n = 0;
    for (const c of payload.classes) {
      const id = toId(c.name || `class_${n+1}`);
      const ref = db.collection('classes').doc(id);
      const data = { ...c, createdAt: ts(c.createdAt) };
      batch.set(ref, data, { merge: true }); n++;
      if (n % batchLimit === 0) { await commitBatch(batch); batch = db.batch(); }
    }
    await commitBatch(batch); console.log(`Seeded ${payload.classes.length} classes`);
  }

  // users
  if (Array.isArray(payload.users)) {
    let batch = db.batch(); let n = 0;
    for (const u of payload.users) {
      const id = u.email ? toId(u.email.split('@')[0]) : toId(u.name || `user_${n+1}`);
      const ref = db.collection('users').doc(id);
      const data = { ...u, createdAt: ts(u.createdAt) };
      batch.set(ref, data, { merge: true }); n++;
      if (n % batchLimit === 0) { await commitBatch(batch); batch = db.batch(); }
    }
    await commitBatch(batch); console.log(`Seeded ${payload.users.length} users`);
  }

  // students
  if (Array.isArray(payload.students)) {
    let batch = db.batch(); let n = 0;
    for (const s of payload.students) {
      const id = toId(`${s.name}_${s.className || ''}`);
      const ref = db.collection('students').doc(id);
      const data = { ...s, createdAt: ts(s.createdAt) };
      batch.set(ref, data, { merge: true }); n++;
      if (n % batchLimit === 0) { await commitBatch(batch); batch = db.batch(); }
    }
    await commitBatch(batch); console.log(`Seeded ${payload.students.length} students`);
  }

  // stars
  if (Array.isArray(payload.stars)) {
    let batch = db.batch(); let n = 0;
    for (const st of payload.stars) {
      const id = toId(`${st.className || ''}_${st.studentName || ''}_${st.month || ''}`);
      const ref = db.collection('stars').doc(id);
      const data = { ...st, createdAt: ts(st.createdAt) };
      batch.set(ref, data, { merge: true }); n++;
      if (n % batchLimit === 0) { await commitBatch(batch); batch = db.batch(); }
    }
    await commitBatch(batch); console.log(`Seeded ${payload.stars.length} stars`);
  }

  console.log('✅ Firestore seed complete');
  process.exit(0);
})().catch((err) => { console.error('❌ Seed failed:', err); process.exit(1); });
