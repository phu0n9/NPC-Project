//
//  PreferenceSignUpView.swift
//  NPC
//
//  Created by Le Nguyen on 05/09/2022.
//

import SwiftUI

struct SignUpView: View {
    @State var isLoginMode = false
    @Binding var email : String
    @Binding var password : String
    @Binding var userName: String
    
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @StateObject var podcastViewModel = PodcastViewModel()
    @State var loginStatusMessage = ""
    @State var alert = false
    @State var loginSuccess = false
    @State private var isSecured: Bool = true
    @State private var isFull : Bool = false
    @State private var categoryList = [String]()
    @EnvironmentObject var routerView: RouterView
    
    var body: some View {
        VStack(spacing: 16) {
            PrefTopComponent()
            if self.podcastViewModel.categories.isEmpty {
                Section {
                    ProgressView("Loading...")
                        .scaleEffect(2)
                        .font(.body)
                        .padding()
                }
            } else {
                ZStack {
                    VStack {
                        CategoryCheckbox(fetchCategoryList: self.$podcastViewModel.categories, isFull: $isFull, categoryList: self.$categoryList)
                        Button {
                            handleSignUpAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Sign Up")
                                    .font(.system(size: 26, weight: .semibold))
                                    .fontWeight(.regular)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .offset(x: -130)
                            }.padding(6.0).background(Color(red: 1, green: 0.4902, blue: 0.3216))}
                        .frame(width: 350, height:50)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchCategories()
            }
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"), message: Text(self.loginStatusMessage))
        })
        .onChange(of: self.loginSuccess) { _ in
            withAnimation {
                self.routerView.currentPage = .bottomNavBar
            }
        }
    }
    
    // MARK: Migrate SignUp Function
    private func handleSignUpAction() {
        guard isFull else {
            self.alert = true
            self.loginStatusMessage = "Please assign 3 topics"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.alert = true
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.userViewModel.user = Users(uuid: result?.user.uid ?? "", email: self.email, userName: self.userName, profilePic: "", favoriteTopics: self.categoryList)
            self.userViewModel.addUser()
            self.userViewModel.userSettings.uuid = result?.user.uid ?? ""
            self.loginSuccess = true
            showNotificationWhenSignUp()
        }
    }
    
    private func showNotificationWhenSignUp() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome to NPC"
        content.subtitle = "Update your profile picture"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView(email: .constant("ambinh01@example.com"), password: .constant("Password"), userName: .constant("hello"))
        }
    }
}
