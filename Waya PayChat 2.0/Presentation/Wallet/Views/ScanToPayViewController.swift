//
//  ScanToPayViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/10/21.
//
import AVFoundation


protocol ScanToPayView : BaseView {
    var onClose: (() -> Void)? { get set}
    var onScanToPaySuccess: (() -> Void)? {get set}
}
class ScanToPayViewController: UIViewController, ScanToPayView, Alertable, AVCaptureMetadataOutputObjectsDelegate {
    var onClose: (() -> Void)?
    var onScanToPaySuccess: (() -> Void)?
//    var scanSuccess: ((String))
    let walletViewModel : WalletViewModelImpl
    var transactionDetailView: TransactionDetailView!
    var request: ScanToPayRequest?
    
    var successView: AlertView?
    var detailsShown: Bool = false
    lazy var selectFromPhotos: UIButton = {
        let btn = UI.button(title: "Select from Photos")
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor(hex: "#1C1C1C"), for: .normal)
        return btn
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scanPreview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        return view
    }()
    
    lazy var label: UILabel = {
        var txt = UI.text(string: "Point your camera to the QR code \nto scan the address", color: .white)
        txt.numberOfLines = 0
        txt.lineBreakMode = .byWordWrapping
        txt.textAlignment = .center
        return txt
    }()
    
    lazy var container: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#828282").withAlphaComponent(0.8)
        return view
    }()
    
    lazy var titleText: UILabel = {
        let txt = UI.text(string: "Scan QR Code to Pay", color: .white)
        txt.font = UIFont(name: "Lato-Regular", size: 18)
        return txt
    }()
    
    lazy var backButton: UIButton = {
        let btn = UI.button(title: nil, style: .secondary, state: .active)
        let origImage = UIImage(named: "back-arrow-white")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    //Camera Capture requiered properties
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let pickerController = UIImagePickerController()
    
    init(walletViewModel : WalletViewModelImpl){
        self.walletViewModel = walletViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init \(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        
//        title = "Scan to Pay"
//        navigationController?.navigationBar.tintColor = view.backgroundColor!
        initView()
        initCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func initView() {
        let previewBorder = CAShapeLayer()
        previewBorder.strokeColor = UIColor.white.cgColor
        previewBorder.lineWidth = 5
        previewBorder.lineDashPattern = [2, 2]
        previewBorder.frame = scanPreview.bounds
        previewBorder.fillColor = nil
        previewBorder.path = UIBezierPath(rect: scanPreview.bounds).cgPath
//        previewBorder.tr
        scanPreview.layer.addSublayer(previewBorder)
        view.addSubview(container)
        container.addSubviews([backButton, titleText, contentView])
        contentView.addSubviews([scanPreview, label, selectFromPhotos])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 21),
            backButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 45),
            backButton.heightAnchor.constraint(equalToConstant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 16),
            
            titleText.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleText.topAnchor.constraint(equalTo: container.topAnchor, constant: 41),
            
            contentView.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 33),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            scanPreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            scanPreview.heightAnchor.constraint(equalToConstant: 256),
            scanPreview.widthAnchor.constraint(equalToConstant: 256),
            scanPreview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            label.leadingAnchor.constraint(equalTo: scanPreview.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scanPreview.trailingAnchor),
            label.topAnchor.constraint(equalTo: scanPreview.bottomAnchor, constant: 25),
            
            selectFromPhotos.heightAnchor.constraint(equalToConstant: 44),
            selectFromPhotos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            selectFromPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            selectFromPhotos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -70)
        ])
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        backButton.addTarget(self, action: #selector(onCloseTap), for: .touchUpInside)
        selectFromPhotos.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
    }
    
    func initCapture() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanPreview.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanPreview.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            parseQR(code: stringValue)
        }
    }
    
    func parseQR(code: String) {
        print("code: \(code)")
//        let req = [""]
//        self.request = ScanToPayRequest(from: )
        let transactionDetail = TransactionDetail(beneficary: "Samuel Toju", amount: "200", accountNo: "0096364036", transactionFee: "N15", bank: "Rubies", labelTitle: "To", labelValue: "donhoenix@gmail.com", description: "Akara Purchase")
        self.showTransactionDetails(data: transactionDetail)
    }
    
    func showTransactionDetails(data: TransactionDetail) {
        transactionDetailView  = TransactionDetailView(frame: CGRect.zero, transactionDetail: data)
        transactionDetailView.backgroundColor = .white
        contentView.addSubview(transactionDetailView)
        transactionDetailView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        transactionDetailView.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        container.backgroundColor = .white
        titleText.textColor = Colors.black
        backButton.tintColor = Colors.black
        detailsShown = true
    }
    
    func hideTransactionDetails() {
        transactionDetailView.removeFromSuperview()
        transactionDetailView = nil
        container.backgroundColor = UIColor(hex: "#828282").withAlphaComponent(0.8)
        titleText.textColor = .white
        backButton.tintColor = .white
        detailsShown = false
    }
    
    @objc func didTapConfirmButton() {
        if transactionDetailView.otpStackView.getOTP().count > 0{
            validateOtp()
        } else{
            showAlert(title: "Pin Error!", message: "Invalid Pin")
        }
    }
    
    private func validateOtp() {
//        LoadingView.show()
////        let validatePinRequest = ValidatePinRequest(token: UserDefaults.standard.string(forKey: "Token") ?? "",
//        let pin = transactionDetailView.otpStackView.getOTP()
//        AuthViewModelImpl().validateUserPin(pin: pin) { [weak self]
//            (result) in
//            LoadingView.hide()
//            switch result{
//                case .success(let response):
//                    self?.payToUser()
//                case .failure(.custom(let message)):
//                    self?.showAlert(title: "Pin Validation Failed", message: message)
//            }
//        }
    }
    
    func payToUser() {
        successView = AlertView(frame:  UIScreen.main.bounds, title: "Successful", mode: .success(.generic))
//        successView?.mode =
        successView?.backgroundColor = .white
//        successView?.headerText.text =
        successView?.bodyLabel.text = "N400 has been sent to"
        successView?.bodyDetail.text = "Stanley Toju"
        successView?.bodyDetail.isHidden = false
        successView?.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView!)
        self.view.bringSubviewToFront(successView!)
        successView?.isUserInteractionEnabled = true
        successView?.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
    }
    
    func addFailureViewView() {
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView?.backgroundColor = .white
        successView?.bodyLabel.text = "N{amount} 400 has been sent to \n {firstName lastName}"
        successView?.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView!)
        self.view.bringSubviewToFront(successView!)
        successView?.isUserInteractionEnabled = true
        successView?.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
    }
    
    @objc func didTapFinish(){
        self.successView?.removeFromSuperview()
        self.successView = nil
        onScanToPaySuccess?()
    }
    
    @objc func didTapTryAgain() {
        self.successView?.removeFromSuperview()
        self.successView = nil
        transactionDetailView.otpStackView.clear()
    }
    
    @objc func onCloseTap() {
        if detailsShown == true {
            hideTransactionDetails()
        } else{
            self.onClose?()
        }
    }
    
    @objc func selectPhoto() {
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func failed() {
        self.showAlert(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert, completion: nil)
        captureSession = nil
    }
}

extension ScanToPayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let qrCodeImg = info[.originalImage] as? UIImage {
            let detector: CIDetector  = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage: CIImage = CIImage(image: qrCodeImg)!
            
            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                if let string = feature.messageString {
                    self.parseQR(code: string)
                } else {
                    self.showAlert(message: "unable to read QR code, please scan a clear image")
                }
            }
            picker.dismiss(animated: true, completion: nil)
        } else {
            self.showAlert(message: "unable to get image")
        }
    }
}
