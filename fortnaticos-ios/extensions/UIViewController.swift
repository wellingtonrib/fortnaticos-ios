import UIKit

extension UIViewController {
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        if let tabBarController = self.tabBarController, let searchBar = tabBarController.navigationItem.titleView as? UISearchBar {
            searchBar.endEditing(true)
        }
    }
    
    func toggleNavigationBarTransparent(toggle: Bool) {
        if toggle {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barStyle = .black            
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.backgroundColor = AppColor.primaryColorDark
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.barStyle = .default
        }        
    }
    
    @objc func presentBy(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.barTintColor = AppColor.primaryColor
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Fechar", style: .plain, target: self, action: #selector(self.finish))
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func finish() {
        if let navigationController = self.navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        } else {
            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    typealias TextFieldHandler = ((UITextField) -> Void)
    
    func alert(title : String, message : String,
               textFieldsHandlers: [TextFieldHandler] = [],
               positiveButton : String = "Ok", positiveHandler : ((UIAlertController, UIAlertAction) -> Void)? = nil,
               negativeButton : String? = nil, negativeHandler : ((UIAlertController, UIAlertAction) -> Void)? = nil,
               neutralButton : String? = nil, neutralHandler : ((UIAlertController, UIAlertAction) -> Void)? = nil,
               preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        
        let uiAlert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        uiAlert.setTitleFont(font: UIFont(name: AppFonts.regularFont, size: 17), color: .black)
        
        uiAlert.setMessageFont(font: UIFont(name: AppFonts.regularFont, size: 14), color: .black)
        
        for textFieldsHandler in textFieldsHandlers {
            uiAlert.addTextField(configurationHandler: textFieldsHandler)
        }
        
        let positiveAction = UIAlertAction(title: positiveButton, style: UIAlertAction.Style.default, handler: { action in
            positiveHandler?(uiAlert, action)
        })
        uiAlert.addAction(positiveAction)
        
        if negativeButton != nil {
            let negativeAction = UIAlertAction(title: negativeButton, style: UIAlertAction.Style.cancel, handler: { action in
                negativeHandler?(uiAlert, action)
            })
            uiAlert.addAction(negativeAction)
        }
        
        if neutralButton != nil {
            let neutralAction = UIAlertAction(title: neutralButton, style: UIAlertAction.Style.default, handler: { action in
                neutralHandler?(uiAlert, action)
            })
            uiAlert.addAction(neutralAction)
        }
                        
        self.present(uiAlert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                uiAlert.textFields?.first?.becomeFirstResponder()
            }
        })
        
        return uiAlert
    }
    
    func showBlockingWaitOverlayWithText(text: String) {
        SwiftOverlays.showBlockingWaitOverlayWithText(text)
    }
    
    func removeAllBlockingOverlays() {
        SwiftOverlays.removeAllBlockingOverlays()
    }
    
    func getWindow() -> UIWindow {
        // iOS13 or later
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            return sceneDelegate.window!
        // iOS12 or earlier
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.window!
        }
    }
        
}
