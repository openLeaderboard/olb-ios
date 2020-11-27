//
//  ContentView.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-17.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import SwiftUI
import UIKit

let bgColor = Color(red: 94.0/255.0, green: 92.0/255.0, blue: 230.0/255.0, opacity: 1.0)
let btnColor = Color(red: 249.0/255.0, green: 238.0/255.0, blue: 230.0/255.0, opacity: 1.0)

let apiURL = "http://127.0.0.1:5000"
let jwt = ""

struct LoginView: View {
    
    @State var login_email: String = ""
    @State var login_pword: String = ""
    @ObservedObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        if (!userData.loggedIn) {
            NavigationView {
                bgColor.edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack {
                            Image("olb-image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            VStack {
                                TextField("Email...", text: self.$loginViewModel.email)
                                    .padding()
                                    .foregroundColor(Color.blue)
                                    .background(Color.white)
                                    .cornerRadius(20.0)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                
                                SecureField("Password...", text: self.$loginViewModel.password)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20.0)
                                    .padding(.bottom, 30)
                                
                                Button(action: loginAction) {
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("Login").foregroundColor(bgColor).bold()
                                        Spacer()
                                    }
                                }
                                .padding().background(btnColor)
                                .cornerRadius(20.0)
                                .buttonStyle(PlainButtonStyle())
                                
                                
                                NavigationLink(destination: RegView(authViewModel: AuthViewModel())) {
                                    Text("Create Account")
                                        .foregroundColor(Color.white)
                                        .underline()
                                        .padding(.top)
                                }.navigationBarTitle(Text(""))
                            }
                            .padding()
                        }
                        .padding()
                )
            }.accentColor(Color.white)
        } else {
            TabParent().environmentObject(userData)
        }
    }
    
    func loginAction() {
        struct LoginToken: Decodable {
            let success: Bool
            let message: String
            let access_token: String
        }
        
        guard let encoded = try? JSONEncoder().encode(loginViewModel)
            else {
                print("Failed to encode login")
                return
        }
        
        let url = URL(string: (apiURL + "/auth/login"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            if let loginToken = try? JSONDecoder().decode(LoginToken.self, from: data) {
                if (loginToken.success) {
                    self.userData.loggedIn = true
                    self.userData.access_token = loginToken.access_token
                }
            } else {
                print("Invalid response from server")
                print(data, LoginToken.self)
            }
        }.resume()
    }
}


struct RegView: View {
    
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var confirmPword: String = ""
    @State var reg_emailInUse = ""
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            bgColor.edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Image("olb-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack {
                            Text(reg_emailInUse)
                                .foregroundColor(Color.white)
                            TextField("Email...", text: self.$authViewModel.email)
                                .padding()
                                .foregroundColor(Color.blue)
                                .background(Color.white)
                                .cornerRadius(20.0)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            
                            TextField("Display Name...", text: self.$authViewModel.name)
                                .padding()
                                .foregroundColor(Color.blue)
                                .background(Color.white)
                                .cornerRadius(20.0)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            
                            
                            SecureField("Password...", text: self.$authViewModel.password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20.0)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            
                            SecureField("Confirm Password...", text: $confirmPword)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20.0)
                                .padding(.bottom, 30)
                            
                            NavigationLink(destination: LoginView()){
                                Button(action: register) {
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("Register").foregroundColor(bgColor).bold()
                                        Spacer()
                                    }
                                }
                                .padding().background(btnColor)
                                .cornerRadius(20.0)
                                .buttonStyle(PlainButtonStyle())
                            }.navigationBarTitle(Text(""))
                        }
                        .padding()
                    }
                    .padding()
            ).alert(isPresented: $showingConfirmation) {
                    Alert(title: Text("Registration Success!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func register() {
        struct RegistrationToken: Decodable {
            let success: Bool
            let message: String
            let access_token: String
        }
        
        guard let encoded = try? JSONEncoder().encode(authViewModel)
            else {
                print("Failed to encode registration")
                return
        }
        
        let url = URL(string: (apiURL + "/user/register"))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let registrationToken = try? JSONDecoder().decode(RegistrationToken.self, from: data) {
                if registrationToken.success {
                    self.userData.loggedIn = true
                    self.userData.access_token = registrationToken.access_token
                }
//                self.confirmationMessage =
//                    "User Created?: \(registrationToken.success)\n" +
//                    "User Created Message: \(registrationToken.message)\n" +
//                    "User Access Token (JWT): \(registrationToken.access_token)"
//                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel()).environmentObject(UserData())
    }
}
