//
//  Alertable.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/9/21.
//

public protocol Alertable {}
public extension Alertable where Self: UIViewController {
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        
        print("This function is called alertable")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func showSimpleTwoOptionAlert(title: String = "Alert", messageTitle: String = "", body : String = "",  action : @escaping ()-> Void) {
        let alert = UIAlertController(title: title, message: body,         preferredStyle: .alert)

        // Change font and color of title
        alert.setTitle(font: UIFont(name: "LibreBaskerville-Bold", size: 16), color: UIColor(named: "toolbar-secondary-selection"))
        // Change font and color of message
        alert.setMessage(font: UIFont(name: "Lato-Regular", size: 14), color: UIColor(named: "color-gray1"))
        // Change background color of UIAlertController
        alert.setBackgroudColor(color: UIColor.white)
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: messageTitle,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        action()
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
}
