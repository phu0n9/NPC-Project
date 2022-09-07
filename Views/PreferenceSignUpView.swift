//
//  PreferenceSignUpView.swift
//  NPC
//
//  Created by Le Nguyen on 05/09/2022.
//

import SwiftUI

struct PreferenceSignUpView: View {
    @State var isLoginMode = false
    @Binding var email : String
    @Binding var password : String
    
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @StateObject var podcastViewModel = PodcastViewModel()
    @State var loginStatusMessage = ""
    @State var alert = false
    @State var loginSuccess = false
    @State private var isSecured: Bool = true
    @State private var isFull : Bool = false
    @State private var categoryList = [String]()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button {
                } label: {
                    Image("transition")
                        .font(.system(size: 64))
                        .padding()
                }
                Text("Create Your Account")
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .font(.system(size: 26, weight: .semibold))
                Text("Tell us about your preference topic")
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .font(.system(size: 16, weight: .semibold))
                ZStack {
                    VStack(alignment: .trailing, spacing: 6) {
                        ForEach(self.$podcastViewModel.categories, id: \.id) { $category in
                            // MARK: solution 1
                            Toggle(category.categories, isOn: $category.checked).toggleStyle(CheckBoxToggleStyle())
                                .font(.system(size: 20, weight: .semibold))
                                .padding()
                                .disabled(isFull == true && category.checked == false)
                            
                            // MARK: solution 2
                            //                            HStack {
                            //                                Image(systemName: category.checked ? "checkmark.square" : "square")
                            //                                    .toggleStyle(CheckBoxToggleStyle())
                            //                                    .onTapGesture {
                            //                                        category.checked.toggle()
                            //                                    }
                            //                                Spacer()
                            //                                Text(category.categories)
                            //                            }
                        }
                        .onChange(of: self.podcastViewModel.categories.filter {$0.checked}.count) { value in
                            self.isFull = value >= 3 ? true : false
                            if value == 3 {
                                self.categoryList.removeAll()
                                for category in self.podcastViewModel.categories.filter({$0.checked == true}) {
                                    self.categoryList.append(category.categories)
                                }
                            }
                        }
                    }.padding()
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.orange.opacity(0.07))
                        .allowsHitTesting(false)
                        .frame(width: 356, height: 263)
                }
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
        .onAppear {
            DispatchQueue.main.async {
                self.podcastViewModel.fetchCategories()
            }
        }
    }
    
    // MARK: Migrate SignUp Function
    private func handleSignUpAction() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.alert = true
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.userViewModel.user = Users(uuid: result?.user.uid ?? "", email: self.email, userName: "", profilePic: "", favoriteTopics: self.categoryList, uploadedList: [])
            self.userViewModel.addUser()
            self.userViewModel.userSettings.uuid = result?.user.uid ?? ""
            self.loginSuccess = true
        }
    }
    
    // MARK: Email validation
    private func validView() -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        }
        
        if !self.isValidEmail(email) {
            return "Email is invalid"
        }
        
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct PreferenceSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreferenceSignUpView(email: .constant("ambinh01@example.com"), password: .constant("Password"))
        }
    }
}