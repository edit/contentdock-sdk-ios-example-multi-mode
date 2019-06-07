//
//  CellCustomProjectItem.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 29/12/2018.
//  Copyright © 2018 EDIT GmbH. All rights reserved.
//

import UIKit

class CellCustomLocalProjectsItem: UITableViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    var blockOnDeleteTapped: (()->())?
    
    @IBAction func onBtnDeleteTapped(_ sender: Any) {
        blockOnDeleteTapped?()
    }
}
