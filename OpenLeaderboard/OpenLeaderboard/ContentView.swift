//
//  ContentView.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-17.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import SwiftUI
let bgColor = Color(red: 94.0/255.0, green: 92.0/255.0, blue: 230.0/255.0, opacity: 1.0)
let btnColor = Color(red: 249.0/255.0, green: 238.0/255.0, blue: 230.0/255.0, opacity: 1.0)
let bronze = Color(red: 221.0/255.0, green: 167.0/255.0, blue: 123.0/255.0, opacity: 1.0)
let silver = Color(red: 198.0/255.0, green: 185.0/255.0, blue: 169.0/255.0, opacity: 1.0)
let gold = Color(red: 255.0/255.0, green: 191.0/255.0, blue: 0.0/255.0, opacity: 1.0)
let platinum = Color(red: 152.0/255.0, green: 193.0/255.0, blue: 217.0/255.0, opacity: 1.0)

struct ContentView: View {
    
    
    @State var email: String = ""
    @State var pword: String = ""
    var body: some View {
        bgColor.edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Image("olb-image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        TextField("Email...", text: $email)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        SecureField("Password...", text: $pword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                                .padding(.bottom, 30)
                        
                        Button(action: login) {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("Login").foregroundColor(bgColor).bold()
                                    Spacer()
                                }
                        }
                        .padding().background(btnColor)
                        .cornerRadius(20.0)
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        Text("Create Account")
                        .foregroundColor(Color.white)
                        .underline()
                        .padding(.top)
                    }
                    .padding()
                    
                }
                .padding()
    )
    }
    
    func login() {
        print("I am logged in!")
    }
}

struct Register: View {
    
    
    @State var email: String = ""
    @State var displayName: String = ""
    @State var pword: String = ""
    @State var confirmPword: String = ""
    var body: some View {
        bgColor.edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Image("olb-image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        TextField("Email...", text: $email)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        TextField("Display Name...", text: $displayName)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        
                        SecureField("Password...", text: $pword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        SecureField("Confirm Password...", text: $confirmPword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                                .padding(.bottom, 30)
                        
                        Button(action: login) {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("Register").foregroundColor(bgColor).bold()
                                    Spacer()
                                }
                        }
                        .padding().background(btnColor)
                        .cornerRadius(20.0)
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .underline()
                            .padding(.top)
                        
                    }
                    .padding()
                    
                }
                .padding()
    )
    }
    
    func login() {
        print("I am signed up!")
    }
}

struct TabParent: View {
    var body: some View {
        TabView {
            ProfileView()
             .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
              }
            MainBoardsView()
              .tabItem {
                 Image(systemName: "list.bullet")
                 Text("Boards")
               }
            AddBoardView()
              .tabItem {
                 Image(systemName: "plus")
                 Text("Add Board")
               }
            SearchView()
              .tabItem {
                 Image(systemName: "magnifyingglass")
                 Text("Search")
               }
            NotificationsView()
              .tabItem {
                 Image(systemName: "bell.fill")
                 Text("Notifications")
               }
           
        }.accentColor(bgColor)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
    }
}

struct MainBoardsView: View {
    
    @State private var menuIndex: Int = 0
    var body: some View {
        VStack {
            Picker("Boards Index", selection: $menuIndex) {
                Text("All Boards")
                Text("My Boards")
            }.pickerStyle(SegmentedPickerStyle())
            Spacer()
            List {
                HStack {
                    Image(systemName: "seal.fill").foregroundColor(platinum)
                    VStack (alignment: .leading) {
                        Text("Joel's Board")
                        Text("#1 of 56")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 105))
                    VStack (alignment: .trailing){
                        Text("2100")
                        Text("57W / 10L")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    Image(systemName: "chevron.right").padding(EdgeInsets(top: 0, leading: 27, bottom: 0, trailing: 0)).foregroundColor(.gray)
                }
            }
        }
    }
}

struct AddBoardView: View {
    var body: some View {
        Text("Add Boards Screen")
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search Screen")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("Notifications Screen")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabParent()
    }
}
