//
//  CellCutomCategory.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 21/01/2019.
//  Copyright © 2019 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class CellCustomCategory: UICollectionViewCell {
    @IBOutlet var ivImage: UIImageView!
    @IBOutlet weak var vOverlay: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var categoryModel: CategoryModel! = nil {
        didSet {
            ivImage.setImageWithURLString(categoryModel.imageURL)
            lblTitle.text = categoryModel.title ?? ""
        }
    }


}
