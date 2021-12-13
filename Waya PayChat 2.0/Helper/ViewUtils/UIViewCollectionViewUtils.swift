//
//  UIViewCollectionView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/30/21.
//

extension UIViewController{
    
    func toolBarPrimaryLabel(title: String, size: CGFloat, autoResizing : Bool = false) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: size)
        label.textColor = UIColor(named: "color-gray1")
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = autoResizing
        return label
    }
    
    func toolBarSecondaryBoldLabel(title: String, size: CGFloat, autoResizing: Bool = false) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = autoResizing
        label.font = UIFont(name: "Lato-Bold", size: size)
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.text = title
        return label
    }
    
    func verticalStack( spacing : CGFloat , autoResizing: Bool = false, alignment : UIStackView.Alignment = .leading ) -> UIStackView{
        let stackView  = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = alignment
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func getDateandTimeFromISODate(isoDate : String) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from:isoDate) else { return nil }
        return dateFormatter.string(from: date)
    }
    
    
}
