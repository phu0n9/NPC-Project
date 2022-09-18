/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

import SwiftUI

// MARK: show user's profile and update
struct ProfileView: View {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var podcastViewModel = PodcastViewModel()
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var isSubmit = false
    @State var isFull = true
    @State var alert = false
    @State var updateStatus = ""
    @EnvironmentObject var routerView: RouterView
    @State var categoryList = [String]()

    var body: some View {
        NavigationView {
            if self.userViewModel.user.favoriteTopics.count != 3 {
                ProgressView("Loading...")
                    .scaleEffect(2)
                    .font(.body)
                    .padding()
                    .navigationBarHidden(true)
            } else {
                ScrollView {
        
                    VStack(spacing: 16) {
                        ZStack {
                            if selectedImage != nil {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        self.isPickerShowing = true
                                    }
                                    .padding(.top, 10)
                            } else {
                                if self.userViewModel.user.profilePic == "" {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            self.isPickerShowing = true
                                        }
                                        .padding(.top, 10)
                                } else {
                                    AsyncImage(url: URL(string: self.userViewModel.user.profilePic)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                self.isPickerShowing = true
                                            }
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .padding(.top, 10)
                                }
                                
                            }
                            
                            Image(systemName: "plus.circle.fill")
                                .renderingMode(.template)
                                .font(.system(size:25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(Color("MainButton"))
                                .offset(x: 30, y: 50)
                        }
                        HStack {
                            Text(self.userViewModel.user.userName)
                                .padding(5)
                                .foregroundColor(.gray)
                                .font(.system(size:16))
                            Text("|")
                                .padding(5)
                                .foregroundColor(.gray)
                                .font(.system(size:16))
                            Text(self.userViewModel.user.email)
                                .padding(5)
                                .foregroundColor(.gray)
                                .font(.system(size:16))
                        }

                        Text("Preference Podcast Topic")
                            .foregroundColor(.black)
                            .font(.system(size:19))
                            .padding(5)
                            .frame(width: 350, height: 40, alignment: .leading)

                        CategoryCheckbox(fetchCategoryList: self.$podcastViewModel.categories, isFull: self.$isFull, categoryList: self.$categoryList)
                            .padding(0)
                            .onAppear {
                                self.categoryList = self.userViewModel.user.favoriteTopics
                            }.padding(0)
                        
                        HStack {
                            Button {
                                self.handleUpdate()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Update")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 16, weight: .bold))
                                        .cornerRadius(20)
                                    Spacer()
                                }.background(Color(red: 1, green: 0.4902, blue: 0.3216))
                            }
                            .padding()
                            .frame(width: 140, height: 50)
                            .cornerRadius(20)
                            
                            Button {
                                signOutUser()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Log out")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 16, weight: .bold))
                                        
                                    Spacer()
                                }.background(.black)
                            }
                            .padding()
                            .frame(width: 140, height: 50)
                            .cornerRadius(20)
                        }

                    }
                }
                .navigationBarHidden(true)
            }
        }
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Status"), message: Text(self.updateStatus))
        })
        .onAppear {
            DispatchQueue.main.async {
                self.userViewModel.fetchUser()
                self.podcastViewModel.fetchCategories()
            }
        }
    }
    
    func handleUpdate() {
        self.alert = true
        if self.userViewModel.user.favoriteTopics.count == 3 {
            DispatchQueue.main.async {
                self.userViewModel.uploadPhoto(selectedImage: selectedImage, categoryList: self.categoryList)
            }
            self.updateStatus = "Update successfully"
        } else {
            self.updateStatus = "Update error"
        }
    }
    
    func signOutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            print("Successfully sign out")
            self.userViewModel.resetUserDefault()
            withAnimation {
                routerView.currentPage = .login
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
