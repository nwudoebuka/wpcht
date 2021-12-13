//
//  CreateMomentViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/14/21.
//

protocol CreateMomentView : BaseView {
    
}

class CreateMomentViewController: UIViewController , CreateMomentView, UITextViewDelegate, Alertable{

    var profilePictureImage = UIImage()
    var momentImage = UIImage()
    var imagePicker: ImagePicker!
    var wayagramViewModel = WayagramViewModelImpl()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow-white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var bodyText : UITextView = {
        let text = UITextView()
       // text.frame.size.width = UIScreen.main.bounds.width - 42
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center 
        text.backgroundColor = .clear
        text.text = "Type Your Moment"
        text.textColor = UIColor.lightGray
        text.font = UIFont(name: "Lato-Regular", size: 24)
        return text
    }()
    
    let textButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Text", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let galleryButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Gallery", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let buttonStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    

    private func setUpViews(){

        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "dark-cerulean")?.cgColor ?? UIColor.systemPink.withAlphaComponent(0.5).cgColor, UIColor(named: "dark-cerulean2")?.cgColor ?? UIColor.systemPink.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(textButton)
        buttonStackView.addArrangedSubview(galleryButton)
        buttonStackView.spacing = 18
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bodyText)
        bodyText.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16).isActive = true
        bodyText.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16).isActive = true
        bodyText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21).isActive = true
        bodyText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21).isActive = true
        bodyText.returnKeyType = .done
        bodyText.delegate = self
        addToolBarToKeyBoard()
        
        galleryButton.addTarget(self, action: #selector(didTapGalleryButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        bodyText.centerVertically()

    }
    
    @objc func navigateBack(){
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Type Your Moment"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Your Moment"{
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func addToolBarToKeyBoard(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Send", style: .plain, target: self, action: #selector(sendTextMoment))
        doneBtn.tintColor = UIColor.white
        let flexibleSpace =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let profileImageBarItem  = UIBarButtonItem.init(image: UIImage(named: "profile-placeholder"), style: .plain, target: self, action: nil)
        profileImageBarItem.tintColor = UIColor.white.withAlphaComponent(0.2)

        toolbar.setItems([profileImageBarItem, flexibleSpace, doneBtn], animated: true)
        toolbar.barTintColor = UIColor(named: "dark-cerulean")
        bodyText.inputAccessoryView = toolbar             
    }
    
    @objc func sendTextMoment(){
        uploadTextMoment()
    }
    
    @objc private func didTapGalleryButton(_ sender: UITapGestureRecognizer) {
        self.imagePicker.present(from: galleryButton)
    }
    
    func uploadTextMoment(){
        LoadingView.show()
        var images = [UIImage]()
        let image = statusTextToImage()
        images.append(image)
        uploadMoment(image: images)
    }
    
    
    func statusTextToImage() -> UIImage {
        bodyText.resignFirstResponder()
        
        let label = UI.text(string: bodyText.text, style: .bold, color: .white)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let background = UIView.init(frame: UIScreen.main.bounds)
        background.backgroundColor = Colors.orange
        background.addSubview(label)
        label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 40).isActive = true
        label.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -40).isActive = true
        label.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        self.view.endEditing(true)
        
        return background.asImage()
    }
}

extension CreateMomentViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil{
            uploadMoment(image: [image!])
        }
    }
        
    func uploadMoment(image: [UIImage]) {
        LoadingView.show()
        wayagramViewModel.createImageMoments(data: image) { (result) in
            LoadingView.hide()
            switch result{
                case .success(let result):
                    print(result)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }

                case .failure(.custom(let message)) :
                    print(message)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Uploading Error!!", message: "Failed uploading moment, please try again")
                    }
            }
        }
    }
}
