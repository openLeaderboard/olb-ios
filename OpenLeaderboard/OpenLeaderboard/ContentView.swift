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
        print("ooga booga")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
