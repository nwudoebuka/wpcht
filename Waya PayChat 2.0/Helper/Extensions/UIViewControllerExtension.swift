import SystemConfiguration

extension UIViewController {
    
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    class func  controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isInternetAvailable() -> Bool{
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    @objc func keyboardWillShowShortView(sender: NSNotification) {
        self.view.frame.origin.y = -50 // Move view 150 points upward 
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward 
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position  
    }
    
    @objc func keyboardWasShownLongView(sender: NSNotification) {
        self.view.frame.origin.y = -200 // Move view 150 points upward 
    }
    
    @objc func keyboardWasShownBottomView(sender: NSNotification) {
        
        self.view.frame.origin.y = -250 // Move view 150 points upward 
    }
    
    
    func showComingSoonView(){
        let comingSoonView = ComingSoonView()
        view.addSubview(comingSoonView)
        comingSoonView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        comingSoonView.centerInSuperview()
        
    }
    
    func checkChangeNaviagtionStyle(){
        if self.navigationController?.navigationBar != nil{

            
            let navigationTitleFont = UIFont(name: "LibreBaskerville-Bold", size: 16) ?? UIFont()
       
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont,
                                                                            NSAttributedString.Key.foregroundColor: UIColor(named: "toolbar-color-secondary") ?? UIColor.black]
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func generateQRCodeAndConvert(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5) // Scale according to imgView
            if let output = filter.outputImage?.transformed(by: transform) {
                return convert(output)
            }
        }
        return nil
    }
    
    private func convert(_ cmage:CIImage) -> UIImage? {
        let context:CIContext = CIContext(options: nil)
        guard let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent) else { return nil }
        let image:UIImage = UIImage(cgImage: cgImage)
        return image
    }
    
    func saveImageToAppMemory(image : UIImage?, fileName: String = "image.png"){
        if let image = image {

            if let data = image.pngData() {
                let filename = getDocumentsDirectory().appendingPathComponent(fileName)
                try? data.write(to: filename)
                print("Save tp device")
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func writeToPhotoAlbum(image: UIImage?) {
        guard let image = image else { return }
        print("The image ")
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func restoreNavLine(){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil
    func getUserIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }

    func libreTextBold22(text: String, textSize : CGFloat = 22, color : UIColor = UIColor(named: "toolbar-color-secondary") ?? .gray) -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "LibreBaskerville-Bold", size: textSize)
        return label
    }
    
    
    func libreTextRegular22(text: String, textSize : CGFloat = 16, color : UIColor = UIColor(named: "toolbar-color-secondary") ?? .gray) -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "LibreBaskerville-Regular", size: textSize)
        return label
    }
    
    func latoGrayText16(text: String) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "color-gray1")
        return label
    }
    
    
    func customPrimaryButton(text: String) -> UIButton{
        let button = UI.button(title: text)
        return button
    }
    
    func generateUIImageView(imageName: String) -> UIImageView{
        let imageV = UIImageView()
        imageV.image = UIImage(named: imageName)        
        return imageV
    }

    

    
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {
        
        // Creates a new UIView
        let titleView = UIView()
        
        // Creates a new text label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 76, height: 32))
        label.text = titleText
        label.font = UIFont(name: "Lato-Regular", size: 10)
        label.numberOfLines = 0
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        
        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        
//        // Sets the image frame so that it's immediately before the text:
//        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
//        let imageY = label.frame.origin.y
        
        // Sets the image frame so that it's immediately after the text:
        let imageX = label.frame.origin.x  + label.frame.size.width  * imageAspect
        let imageY = label.frame.origin.y 
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: 24, height: 24)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        
        
        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()
        
        return titleView
        
    }
    
   func  generateLine() -> UIView{
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }
    
    func wrapInNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
   
}
