//
//  ProfileView.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-31.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        
        VStack{
            Text("Displayname here").font(.largeTitle).bold()
            Divider()
            Text("Favourites").font(.system(size: 23)).padding(.top, 30)
            NavigationView {
                VStack {
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
        }.padding(.top, 50)
        
     
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
