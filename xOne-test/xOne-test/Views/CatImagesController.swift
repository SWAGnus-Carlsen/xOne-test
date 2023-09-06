//
//  ViewController.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 4.09.23.
//

import UIKit
import SnapKit
import SDWebImage

final class CatImagesController: UIViewController {
    
    
    
    private var catsCollectionView: UICollectionView?
    private var catBreeds = [CatBreed]()
    private var imageURL: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCatsCollectionView()
        
        //catimage.sd_setImage(with: URL(string: "https://cdn2.thecatapi.com/images/8D--jCd21.jpg" ))
        
        APIManager.shared.getCatBreeds(from: APIConstants.breedsUrl) {[weak self] fetchedData in
            DispatchQueue.main.async {
                self?.catBreeds = fetchedData
                self?.catsCollectionView?.reloadData()
                
                
            }
            
            
        }
        
        
        
        
    }
    
    private func setupCatsCollectionView() {
        
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/2 - 6,
                                 height: 300)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 4
        
        catsCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        
        guard let catsCollectionView else { return }
        catsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        catsCollectionView.backgroundColor = .white
        
        catsCollectionView.register(CatsCVCell.self,
                                    forCellWithReuseIdentifier: CatsCVCell.identifier)
        catsCollectionView.showsHorizontalScrollIndicator = false
        catsCollectionView.showsVerticalScrollIndicator = false
        
        
        view.addSubview(catsCollectionView)
        
        catsCollectionView.dataSource = self
        catsCollectionView.delegate = self
       
        catsCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().inset(4)
        }
       
    }

}

extension CatImagesController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catBreeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatsCVCell.identifier, for: indexPath) as? CatsCVCell else {
            return UICollectionViewCell()
        }
        
        let currentCatBreed = catBreeds[indexPath.row]

        cell.config(withText: currentCatBreed.name, withImgURL: currentCatBreed.reference_image_id)
        
        return cell
    }
}

extension CatImagesController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
    }
}
