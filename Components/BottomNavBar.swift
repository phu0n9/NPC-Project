//
//  BottomNavBar.swift
//  NPC
//
//  Created by Le Nguyen on 01/09/2022.
//

import SwiftUI

struct BottomNavBar: View {
    
    @State var selectedIndex = 0
    
    // Styling topnavbar
    init() {
        let navbarApperance = UINavigationBarAppearance()
        
        navbarApperance.titleTextAttributes = [.foregroundColor:UIColor.systemBackground]
        navbarApperance.largeTitleTextAttributes = [.foregroundColor:UIColor.systemBackground]
        navbarApperance.backgroundColor = UIColor.orange
        navbarApperance.shadowColor = .orange
        UINavigationBar.appearance().standardAppearance = navbarApperance
        UINavigationBar.appearance().compactAppearance = navbarApperance
        UINavigationBar.appearance().scrollEdgeAppearance = navbarApperance
        UINavigationBar.appearance().tintColor = UIColor.systemBackground
    }

    let icons = [
        "podcasts-icon",
        "play.fill",
        "leaf.fill",
        "music.note.list",
        "person"
    ]

    var body: some View {
        
        VStack {
 
            // MARK: contents
            ZStack {
                
                switch selectedIndex {
                case 0:
                    ViewComponent(destination: TrendingView(), viewTitle: "Trending")
                case 1:
                    ViewComponent(destination: CastingView(currentTab: 0), viewTitle: "Casting")
                case 2:
                    ViewComponent(destination: UploadView(), viewTitle: "Uploading")
                case 3:
                    ViewComponent(destination: ActivityView(), viewTitle: "Activity")
                case 4:
                    ViewComponent(destination: ProfileView(), viewTitle: "Profile")
                default:
                    ViewComponent(destination: TrendingView(), viewTitle: "Trending")
                }
            }
            
            Divider()
            
            HStack {
                ForEach(0..<5, id: \.self) { number in
                    Spacer()
                    Button(action: {
                        self.selectedIndex = number
                    }, label: {
                        if number == 2 {
     
                            Image(systemName: "leaf.fill")
                                .renderingMode(.template)
                                .font(.system(size:25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                        else if number == 0 {
                            Image(icons[number])
                            .renderingMode(.template)
                            .font(.system(size:25,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                        else if number == 1 {
                            Image(systemName: "play.fill")
                            .renderingMode(.template)
                            .font(.system(size:25,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                        else if number == 3{
                            Image(systemName: "music.note.list")
                            .renderingMode(.template)
                            .font(.system(size:25,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                        else if number == 4{
                            Image(systemName: "person")
                            .renderingMode(.template)
                            .font(.system(size:25,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                        else {
                            Image(icons[number])
                                .renderingMode(.template)
                                .font(.system(size:25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedIndex == number ? Color("MainButton") : Color(UIColor.gray))
                        }
                    })
                    
                    Spacer()
                }
            }
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
    }
}
