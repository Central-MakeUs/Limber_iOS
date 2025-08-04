//
//  FirebaseManager.swift
//  limber
//
//  Created by 양승완 on 7/26/25.
//


import Foundation
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    private let collection = "sessions"

    private init() {}

    func upsertSession(newSession: FocusSessionDTO, completion: @escaping (Error?) -> Void) {
            let docRef = db.collection(collection).document(getDeviceUUID())

            docRef.getDocument { documentSnapshot, error in
                if let error = error {
                    completion(error)
                    return
                }

                var currentSessions: [FocusSessionDTO] = []

                if let document = documentSnapshot,
                   let data = document.data(),
                   let sessionDicts = data["focusSessions"] as? [[String: Any]] {
                    currentSessions = sessionDicts.compactMap { dict in
                        try? Firestore.Decoder().decode(FocusSessionDTO.self, from: dict)
                    }
                }

                if let index = currentSessions.firstIndex(where: { $0.name == newSession.name }) {
                    currentSessions[index] = newSession
                } else {
                    currentSessions.append(newSession)
                }

                do {
                    let encoded = try currentSessions.map { try Firestore.Encoder().encode($0) }
                    docRef.setData(["focusSessions": encoded], merge: true, completion: completion)
                } catch {
                    completion(error)
                }
            }
        }

    func fetchAllSessions(completion: @escaping ([FocusSessionDTO]?, Error?) -> Void) {
            let docRef = db.collection(collection).document(getDeviceUUID())

            docRef.getDocument { documentSnapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = documentSnapshot?.data(),
                      let sessionDicts = data["focuses"] as? [[String: Any]] else {
                    completion([], nil)
                    return
                }

                let sessions = sessionDicts.compactMap { dict in
                    try? Firestore.Decoder().decode(FocusSessionDTO.self, from: dict)
                }

                completion(sessions, nil)
            }
        }
    }
