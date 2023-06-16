//
//  DeleteAccountSheet.swift
//  Fuji
//
//  Created by Maximilian Samne on 09.04.23.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseFirestoreSwift

struct DeleteAccountSheet: View {
    
#if os(iOS)
    var circleWidth: CGFloat = UIScreen.main.bounds.size.width
    var minWidth: CGFloat = UIScreen.main.bounds.size.width
    var minHeight: CGFloat = UIScreen.main.bounds.size.height
    
#elseif os(macOS)
    var circleWidth: CGFloat = 345
    var minWidth: CGFloat = 500
    var minHeight: CGFloat = 700
    
#endif
    
    @AppStorage("user_UID") var user_UID: String = ""
    @AppStorage("user_greeting") var user_greeting: String = ""
    @AppStorage("user_dial") var user_dial: String = "Yellow"
    @AppStorage("original_time") var original_time: Double = 1200
    @AppStorage("user_morning") var user_morning: Int = 8
    @AppStorage("user_midday") var user_midday: Int = 12
    @AppStorage("user_evening") var user_evening: Int = 18
    @AppStorage("user_night") var user_night: Int = 21
    @AppStorage("user_welcomeSeen") var user_welcomeSeen: Bool = false
    @AppStorage("user_dialThinL") var user_dialThinL: Bool = false
    @AppStorage("user_dialThinD") var user_dialThinD: Bool = false
    @AppStorage("user_authenticated") var user_authenticated: Bool = false
#if os(macOS)
    @AppStorage("view_tasks") var view_tasks: Bool = false
    @AppStorage("view_dial") var view_dial: Bool = false
    @AppStorage("view_combo") var view_combo: Bool = true
#endif
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkModel: NetworkModel
    
    @StateObject var loginData = SignInWithApple()
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var recentlySignedIn: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var isDeleting: Bool = false
    @Binding var showDeleteAccountSheet: Bool
    
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("We're sorry to see you go")
                    .font(.system(.title3, design: .rounded, weight: .regular))
                    .foregroundColor(Color("Contrast"))
                
                // I can add survey questions here in the future, that go to firebase appInfo doc
                
                Spacer()
                
                if networkModel.connected {
                    Text("To delete your account, please re-verify your account by signing in:")
                        .font(.system(.body, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                        .padding(.bottom, 30)
                    
                    if colorScheme == .light {
                        SignInWithAppleButton { (request) in
                            // requesting paramertes from apple login...
                            isSigningIn = true
                            loginData.nonce = randomNonceString()
                            request.nonce = sha256(loginData.nonce)
                            
                        } onCompletion: { (result) in
                            // getting error or success...
                            switch result {
                            case .success(let user):
                                print("Case: Success")
                                // do Login With Firebase...
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error with firebase")
                                    return
                                }
                                loginData.authenticate(credential: credential)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isSigningIn = false
                                    recentlySignedIn = true
                                }
                            case.failure(let error):
                                print(error.localizedDescription)
                                isSigningIn = false
                            }
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(width: 200, height: 40)
#if os(iOS)
                        .clipShape(Capsule())
#endif
                        .disabled(isSigningIn)
                        
                    } else {
                        SignInWithAppleButton { (request) in
                            isSigningIn = true
                            loginData.nonce = randomNonceString()
                            request.nonce = sha256(loginData.nonce)
                            
                        } onCompletion: { (result) in
                            switch result {
                            case .success(let user):
                                print("Case: Success")
                                // do Login With Firebase...
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error with firebase")
                                    return
                                }
                                loginData.authenticate(credential: credential)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isSigningIn = false
                                    recentlySignedIn = true
                                }
                                
                            case.failure(let error):
                                print(error.localizedDescription)
                                isSigningIn = false
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(width: 200, height: 40)
#if os(iOS)
                        .clipShape(Capsule())
#endif
                        .disabled(isSigningIn)
                    }
                    
                    if isSigningIn {
                        Text("Signing in...")
                            .font(.system(.footnote, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .frame(height: 40)
                            .padding(.bottom, 16)
                    } else {
                        Spacer()
                            .frame(height: 40)
                            .padding(.bottom, 16)
                    }
                    
                    if recentlySignedIn {
                        Button {
                            showDeleteConfirmation.toggle()
                        } label: {
                            Text("Delete Account")
                                .font(.system(.callout, design: .rounded, weight: .light))
                                .foregroundColor(Color("Contrast"))
                                .padding(4)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .padding(.bottom, 20)
                    } else {
                        Spacer()
                            .frame(height: 47.5)
                    }
                    
                    Spacer()
                    
                    Button {
                        showDeleteAccountSheet = false
                        showDeleteConfirmation = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(.body, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    
                } else {
                    Text("Connect to a network to continue 🫧")
                        .font(.system(.body, design: .rounded, weight: .light))
                    Spacer()
                }
            }
            .padding(25)
            .alert(errorMessage, isPresented: $showError) {
            }
        }
        .sheet(isPresented: $showDeleteConfirmation) {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Deleting your account will permanently reset all your progress, and delete all information associated with your account. \n\nYou can create a new account at any time after deleting, if you wish 😊.")
                        .font(.system(.callout, design: .rounded, weight: .light))
                        .foregroundColor(Color("Contrast"))
                    
                    Spacer()
                    Button {
                        Task {
                            await deleteAccount()
                        }
                    } label: {
                        Text("Delete Account")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(Color("OrangeDark"))
                            .padding(10)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    
                    
                    Spacer()
                    
                    Button {
                        showDeleteAccountSheet = false
                        showDeleteConfirmation = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(.body, design: .rounded, weight: .light))
                            .foregroundColor(Color("Contrast"))
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
                .padding(25)
                .frame(width: minWidth)
            }
            .presentationDetents([.height(minHeight*0.4)])
        }
        .disabled(isSigningIn || isDeleting)
    }
    
    func deleteAccount() async {
        isDeleting = true
        print("Checking guard for User UID")
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        print("UserUID check success, deleting")
        do {
            let userTasksArray = try await Firestore.firestore().collection("Tasks").whereField("userUID", isEqualTo: userUID).getDocuments()
            print("found task array")
            for userTask in userTasksArray.documents {
                try await deleteUserTasks(userTask: userTask.data(as: TaskModel.self))
            }
            print("deleted each task in task array")
            try await Firestore.firestore().collection("Users").document(userUID).delete()
            print("deleted user document")
            try await Auth.auth().currentUser?.delete()
            print("deleted user auth")
            await MainActor.run(body: {
                user_welcomeSeen = false
                user_authenticated = false
                user_UID = ""
                user_greeting = ""
                user_dial = "Yellow"
                original_time = 1200
                user_morning = 8
                user_midday = 12
                user_evening = 18
                user_night = 21
                user_dialThinL = false
                user_dialThinD = false
                showDeleteAccountSheet = false
                showDeleteConfirmation = false
#if os(macOS)
                view_tasks = false
                view_dial = false
                view_combo = true
#endif
                isDeleting = false
            })
        } catch {
            await setError(error)
        }
    }
    
    func deleteUserTasks(userTask: TaskModel) async throws {
        guard let taskID = userTask.id else { return }
        try await Firestore.firestore().collection("Tasks").document(taskID).delete()
    }
    
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isDeleting = false
        })
    }
}

struct DeleteAccountSheet_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountSheet(showDeleteAccountSheet: .constant(false))
            .environmentObject(NetworkModel())
    }
}
