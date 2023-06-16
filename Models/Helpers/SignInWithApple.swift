//
//  SignInWithApple.swift
//  Fuji
//
//  Created by Maximilian Samne on 21.03.23.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import Firebase
import FirebaseFirestoreSwift
import RevenueCat

class SignInWithApple: ObservableObject {
    
    @Published var nonce = ""
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
    
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        // getting Token....
        guard let token = credential.identityToken else{
            print("error with firebase")
            return
        }
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            // User Successfully Logged Into Firebase...
            print("SignInWithApple: Logged In Success")
            
            // Create User in Firestore
            Task {
                do {
                    guard let userUID = Auth.auth().currentUser?.uid else { return }
                    let _ = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: UserModel.self)
                    await MainActor.run(body: {
                        self.user_UID = userUID
                        self.user_authenticated = true
                    })
                    
                } catch {
                    guard let userUID = Auth.auth().currentUser?.uid else { return }
                    let userUpload = UserModel(userUID: userUID, userNote: "")
                    let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: userUpload, completion: { error in
                        if error == nil {
                            print("SignInWithApple: User Upload Success")
                            self.user_UID = userUID
                            self.user_authenticated = true
                        }
                    })
                }
            }
        }
    }
}



func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}



