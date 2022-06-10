//
//  PKCEFlowProvider.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation
import CryptoKit

/// Provides secure Code Varifier and Challange needed to implement a PKCE Extension Flow
final class PKCEFlowProvider {
    
    /// Singleton instance that provides the needed Code Varifier and Code Challange needed to implement a PKCE Extension Flow
    static let shared = PKCEFlowProvider(count: 32)
    
    /// PKCE Extension Flow Code Verifier
    var codeVerifier: String!
    
    /// PKCE Extension Flow Code Challange
    var codeChallange: String!
    
    private init(count: Int) {
        let octets = generateCryptographicallySecureRandomOctets(count: count)
        codeVerifier = generateCodeVerifier(octets: octets)
        codeChallange = generateChallange(for: codeVerifier)
    }
    
    /// Generate cryptographically secure random octets, used to create a Code Varifier.
    /// - Parameter count: The number of octets the function will generate. It is strongly recommended to use 32 octets,
    ///  since that is the amount needed to create a 43 character long string.
    ///  According to the PKCE specification a Code Verifier should be 43 - 128 charecters long.
    /// - Returns: Cryptographically secure random octets.
    private func generateCryptographicallySecureRandomOctets(count: Int) -> [UInt8] {
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
        if status == errSecSuccess {
            return octets
        } else {
            return [UInt8(9)]
        }
    }
    
    /// Generate a secure Code Varifier.
    /// - Parameter octets: Sequence of random UInt8 numbers, used to generate the Code Verifier.
    /// - Returns: Code Verifier String.
    private func generateCodeVerifier<S>(octets: S) -> String where S : Sequence, UInt8 == S.Element {
        let data = Data(octets)
        return data
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: .whitespaces)
    }
    
    /// Creates a Code Challange for a Code Varifier.
    /// - Parameter verifier: The Code Verifier, based on which the Code Challange is created.
    /// - Returns: Code Challange String.
    private func generateChallange(for verifier: String) -> String {
        let challenge = verifier
            .data(using: .ascii)
            .map { SHA256.hash(data: $0) }
            .map { generateCodeVerifier(octets: $0) }
        
        if let challenge = challenge {
            return challenge
        } else {
            fatalError("Failed to implement PKCE Flow")
        }
    }
}
