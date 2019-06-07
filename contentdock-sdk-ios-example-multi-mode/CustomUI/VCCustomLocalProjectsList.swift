//
//  VCCustomProjectsList.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 29/12/2018.
//  Copyright © 2018 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomLocalProjectsList: UIViewController {

    var arrDatasource: [ProjectModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        self.arrDatasource = CDockSDK.arrLocalProjects()
        self.tableView.reloadData()
    }
}

extension VCCustomLocalProjectsList: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatasource.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let projectModel = self.arrDatasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCustomLocalProjectsItem", for: indexPath) as! CellCustomLocalProjectsItem
        cell.lblTitle.text = projectModel.title
        cell.lblDescription.text = projectModel.projectDescription
        cell.ivImage.setImageWithURLString(projectModel.mainImage ?? "")
        cell.blockOnDeleteTapped = {
            CDockSDK.deleteLocalProject(projectModel)
            self.refresh()
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "CustomUI", bundle: nil).instantiateViewController(withIdentifier: "VCCustomProjectDetails") as! VCCustomProjectDetails
        vc.projectModel = self.arrDatasource[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)

    }
}
