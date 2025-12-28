import FirebaseAuth

final class FirebaseAuthManager {
  static let shared = FirebaseAuthManager()

  private init() {}

  func ensureSignedIn() async throws -> String {
    if let user = Auth.auth().currentUser {
      return user.uid
    }
    return try await withCheckedThrowingContinuation { cont in
      Auth.auth().signInAnonymously { result, error in
        if let error {
          cont.resume(throwing: error)
        } else if let uid = result?.user.uid {
          cont.resume(returning: uid)
        } else {
          cont.resume(throwing: NSError(domain: "FirebaseAuth", code: -1))
        }
      }
    }
  }

  func ensureUserId() async throws -> String {
    let stored = SharedData.defaultsGroup?.string(forKey: SharedData.Keys.UDID.key) ?? ""
    if !stored.isEmpty {
      return stored
    }
    let uid = try await ensureSignedIn()
    SharedData.defaultsGroup?.set(uid, forKey: SharedData.Keys.UDID.key)
    return uid
  }
}
