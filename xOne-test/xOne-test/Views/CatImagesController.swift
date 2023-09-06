//
//  ViewController.swift
//  xOne-test
//
//  Created by Vitaliy Halai on 4.09.23.
//

import UIKit
import SnapKit
import SDWebImage
import SafariServices

final class CatImagesController: UIViewController {
    
    
    //MARK: - UI Elements -
    private var catsCollectionView: UICollectionView?
    
    //MARK: - Properties -
    private var catBreeds = [CatBreed]()
    private var imageURL: String?
   
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCatsCollectionView()
        fetchBreeds(willPaginating: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        catsCollectionView?.reloadData()
    }
    
    //MARK: - Private funcs -
    private func fetchBreeds(willPaginating : Bool) {
        APIManager.shared.getCatBreeds(pagination: willPaginating,from: APIConstants.breedsUrl) {[weak self] fetchedData in
            
            DispatchQueue.main.async {
                self?.catBreeds.append(contentsOf: fetchedData) 
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
        
        catsCollectionView.backgroundColor = UIColor(named: "BackGround")
        
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

//    private func createSpinnerFooterView() -> UIView {
//        let footerView = UIView (frame: CGRect(x: 0, y: 0,
//                                               width: view.frame.size.width,
//                                               height: 150))
//
//        let spinner = UIActivityIndicatorView()
//
//        spinner.center = footerView.center
//        footerView.addSubview(spinner)
//        spinner.startAnimating()
//
//        return footerView
//    }
}

//MARK: - Extensions -
extension CatImagesController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catBreeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatsCVCell.identifier, for: indexPath) as? CatsCVCell else {
            return UICollectionViewCell()
        }
        
        let currentCatBreed = catBreeds[indexPath.row]

        cell.config(
            with: CatsCVCellViewModel(breedName: currentCatBreed.name,
                                      imageURLStr: currentCatBreed.reference_image_id))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: catBreeds[indexPath.row].wikipedia_url) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
    }
}

extension CatImagesController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (catsCollectionView?.contentSize.height ?? 0) - scrollView.frame.height - 120 {
            guard !APIManager.isPaginating else {
                return
            }
            fetchBreeds(willPaginating: true)
        }
        
    }
}
