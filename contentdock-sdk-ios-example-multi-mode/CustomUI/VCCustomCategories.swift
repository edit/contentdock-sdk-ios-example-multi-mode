//
//  VCCustomSearch.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 18/01/2019.
//  Copyright © 2019 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomCategories: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var arrDatasource: [CategoryModel] = []
    var arrSelectedCategoriesIDs:Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshSelectedCategories()


        CDockSDK.getCategories {[weak self] arr in
            if let arrCategories = arr as? [CategoryModel] {
                guard let s = self else { return }
                s.arrDatasource = arrCategories
                s.collectionView.reloadData()
            }
        }
    }

    private func refreshSelectedCategories() {
        if let arrNumbers = CDockSDK.arrSelectedCategories() as? [NSNumber] {
            let arrInts = arrNumbers.map { number -> Int in
                return number.intValue
            }
            arrSelectedCategoriesIDs = Set(arrInts)
        }
    }

    private func saveSelectedCategoriest() {
        let arr = arrSelectedCategoriesIDs.map { i -> NSNumber in
            return NSNumber(value: i)
        }
        CDockSDK.setArrSelectedCategories(arr)
    }
}

extension VCCustomCategories: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCustomCategory", for: indexPath) as! CellCustomCategory
        let model = self.arrDatasource[indexPath.row]
        cell.categoryModel = model
        cell.vOverlay.isHidden = !arrSelectedCategoriesIDs.contains(Int(model.categoryId))
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.arrDatasource[indexPath.row]
        if arrSelectedCategoriesIDs.contains(Int(model.categoryId)) {
            arrSelectedCategoriesIDs.remove(Int(model.categoryId))
        }
        else {
            arrSelectedCategoriesIDs.insert(Int(model.categoryId))
        }
        collectionView.reloadData()


        saveSelectedCategoriest()

    }


}
