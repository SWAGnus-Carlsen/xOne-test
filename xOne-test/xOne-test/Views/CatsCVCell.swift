//
//  CatsCVCell.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 4.09.23.
//

import UIKit

class CatsCVCell: UICollectionViewCell {
    //MARK: - Properties declaration -
    static let identifier = "CatsCVCell"
    
    //MARK: - UI Elements declaration -
    private let catNameLabel: UILabel = {
        var label = UILabel ()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let catImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Override methods -
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(catNameLabel)
        contentView.addSubview(catImageView)
        catImageView.addSubview(activityIndicator)
        contentView.backgroundColor = UIColor(named: "BackGround")
        contentView.layer.borderColor = UIColor(named: "ForeGround")?.cgColor
        contentView.layer.borderWidth = 1
        catNameLabel.textColor = UIColor(named: "ForeGround")
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        contentView.layer.cornerRadius = contentView.frame.height / 8
        catImageView.layer.cornerRadius = contentView.layer.cornerRadius
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        catImageView.frame = CGRect (x: 8,
                                     y: 0,
                                     width: contentView.frame.size.width - 16,
                                     height: contentView.frame.size.height * 1/2)
        catNameLabel.frame = CGRect (x: 0,
                                     y: catImageView.frame.maxY,
                                     width: contentView.frame.size.width,
                                     height: contentView.frame.size.height * 1/2)
        activityIndicator.center = catImageView.center
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        catImageView.image = nil
        catNameLabel.text = nil
        contentView.layer.borderColor = UIColor(named: "ForeGround")?.cgColor
        activityIndicator.stopAnimating()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - funcs declaration -
    func config(with viewModel: CatsCVCellViewModel) {
        APIManager.shared.getCatImage(from: APIConstants.imageURL(viewModel.imageURLStr) ) { [weak self]  fetchedImageStruct in
            
            DispatchQueue.main.async {
                self?.catNameLabel.text = viewModel.breedName
                self?.catImageView.sd_setImage(
                    with: URL(string: fetchedImageStruct.url),
                    placeholderImage: UIImage(systemName: "camera"),
                    options: .avoidAutoCancelImage,
                    completed: { _,_,_,_ in
                    self?.activityIndicator.stopAnimating()
                })
                
                
            }
        }
    }
    
   
}
