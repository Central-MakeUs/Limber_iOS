//
//  DeviceID.swift
//  limber
//
//  Created by 양승완 on 8/11/25.
//


import Foundation
import Security
import UIKit

final class DeviceID {
    static let shared = DeviceID()
    private init() {}

    // Keychain 키 설정
    private let service = "com.seungwan.limber"
    private let account = "device_id"
//    private let accessGroup: String? = nil               // 앱/익스텐션 공유 시 "TEAMID.com.yourcompany.sharedkeychain" 등으로 설정

    /// 없으면 생성(UUID), 있으면 기존 값 반환
    func getOrCreate() throws -> String {
        if let existing = try read() {
            return existing
        }

        let base = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        try save(base)
        return base
    }

    /// Keychain에서 조회
    func read() throws -> String? {
      let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
//        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess,
              let data = item as? Data,
              let str = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedStatus(status)
        }
        return str
    }

    func save(_ value: String) throws {
        let data = Data(value.utf8)

        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
//        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if updateStatus == errSecSuccess { return }

        if updateStatus == errSecItemNotFound {
            // 없으면 새로 추가
            var addQuery = query
            addQuery[kSecValueData as String] = data
            // 백그라운드/익스텐션에서도 접근 가능하도록 접근성 설정(필요에 맞게 조정)
            addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.unexpectedStatus(addStatus)
            }
        } else {
            throw KeychainError.unexpectedStatus(updateStatus)
        }
    }

    /// 필요 시 삭제
    func delete() throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
//        if let accessGroup { query[kSecAttrAccessGroup as String] = accessGroup }

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    enum KeychainError: Error {
        case unexpectedStatus(OSStatus)
    }
}
