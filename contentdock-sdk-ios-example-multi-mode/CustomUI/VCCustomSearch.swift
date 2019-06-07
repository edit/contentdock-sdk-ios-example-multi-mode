//
//  VCCustomSearch.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 18/01/2019.
//  Copyright © 2019 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomSearch: UIViewController {
    @IBOutlet weak var tfSearchString: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    var arrDatasource: [CategoryModel] = []
    var arrSelectedCategoriesIDs:Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CDockSDK.getCategories {[weak self] arr in
            if let arrCategories = arr as? [CategoryModel] {
                guard let s = self else { return }
                s.arrDatasource = arrCategories
                s.collectionView.reloadData()
            }
        }
    }


    @IBAction func onBtnSearchTapped(_ sender: Any) {
        self.tfSearchString.resignFirstResponder()

        let vc = UIStoryboard(name: "CustomUI", bundle: nil).instantiateViewController(withIdentifier: "VCCustomProjectsList") as! VCCustomProjectsList
        vc.listType = .searchProjects
        vc.searchString = tfSearchString.text ?? ""
        vc.arrCategoriesIds = Array(arrSelectedCategoriesIDs)

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCCustomSearch: UICollectionViewDataSource, UICollectionViewDelegate {
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
    }
}
