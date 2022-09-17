//
//  LoginView.swift
//  NPC
//
//  Created by Nguyen Le on 9/1/22.
//

import SwiftUI
import UserNotifications

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State var confirmPassword = ""
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @State var loginStatusMessage = ""
    @State var alert = false
    @State var loginSuccess = false
    @State private var isSecured: Bool = true
    @State private var btnClicked = false
    @State private var isActive : Bool = false
    
    @StateObject var userValidationControl = UserValidationControl()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routerView: RouterView
    
    @ObservedObject var notificationManager = LocalNotificationManager() // Notification
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink("", destination: SignUpView(email: $userValidationControl.email, password: $userValidationControl.password, userName: $username), isActive: Binding.constant(self.btnClicked && self.isLoginMode == false))
                    .isDetailLink(false)
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button {
                        withAnimation {
                            self.notificationManager.sendNotification(title: "Hurray!", subtitle: nil, body: "If you see this text, launching the local notification worked!", launchIn: 5)
                        }
                    } label: {
                        Image("transition")
                            .font(.system(size: 64))
                            .padding()
                    }
                    
                    if !isLoginMode {
                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: 380, height: 50)
                            .padding(0)
                            .overlay(
                                HStack {
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .trailing)
                                        .offset(x: 20, y: 0)
                                    TextField("Username", text: $username)
                                        .keyboardType(.emailAddress)
                                        .offset(x: 40, y: 0)
                                }
                            )
                            .padding(6)
                            .autocapitalization(.none)
                    }
                    
                    Capsule()
                    /* #f5f5f5 */
                        .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                        .frame(width: 380, height: 50)
                        .padding(0)
                        .overlay(
                            HStack {
                                Image(systemName: "envelope")
                                    .resizable()
                                    .frame(width: 36, height: 24, alignment: .trailing)
                                    .offset(x: 20, y: 0)
                                TextField("Email", text: $userValidationControl.email)
                                    .keyboardType(.emailAddress)
                                    .offset(x: 40, y: 0).foregroundColor(userValidationControl.inputValid ? .primary : .black)
                                userValidationControl.validationMessage.map { message in
                                    Text(message)
                                        .foregroundColor(.red)
                                }
                            }
                        )
                        .padding(6)
                        .autocapitalization(.none)
                    
                    Capsule()
                    /* #f5f5f5 */
                        .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                        .frame(width: 380, height: 50)
                        .padding(0)
                        .overlay(
                            HStack {
                                Image(systemName: "lock")
                                    .resizable()
                                    .frame(width: 20, height: 30, alignment: .trailing)
                                    .offset(x: 25, y: 0)
                                SecureField("Password", text: $userValidationControl.password)
                                    .offset(x: 60, y: 0)
                            }
                        )
                        .padding(6)
                        .background(Color.white)
                    
                    // Password check field
                    if !isLoginMode {
                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: 380, height: 50)
                            .padding(0)
                            .overlay(
                                HStack {
                                    Image(systemName: "lock")
                                        .resizable()
                                        .frame(width: 20, height: 30, alignment: .trailing)
                                        .offset(x: 25, y: 0)
                                    SecureField("Confirm password", text: $confirmPassword)
                                        .offset(x: 60, y: 0)
                                }
                            )
                            .padding(6)
                            .background(Color.white)
                    }
                    
                    // MARK: Login here
                    Button {
                        
                        self.btnClicked.toggle()
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color(red: 1, green: 0.4902, blue: 0.3216))
                    }
                    .padding(0)
                    .frame(width: 380, height: 50)
                }
            }
            .alert(isPresented: self.$alert, content: {
                Alert(title: Text("Error"), message: Text(self.loginStatusMessage))
            })
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.005))
                .ignoresSafeArea())
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationBarHidden(true)
        .onChange(of: self.loginSuccess) { value in
            if value {
                withAnimation {
                    self.routerView.currentPage = .bottomNavBar
                }
            }
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: userValidationControl.email, password: userValidationControl.password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.alert = true
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            self.userViewModel.userLogin(userID: result?.user.uid ?? "")
            self.loginSuccess = true
            showNotificationWhenLogin()
        }
    }
    
    private func allowShowNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {success, _ in
            guard success else {
                return
            }
            print("Succesfully Allow Notification")
        }
    }
    
    private func showNotificationWhenLogin() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome back"
        content.subtitle = "We have new updates for you"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
