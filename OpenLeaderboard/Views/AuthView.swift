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

let apiURL = "http://localhost:5000"
let jwt = ""


struct LoginView: View {
    
    @State var login_email: String = ""
    @State var login_pword: String = ""
    
    @ObservedObject var auth = Auth()
    
    var body: some View {
        NavigationView{
            bgColor.edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Image("olb-image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        VStack {
                            TextField("Email...", text: $login_email)
                                .padding()
                                .foregroundColor(Color.blue)
                                .background(Color.white)
                                .cornerRadius(20.0)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                            
                            SecureField("Password...", text: $login_pword)
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
                            
                            
                            NavigationLink(destination: RegView(auth: Auth())){
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
    }
    
    func login() {
        print("I am logged in!")
    }
}


struct RegView: View {
    
    @ObservedObject var auth = Auth()
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State var reg_emailInUse = ""
    
    var body: some View {
        bgColor.edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Image("olb-image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        Text(reg_emailInUse)
                            .foregroundColor(Color.white)
                        TextField("Email...", text: self.$auth.reg_email)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        TextField("Display Name...", text: self.$auth.reg_displayName)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        
                        SecureField("Password...", text: self.$auth.reg_pword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        SecureField("Confirm Password...", text: self.$auth.reg_confirmPword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(.bottom, 30)
                        
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
                        .disabled(auth.hasValidRegistration == false)
                        
                        
                    }
                    .padding()
                    
                }
                .padding()
        )
            .alert(isPresented: $showingConfirmation) {
                Alert(title: Text("Registration Success!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        
        guard let encoded = try? JSONEncoder().encode(auth)
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
            
            print("data from server")
            print(request.httpBody)
            print(String(data: data, encoding: .utf8))
            print(data)
            
            if let decodedRegistration = try? JSONDecoder().decode(Auth.self, from: data) {
                print(decodedRegistration)
                self.confirmationMessage =
                "New User Email: \(decodedRegistration.$reg_email)\n" +
                "New User Display Name: \(decodedRegistration.$reg_displayName)\n" +
                "New User Password: \(decodedRegistration.$reg_pword)"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
    //
    //    let params = "email=\(reg_email)"
    //
    //    guard let url = URL(string: apiURL + "/user/register") else {
    //        fatalError("Registration URL not working")
    //    }
    //
    //    var request = URLRequest(url: url)
    //    request.httpMethod = "POST"
    //    request.httpBody = params.data(using: String.Encoding.utf8)
    //
    //    URLSession.shared.dataTask(with: request)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegView(auth: Auth())
    }
}
