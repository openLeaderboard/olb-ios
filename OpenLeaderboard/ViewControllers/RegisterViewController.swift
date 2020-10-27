//
//  RegisterViewModel.swift
//  OpenLeaderboard
//
//  Created by Parker Siroishka on 2020-10-26.
//  Copyright © 2020 OpenLeaderboard. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class RegisterViewController: UIViewController {
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        let delegate = RegViewDelegate()
        
        let controller = UIHostingController(rootView: RegView(delegate: delegate))
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalToConstant: 200),
            controller.view.heightAnchor.constraint(equalToConstant: 44),
            controller.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.cancellable = delegate.$reg_email.sink { email in
            print(email)
        }
    }
}
