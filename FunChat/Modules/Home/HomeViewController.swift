//
//  HomeViewController.swift
//  FunChat
//
//  Created by Can Yoldaş on 22.08.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class HomeViewController: UIViewController {
    
    private var handle: Auth?
    
    private let socialStack: SocialButtonStack = {
       let temp = SocialButtonStack()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    // MARK: LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            print(auth)
            print(user)
        } as? Auth
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        prepareUI()
    }
    
    
    // MARK: Prepare UI
    private func prepareUI() {
        view.addSubview(socialStack)
        
        let data = SocialButtonStackData(socials: [.apple,
                                                   .google,
                                                   .facebook,
                                                   .twitter])
        socialStack.setData(data: data)
        socialStack.delegate = self
        
        NSLayoutConstraint.activate([
        
            socialStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            socialStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            socialStack.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        socialStack.setupConstraints(superView: self.view)
    }
}


// MARK: SocialButton Delegate
extension HomeViewController: SocialButtonStackProtocol {
    
    func buttonClicked(socialType: SocialType) {
        LoginManager.shared.socialSignInClicked(socialType, view: self) { [weak self] result in
            print(result)
        }
    }
}
