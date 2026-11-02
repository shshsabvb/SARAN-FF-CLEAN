# SARAN-FF-CLEAN 1.1.1
Clean SwiftUI starter with an activation page only. It does not contain the original 3105 kernel-exploit or sandbox-escape components.

Open `SARAN-FF-CLEAN.xcodeproj` in Xcode. Scheme: `SARAN-FF-CLEAN`.
Activation request: POST `https://saran-ff-api.onrender.com/activate` with JSON `{ "key": "...", "device": "..." }`.

The app currently expects the API response to contain a boolean `success`, `valid`, or `activated` field. Confirm your server's actual response schema before production use.

Codemagic workflow: `ios-release`. Configure Apple signing and use your own registered bundle ID if needed. This is a starter app, not a recreation of the original 3105 app; device-level features are not included.
