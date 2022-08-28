//
//  LoginManager.swift
//  FunChat
//
//  Created by Can Yoldaş on 27.08.2022.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

typealias LoginHandler = (LoginResult) -> Void


enum LoginResult {
    case success
    case failed(Error)
}


class LoginManager {
    
    static let shared = LoginManager()
    
    private init() { }
    
    func socialSignInClicked(
        _ socialType: SocialType,
        view: UIViewController,
        completion: @escaping LoginHandler
    ) {
        switch socialType {
        case .google:
            googleSignIn(viewController: view, completion: completion)
        default:
            break
        }
    }
    
    private func googleSignIn(viewController: UIViewController, completion: @escaping LoginHandler) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [weak self] user, error in
            if let error = error {
                completion(.failed(error))
                return // handle error
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            self?.authenticateUser(with: credential)
        }
    }
    
    private func authenticateUser(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            print(authResult)
            return
        }
    }
}

