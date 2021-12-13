//
//  CreatePostViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/14/21.
//
import SwiftValidator

protocol CreatePostView : BaseView {
    
}

class CreatePostViewController: UIViewController, CreatePostView, UITextViewDelegate, Alertable {

    var bottomLine = UIView()
    var topLine = UIView()
    
    var postImages : [UIImage] = []
    var postImageView : PostImageView!
    var postAmount = 0
    var postHeightConstraint : NSLayoutConstraint!
    var postId  = ""
    
    var wayagramViewModel = WayagramViewModelImpl()
    
    //For Updating real time  post 
    var isUpdatePost = false
    var editPost : Post!
    var dataController:DataController!

    var pricePostView : PricePostView!

    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Posts"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.font = UIFont(name: "LibreBaskerville-Bold", size: 16)
        return label
    }()
    
    var bodyText : UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .left 
        text.text = "Create New Post"
        text.textColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.7)
        text.font = UIFont(name: "Lato-Regular", size: 16)
        return text
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        button.setTitle("Send", for: .normal)
        button.setTitleColor( UIColor(named: "toolbar-color-primary"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var pictureButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "image-picker"), for: .normal)
        return button
    }()
    
    let gifButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "gif-icon"), for: .normal)
        return button
    }()
    
    
    let pollButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "poll-icon"), for: .normal)
        return button
    }()
    
    let productTagButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "product-tag"), for: .normal)
        return button
    }()
    
    
    let cameraButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "camera-icon"), for: .normal)
        return button
    }()
    
    var profileImageView : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "profile-placeholder")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.circularImage()
        return imageV
    }()
    
    var buttonContainer = UIView()
    var topViewContainer = UIView()
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        editPostSetUp()
    }
    
    private func setUpView(){
        topViewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topViewContainer)
        topViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topViewContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        topViewContainer.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: topViewContainer.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topViewContainer.centerXAnchor).isActive = true
        
        topViewContainer.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: topViewContainer.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: topViewContainer.leadingAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        topViewContainer.addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: topViewContainer.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: topViewContainer.trailingAnchor, constant: -16).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.backgroundColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.5)
        view.addSubview(topLine)
        topLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: topViewContainer.bottomAnchor, constant: 2).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
        buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonContainer.addSubview(pictureButton)
        pictureButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        pictureButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 22).isActive = true
        
        buttonContainer.addSubview(gifButton)
        gifButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        gifButton.leadingAnchor.constraint(equalTo: pictureButton.trailingAnchor, constant: 26).isActive = true
        
        buttonContainer.addSubview(pollButton)
        pollButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        pollButton.leadingAnchor.constraint(equalTo: gifButton.trailingAnchor, constant: 22).isActive = true
        
        buttonContainer.addSubview(productTagButton)
        productTagButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        productTagButton.leadingAnchor.constraint(equalTo: pollButton.trailingAnchor, constant: 22).isActive = true
        
        buttonContainer.addSubview(cameraButton)
        cameraButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        cameraButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -22).isActive = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.5)
        view.addSubview(bottomLine)
        bottomLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -2).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 18).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        print("The image width \(profileImageView.frame.size.width)")
        profileImageView.circularImage()

        view.addSubview(bodyText)
        bodyText.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        bodyText.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6).isActive = true
        bodyText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21).isActive = true
        postHeightConstraint = bodyText.heightAnchor.constraint(equalToConstant: bodyText.contentSize.height)
        postHeightConstraint.isActive = true
        print("The content height \(bodyText.contentSize.height)")
       // bodyText.heightAnchor.constraint(equalToConstant: 200).isActive = true
        bodyText.returnKeyType = .done
        bodyText.delegate = self
        
        backButton.addTarget(self, action: #selector(addBackButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(takeCameraImage), for: .touchUpInside)
        pictureButton.addTarget(self, action: #selector(selectFromGallery), for: .touchUpInside)
        productTagButton.addTarget(self, action: #selector(addPollView), for: .touchUpInside)
        validator.registerField(bodyText, rules: [RequiredRule()])
        
    }
    
    @objc func addPollView(){
        pricePostView = PricePostView()
        pricePostView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pricePostView)
        view.bringSubviewToFront(pricePostView)
        pricePostView.topAnchor.constraint(equalTo: bodyText.bottomAnchor, constant: 30).isActive = true
        pricePostView.leadingAnchor.constraint(equalTo: bodyText.leadingAnchor).isActive = true
        pricePostView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        pricePostView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        pricePostView.backgroundColor = .white
        pricePostView.clipsToBounds = true
        pricePostView.layer.cornerRadius = 14
        pricePostView.layer.borderWidth = 1
        wayagramViewModel.createPostRequestWithImages.isPaid = true
        pricePostView.layer.borderColor = UIColor(named: "sliver-gray")?.withAlphaComponent(0.3).cgColor
        pricePostView.removeButton.addTarget(self, action: #selector(removePollView), for: .touchUpInside)
        pricePostView.addImageButton.addTarget(self, action: #selector(selectFromGallery), for: .touchUpInside)
        pricePostView.priceTextField.keyboardType = .numberPad
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissPriceKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        
        pricePostView.priceTextField.inputAccessoryView = toolbar
        
        pricePostView.priceTextField.addTarget(self, action: #selector(priceTextViewEditing(_:)), for: .editingChanged)
        
    }
    
    @objc func priceTextViewEditing(_ sender: UITextField){
       // pricePostView.priceTextField 
        if sender.text?.count == 1{
            sender.text = "N\(sender.text!)"
        }
    }
    
    @objc func dismissPriceKeyboard(){
        view.endEditing(true)
    }
    
    @objc func removePollView(){
        pricePostView.removeFromSuperview()
        wayagramViewModel.createPostRequestWithImages.isPaid = false
        pricePostView = nil
    }
    
    private func editPostSetUp(){
        if isUpdatePost{
            bodyText.text = editPost.postDescription
            if editPost.hasImage{
                if let image = UIImage(data: editPost.postImage!){
                    postImages.append(image)
                    postImageView = PostImageView(newImages: postImages)
                    addPostImageView()
                }
            }
        }
    }
    
    func addPostImageView(){
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.tag = 100
        view.addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: bodyText.bottomAnchor, constant: 15).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 18).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func sendPost(){
        validator.validate(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Create New Post"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 280    // 10 Limit Value
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Create New Post"{
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        postHeightConstraint.isActive = false
        postHeightConstraint = bodyText.heightAnchor.constraint(equalToConstant: bodyText.contentSize.height)
        postHeightConstraint.isActive = true
    }
    
    @objc func addBackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectFromGallery(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func takeCameraImage(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func removeSubview(){
        print("Start remove sibview")
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
            print("done removing subview")

        }else{
            print("No!")
        }
    }
    
    func createPostWithImages(){
        
        LoadingView.show()
        
        wayagramViewModel.createPostRequestWithImages.amount = 0
        print("Create post with images amount \(wayagramViewModel.createPostRequestWithImages.amount)")
        wayagramViewModel.createPostRequestWithImages.images = postImages
//        wayagramViewModel.createPostRequestWithImages.profile_id = auth.data.profile!.profile!.id
        print("The profile id \(wayagramViewModel.createPostRequest.profile_id)")
        wayagramViewModel.createPostRequestWithImages.description = bodyText.text
        wayagramViewModel.createPostRequestWithImages .type = "user"
        
        
        if wayagramViewModel.createPostRequestWithImages.isPaid {
            
            if let price = pricePostView.priceTextField.text, price.length > 1 {
                let amount = String(price.dropFirst())
                if let intAmount = Int(amount){
                    wayagramViewModel.createPostRequestWithImages.amount = intAmount
                    print("The amount 2 \(amount)")
                    performUploadPost()
                }else{
                    LoadingView.hide()
                    showAlert(message: "Invalid amount")
                }
            }else{
                print("The amount 4 \(pricePostView.priceTextField.text)")
                LoadingView.hide()
                showAlert(message: "Invalid amount")
            }
        } else{
            performUploadPost()
        }
    }
    
    func performUploadPost(){
        wayagramViewModel.createPostWithImages(createPostRequest: wayagramViewModel.createPostRequestWithImages) {[weak self] (result) in
            
            switch result{
                case .success(let response):
                    if let response_ = response as? CreatePostResponse{
                        self?.wayagramViewModel.getPostById(postId: response_.id) {[weak self] (result) in
                            switch result{
                                case .success(let response):
                                    if var response_  = response as? PostResponse{
                                        if response_.profile.user.profileImage != nil && response_.profile.user.profileImage != "" {
                                            ImageLoader.loadImageData(urlString: response_.profile.user.profileImage! ){
                                                (result) in
                                                response_.uiImage = result 
                                                if let count = response_.images?.count, count > 0{
                                                    ImageLoader.loadImageData(urlString: response_.images![0].imageURL) { (result) in
                                                        let image = result ?? UIImage(named: "advert-wallet")
                                                        if let image_ = image{
                                                            response_.postImages?.append(image_) 
                                                            self?.addPost(postResponse: response_)
                                                            LoadingView.hide()
                                                            self?.dismiss(animated: true, completion: nil)
                                                        }
                                                    }
                                                }
                                                else{
                                                    self?.addPost(postResponse: response_)
                                                    LoadingView.hide()
                                                    self?.dismiss(animated: true, completion: nil)
                                                }
                                            }
                                        } 
                                        else if let count = response_.images?.count, count > 0{
                                                ImageLoader.loadImageData(urlString: response_.images![0].imageURL) { (result) in
                                                    let image = result ?? UIImage(named: "advert-wallet")
                                                    if let image_ = image{
                                                        response_.postImages?.append(image_) 
                                                        self?.addPost(postResponse: response_)
                                                        LoadingView.hide()
                                                        self?.dismiss(animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        else{
                                            LoadingView.hide()
                                            self?.dismiss(animated: true, completion: nil)
                                        }
                                     
                                    } else{
                                        LoadingView.hide()
                                        self?.dismiss(animated: true, completion: nil)
                                    }
                                case .failure(.custom(let message)):
                                    print("Message of getting single Post \(message)")
                                    LoadingView.hide()
                                    self?.dismiss(animated: true, completion: nil)
                            }
                        }
                        // addPost(postResponse: response_.id)
                    }else{
                        LoadingView.hide()
                        self?.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(.custom(let message)):
                    print(message)
                    LoadingView.hide()
                    self?.showAlert(title: "Sending Post!", message: "Sending Post Falied")
                    
            }
        }
 
    }
    
   private func addPost(postResponse: PostResponse) {
//        let post = Post(context: dataController.viewContext)
//        post.id = postResponse.id
//        post.createdAt = postResponse.createdAt
////        post.fullName = "\(postResponse.profile.user.firstName) \(postResponse.profile.user.surname)"
//        post.username = postResponse.profile.username
//        post.groupId = postResponse.groupID
//        post.commentCount = Int16(postResponse.commentCount)
//        post.likesCount = Int16(postResponse.likesCount)
//        post.postDescription = postResponse.description
//        post.isPostDeleted = postResponse.isDeleted
//        post.hasLiked = postResponse.isLiked
//        post.type = postResponse.type
//        post.profileId = postResponse.profile.id
//        if let count = postResponse.images?.count , count > 0{
//            post.hasImage = true
//            if let imgCount =  postResponse.postImages?.count , imgCount > 0{
//                post.postImage = postResponse.postImages?[0].jpegData(compressionQuality: 0.5)
//            }
//        } else{
//            post.hasImage = false
//        }
//        if let img = postResponse.uiImage?.jpegData(compressionQuality: 0.5){
//            post.creatorImage = img
//        }
//        
//        try? dataController.viewContext.save()
    }
    
    func updatePostWithImages(){
        LoadingView.show()
        let updatePost = UpdatePostRequest(images: postImages, profile_id: editPost.profileId!, description: bodyText.text, post_id: editPost.id!, group_id: "", page_id: "", type: editPost.type!, deletedHashtags: [], addedHashtags: [], deletedMentions: [], addedMentions: [], deletedFiles: [], isPoll: editPost.isPoll, isPaid: false, amount: 0, expiresIn: "", voteLimit: 0, forceTerms: false, terms: "", options: [])
        wayagramViewModel.updatePost(createPostRequest: updatePost) {[weak self] (result) in
            
            switch result{
                case .success(let response):
                    print("The update post response \(String(describing: response))")
                    do{
                        self?.editPost.postDescription = self?.bodyText.text
                        try  self?.editPost.managedObjectContext?.save()   
                        
                        //We should use this so that changes are save on termination on the app
                        //try self?.dataController.viewContext.save()
                        self?.isUpdatePost = false
                    } catch{
                        print(error)
                    }
                    LoadingView.hide()
                    self?.dismiss(animated: true, completion: nil)
                    
                case .failure(.custom(let message)):
                    print(message)
                    LoadingView.hide()
                    self?.showAlert(title: "Sending Post!", message: "Sending Post Falied")
                    
            }
        }
    }
}


extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        if postImageView != nil{
            postImageView.removeFromSuperview()
            postImageView = nil
        }
        
        // image target is 2 for non paid post 
        if postImages.count < 3{
            print(image.size)
            if wayagramViewModel.createPostRequestWithImages.isPaid == true{
                postImages.removeAll()
                postImages.append(image) //only one images is allow for paid post 
                pricePostView.postPollImageView = PostImageView(newImages: postImages)
                pricePostView.addPostPollImageView()
            } else{
                postImages.append(image)
                postImageView = PostImageView(newImages: postImages)
                addPostImageView()
            }
           
        }
    }
}

extension CreatePostViewController: ValidationDelegate {
    func validationSuccessful() {
        createPostWithImages()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (_, error) in errors {
            self.showAlert(message: error.errorMessage)
            break
        }
    }
}
