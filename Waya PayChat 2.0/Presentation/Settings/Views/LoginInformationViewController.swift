//
//  LoginInformationViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/29/21.
//


class LoginInformationViewController: UIViewController {
    
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.backButton.setImage(UIImage(named: "back-arrow-orange"), for: .normal)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.titleLabel.text = "Login Information"
        return toolbar
    }()
    var authViewModel = AuthViewModelImpl()
    
    var locationView = CardWithTwoHorizontalText()
    var deviceView = CardWithTwoHorizontalText()
    var timeView = CardWithTwoHorizontalText()
    
    var timeLog : UILabel!
    var viewAll : UILabel!
    let historyTableContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "whisper-gray")
        setUpView()
        fetchLoginHistory()
    }
    
    private func setUpView(){
        
        timeView.cornerWithWhiteBg(4)
        deviceView.cornerWithWhiteBg(4)
        historyTableContainer.cornerWithWhiteBg(4)
        
        view.addSubview(toolbar)
        toolbar.backgroundColor = .white
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        view.addSubview(locationView)
        locationView.anchor(top: toolbar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 17, left: 22, bottom: 0, right: 22))
        
        locationView.cornerWithWhiteBg(4)
        
        view.addSubview(deviceView)
        deviceView.anchor(top: locationView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding:  UIEdgeInsets(top: 8, left: 22, bottom: 0, right: 22))
        
        view.addSubview(timeView)
        timeView.anchor(top: deviceView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding:  UIEdgeInsets(top: 8, left: 22, bottom: 0, right: 22))
        
        view.addSubview(historyTableContainer)
        historyTableContainer.anchor(top: timeView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding:  UIEdgeInsets(top: 8, left: 22, bottom: 20, right: 22))
        
        locationView.headerLabel.text =  "Location"
        deviceView.headerLabel.text = "Device"
        timeView.headerLabel.text = "Time"
        
        viewAll = toolBarPrimaryLabel(title: "View all", size: 14, autoResizing: false)
        timeLog = toolBarSecondaryBoldLabel(title: "TIme Log", size: 14, autoResizing: false)
         
        historyTableContainer.addSubview(timeLog)
        historyTableContainer.addSubview(viewAll)
        
        timeLog.anchor(top: historyTableContainer.topAnchor, leading: historyTableContainer.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 13, bottom: 0, right: 0))
        viewAll.anchor(top: historyTableContainer.topAnchor, leading: nil, bottom: nil, trailing: historyTableContainer.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 16))
        toolbar.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchLoginHistory(){
//        if let user = auth.data.profile {
//            let userId = String(user.id)
//            
//            
//        }
        
    }

}
