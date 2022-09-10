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
                PreferenceViewTopComponent()
                
                ZStack{
                    VStack(alignment: .leading) {
                        if self.podcastViewModel.categories.isEmpty {
                            Section() {
                                ProgressView("Downloading…")
                                    .scaleEffect(2)
                                    .font(.body)
                            }
                        } else {
                            
                            ForEach(self.$podcastViewModel.categories, id: \.id) { $category in
                                // MARK: solution 1
                                Toggle(category.categories, isOn: $category.checked).toggleStyle(CheckBoxToggleStyle())
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding()
                                    .disabled(isFull == true && category.checked == false)
                                
                            }
                            .onChange(of: self.podcastViewModel.categories.filter {$0.checked}.count) { value in
                                self.isFull = value >= 3 ? true : false
                                if value == 3 {
                                    self.categoryList.removeAll()
                                    for category in self.podcastViewModel.categories.filter({$0.checked == true}) {
                                        self.categoryList.append(category.categories)
                                    }
                                }
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }.padding(1.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.orange.opacity(0.05))
                                .allowsHitTesting(false)
                                .frame(width: 356, height: 2250)
                                .addBorder(Color.orange, width: 2, cornerRadius: 5)
                        )
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
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
            self.userViewModel.user = Users(uuid: result?.user.uid ?? "", email: self.email, userName: "", profilePic: "", favoriteTopics: self.categoryList, uploadedList: [], watchedList: [], favoriteList: [])
            self.userViewModel.addUser()
            self.userViewModel.userSettings.uuid = result?.user.uid ?? ""
            self.loginSuccess = true
        }
    }
}

struct PreferenceSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreferenceSignUpView(email: .constant("ambinh01@example.com"), password: .constant("Password"))
        }
    }
}
