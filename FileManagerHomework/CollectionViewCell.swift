//
//  CollectionViewCell.swift
//  FileManagerHomework
//
//  Created by Мария Межова on 19.03.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.toAutoLayout()
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font.withSize(18)
        label.numberOfLines = 1
        label.toAutoLayout()
        return label
    }()
    
    private let containerView: UIView = {
    let container = UIView()
        container.toAutoLayout()
        return container
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        
        let constraints = [
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
    
    
