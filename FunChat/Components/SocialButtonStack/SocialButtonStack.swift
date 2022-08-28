//
//  SocialButtonStack.swift
//  FunChat
//
//  Created by Can Yoldaş on 27.08.2022.
//

import UIKit
import CYBase

enum SocialType: String {
    case google
    case facebook
    case twitter
    case apple
}

protocol SocialButtonStackProtocol: AnyObject {
    
    func buttonClicked(socialType: SocialType)
}

class SocialButtonStackData {
    
    private(set) var socials: [SocialType]
    
    init(socials: [SocialType]) {
        self.socials = socials
    }
}

class SocialButtonStack: CYBaseView<SocialButtonStackData> {
    
    weak var delegate: SocialButtonStackProtocol?
    
    private(set) lazy var stackView: UIStackView = {
        let temp = UIStackView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .fill
        temp.distribution = .equalSpacing
        return temp
    }()
    
    override func addViewComponents() {
        super.addViewComponents()
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func loadDataToView() {
        super.loadDataToView()
        
        guard let data = returnData() else {return}
        
        data.socials.forEach { social in
            let button = UIButton()
            button.setImage(UIImage(named: social.rawValue), for: .normal)
            
            button.addAction { [weak self] in
                self?.delegate?.buttonClicked(socialType: social)
            }
            stackView.setCustomSpacing(10, after: button)
            stackView.addArrangedSubview(button)
        }
    }
    
    
    // TODO: refactor this constraint setting function. I don't think it would be necessary to have it like this
    
    /// This methods helps you to set width of the socialStack.
    /// It calculates the needed margin and centerize the view.
    func setupConstraints(superView: UIView) {
        guard let data = returnData() else {return}
        
        let margin = (Int(superView.width) - (data.socials.count*51 - 7)) / 2
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: CGFloat(margin)),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -CGFloat(margin))
        ])
    }
}
