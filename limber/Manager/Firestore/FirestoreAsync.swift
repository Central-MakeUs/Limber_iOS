import FirebaseCore
import FirebaseFirestore

enum FirestoreAsync {
  static func getDocument(_ ref: DocumentReference) async throws -> DocumentSnapshot {
    try await withCheckedThrowingContinuation { cont in
      ref.getDocument { snapshot, error in
        if let snapshot {
          cont.resume(returning: snapshot)
        } else if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(throwing: NSError(domain: "Firestore", code: -1))
        }
      }
    }
  }

  static func getDocuments(_ query: Query) async throws -> QuerySnapshot {
    try await withCheckedThrowingContinuation { cont in
      query.getDocuments { snapshot, error in
        if let snapshot {
          cont.resume(returning: snapshot)
        } else if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(throwing: NSError(domain: "Firestore", code: -1))
        }
      }
    }
  }

  static func setData(_ ref: DocumentReference, data: [String: Any], merge: Bool = false) async throws {
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
      ref.setData(data, merge: merge) { error in
        if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(returning: ())
        }
      }
    }
  }

  static func updateData(_ ref: DocumentReference, data: [AnyHashable: Any]) async throws {
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
      ref.updateData(data) { error in
        if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(returning: ())
        }
      }
    }
  }

  static func delete(_ ref: DocumentReference) async throws {
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
      ref.delete { error in
        if let error {
          cont.resume(throwing: error)
        } else {
          cont.resume(returning: ())
        }
      }
    }
  }
}
