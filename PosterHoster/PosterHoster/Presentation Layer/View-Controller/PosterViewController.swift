//
//  PosterViewController.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 14/05/22.
//

import UIKit

class PosterViewConstants {
    static let posterAspectRatio: CGFloat = 3/2
    static let posterTitleDefaultHeight: CGFloat = 50
    static let posterDefaultHeight: CGFloat = 230
}

class PosterViewController: UICollectionViewController {
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var posterCollectionView: UICollectionView!
    
    var posterVM: PosterViewModelProtocol! = PosterViewModel()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
        
    }()
    
    var loadMore: Bool! = false
    var pageNo = 1
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPoster(page: pageNo)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        posterCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupView() {
        posterCollectionView.register(LoadingCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        posterCollectionView.register(UINib(nibName:Constants.posterCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.posterCellIdentifier)
        (posterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: posterCollectionView.bounds.width, height: 50)
        setLeftAlignTitleView(font: UIFont.systemFont(ofSize: 20), text: Constants.posterViewTitle, textColor: .white)
    }
    
    fileprivate func fetchPoster(page: Int) {
        activityIndicator.startAnimating()
        posterVM.fetchPosters(for: pageNo)
        
        posterVM.completionClosure = { [weak self] in
            guard let self = self else {
                return
            }
            self.pageNo += 1
            self.activityIndicator.stopAnimating()
            self.loadMore = false
            self.posterCollectionView.isHidden = false
            self.posterCollectionView.reloadData()
            
        }
        
        posterVM.failedClosure = { [weak self] error in
            guard let self = self else {
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.loadMore = false
            Utility.showAlert(message: error ?? NetworkError.fetchError.errorMessage, onController: self)
        }
    }
    
    func setLeftAlignTitleView(font: UIFont, text: String, textColor: UIColor) {
        guard let navFrame = navigationController?.navigationBar.frame else{
            return
        }
                
        let parentView = UIView(frame: CGRect(x: -30, y: 0, width: navFrame.width*3, height: navFrame.height))
        self.navigationItem.titleView = parentView
        
        let label = UILabel(frame: .init(x: parentView.frame.minX, y: parentView.frame.minY, width: parentView.frame.width, height: parentView.frame.height))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = font
        label.textAlignment = .left
        label.textColor = textColor
        label.text = text
        
        parentView.addSubview(label)
    }
    
}

extension PosterViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterVM.dataSource?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.posterCellIdentifier, for: indexPath)
        if let cell = collectionCell as? PosterCollectionViewCell {
            cell.updateCell(with: posterVM.dataSource![indexPath.row])
        }
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dataSource = posterVM.dataSource else { return }
        if indexPath.row == dataSource.count - 3 && !self.loadMore && posterVM.getTotalPhotosCount() > dataSource.count {
            self.loadMore = true;
            fetchPoster(page: pageNo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var widthPerItem  = CGSize.init(width: view.frame.width, height: PosterViewConstants.posterDefaultHeight)
        
        let paddingSpace = sectionInsets.left * (itemsPerRow * 2)
        let availbleWidth = view.frame.width - paddingSpace
        let width = (availbleWidth/itemsPerRow)
        widthPerItem = CGSize.init(width: width, height: (PosterViewConstants.posterAspectRatio * width + PosterViewConstants.posterTitleDefaultHeight))
        
        return widthPerItem
    }
}
