

import UIKit
import CDockFramework

@objc(CustomElementsFunctionsSwift)

/**
 In this class you can handle callback from ContentDock SDK
 */
class CustomElementsFunctionsSwift: NSObject {
    

    /**
     This function calls when user custom elements initilized.
     Name of this function you can set in ContentDock admin panel
     - parameters:
        - elementView: UIView for your custom element
     */
    @objc class func myElementFunction(_ elementView: UIView) {
        
    }
    
    
    /**
     Calls when user custom element been layouted(size changed, positions change and etc...)
     - parameters:
        - elementView: UIView for your redrawed element
     */
    @objc class func layoutSubviews(_ elementView: UIView) {

    }
    
    
    /**
     Calls before device will rotate.
     - parameters:
        - orientation: Orientation that device will rotate to. You can use it as
        UIInterfaceOrientation(rawValue: orientation.intValue)
     */
    @objc class func willRotateTo(_ orientation: NSNumber) {
        if let newOrientation: UIInterfaceOrientation = UIInterfaceOrientation(rawValue: orientation.intValue) {
            if newOrientation == .landscapeLeft || newOrientation == .landscapeRight {
                //do something cool
            }
        }
    }
    
    
    /**
     Calls after device been  rotated.
     */
    @objc class func didRotate() {
        let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            //do something cool
        }
    }
    
    /**
     App Start
     */
    @objc class func appStarted() {
        let vc = UIStoryboard(name: "CustomUI", bundle: nil).instantiateViewController(withIdentifier: "VCCustomTabs") as! UITabBarController
        let nc = UINavigationController(rootViewController: vc)
        CDockSDK.showCustomVC(nc)
    }
}


