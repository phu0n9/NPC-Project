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
        "play-icon",
        "todo",
        "mylist-icon",
        "user-icon"
    ]
    
    var body: some View {
        
        VStack {
 
            // MARK: contents
            ZStack {
                
                switch selectedIndex {
                case 0:
                    ViewComponent(destination: TrendingView(), viewTitle: "Trending")
                case 1:
                    ViewComponent(destination: CastingView(), viewTitle: "Casting")
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
                            Image(icons[number])
                                .font(.system(size:40,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background(Color.orange)
                                .cornerRadius(30)
                        } else {
                            Image(icons[number])
                                .font(.system(size:25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
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
