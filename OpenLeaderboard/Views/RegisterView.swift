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



class RegViewDelegate: ObservableObject {
    
    @Published var reg_email: String = ""
    @Published var reg_displayName: String = ""
    @Published var reg_pword: String = ""
    @Published var reg_confirmPword: String = ""

}


struct LoginView: View {
    
    
    @State var login_email: String = ""
    @State var login_pword: String = ""
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
                            
                            
                            NavigationLink(destination: RegView(delegate: RegViewDelegate())){
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
    
    @ObservedObject var delegate: RegViewDelegate
    
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
                        TextField("Email...", text: self.$delegate.reg_email)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        TextField("Display Name...", text: self.$delegate.reg_displayName)
                            .padding()
                            .foregroundColor(Color.blue)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        
                        SecureField("Password...", text: self.$delegate.reg_pword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        
                        SecureField("Confirm Password...", text: self.$delegate.reg_confirmPword)
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
                        
                        
                    }
                    .padding()
                    
                }
                .padding()
        )
    }
}

func register() {
//    print("registered")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegView(delegate: RegViewDelegate())
    }
}
