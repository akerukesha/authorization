//
//  Storyboard.swift
//  Authorization
//
//  Created by Akerke Okapova on 6/27/17.
//  Copyright © 2017 Akerke Okapova. All rights reserved.
//

import UIKit

private struct Constants {
    static let authorizationAndRegistrationStoryboardName = "Authorization"
    static let mainAuthorizationVCIdentifier = "MainAuthorizationView"
    static let emailVCIdentifier = "EmailView"
    static let passwordVCIdentifier = "PasswordView"
    static let tokenInfoVCIdentifier = "TokenInfo"
    static let userInfoVCIdentifier = "UserInfo"
    static let userProfileNavigationVCIdentifier = "UserProfileNavigationVC"
    static let userProfileTableVCIdentifier = "UserProfileTabelView"
}

struct Storyboard {
    
    private static let authorizationAndRegistrationStoryboard = UIStoryboard(name: Constants.authorizationAndRegistrationStoryboardName, bundle: nil)
    
    static var authorizationVC: UINavigationController {
        return authorizationAndRegistrationStoryboard
            .instantiateViewController(withIdentifier: Constants.mainAuthorizationVCIdentifier) as! UINavigationController
    }
    
    static var tokenInfoView: TokenInfoViewController {
        return authorizationAndRegistrationStoryboard.instantiateViewController(withIdentifier: Constants.tokenInfoVCIdentifier) as! TokenInfoViewController
    }
    
    static var userInfoView: UserInfoViewController {
        return authorizationAndRegistrationStoryboard.instantiateViewController(withIdentifier: Constants.userInfoVCIdentifier) as! UserInfoViewController
    }
    
    static var userProfileVC: UINavigationController {
        return authorizationAndRegistrationStoryboard
            .instantiateViewController(withIdentifier: Constants.userProfileNavigationVCIdentifier) as! UINavigationController
    }
}
