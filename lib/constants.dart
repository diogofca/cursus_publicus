const radiusforbuttons = 5.0;

/// UID of the account that writes letters (you). Fill in after creating the
/// account in the Firebase console — see README.md for setup steps.
const kAuthorUid = 'bY2PlRf0gRbNpMhkdEVUZQJWTaB3';

/// UID of the account that reads letters (her). Fill in after creating the
/// account in the Firebase console — see README.md for setup steps.
const kRecipientUid = 'm0m2iypPVgPji7fx2JmzKN37PcB3';

const kLettersCollection = 'letters';

const kAppName = 'Cursus Publicus';

/// This app runs on Firebase's free Spark plan — no Cloud Storage (that
/// requires the paid Blaze plan), so photos are compressed and embedded
/// directly in the Firestore document as base64. Firestore caps a document
/// at 1 MiB; these limits keep letters comfortably under that after
/// base64's ~33% overhead, leaving room for the title/body text.
const kMaxImagesPerLetter = 3;
const kMaxTotalImageBytes = 550 * 1024; // raw bytes, before base64 encoding
