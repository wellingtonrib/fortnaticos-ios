//
//  StoreViewController.swift
//  fortnaticos-ios
//
//  Created by Well on 02/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit

struct StoreItem {
    var title: String!
    var price: Int!
    var imageURL: String!
}

class StoreViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let storeViewModel: StoreViewModel = StoreViewModel()
    
    var items = [StoreItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = "Loja"
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let margin = CGFloat(10)
            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        }

        self.registerObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.storeViewModel.getStore()
    }
    
    func registerObservers() {
        self.storeViewModel.store.observe { (store) in
            switch(store.status){
            case .LOADING:
                break
            case .SUCCESS:
                self.bindStore(store: store.data)
            case .ERROR:
                _ = self.alert(title: "Não foi possível recuperar a loja", message: "")
            }
        }
    }
    
    func bindStore(store: StoreDTO?) {
        self.items.removeAll()
        if let featured = store?.data.featured {
            featured.entries.forEach { (storeEntry) in
                storeEntry.items.forEach { (storeEntryItem) in
                    self.items.append(StoreItem(title: storeEntryItem.name, price: storeEntry.finalPrice, imageURL: storeEntryItem.images.featured ?? storeEntryItem.images.icon ??
                        storeEntryItem.images.smallIcon))
                }
            }
        }
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreItemCollectionViewCell", for: indexPath) as! StoreItemCollectionViewCell
    
        // Configure the cell
        let storeItem = self.items[indexPath.row]
        _ = cell.featureImage.load(url: storeItem.imageURL)
        cell.titleLabel.text = storeItem.title
        cell.priceLabel.text = String(storeItem.price)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
}

class StoreItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}
