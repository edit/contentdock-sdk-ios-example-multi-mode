//
//  VCCustomLogin.swift
//  TEVDesigned
//
//  Created by Kirill Pyulzyu on 28/01/2019.
//  Copyright © 2019 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomLogin: UIViewController {
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var lblPass: UILabel!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLogout: UIButton!

    @IBAction func onBtnLogoutTapped(_ sender: Any) {
        CDockSDK.logOut()
        self.refreshState()
    }
    
    @IBAction func onBtnLogInTapped(_ sender: Any) {
        CDockSDK.login(with: self.tfLogin.text, password: self.tfPass.text, domain: CDockSDK.domain()) {[weak self] isSuccess in
            if isSuccess == false {
                let alert = UIAlertView(title: "", message: "Login failed", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            self?.refreshState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshState()
    }

    func refreshState() {
        if CDockSDK.isLoggedIn() {
            tfLogin.alpha = 0.5
            tfLogin.isUserInteractionEnabled = false
            btnLogout.isHidden = false
            btnLogin.isHidden = true
            tfPass.isHidden = true
            lblPass.isHidden = true
        }
        else {
            tfLogin.alpha = 1
            tfLogin.isUserInteractionEnabled = true
            btnLogout.isHidden = true
            btnLogin.isHidden = false
            tfPass.isHidden = false
            lblPass.isHidden = false
        }
    }
}
