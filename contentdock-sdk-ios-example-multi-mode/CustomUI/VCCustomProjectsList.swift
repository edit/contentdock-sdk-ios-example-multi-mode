//
//  VCCustomProjectsList.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 29/12/2018.
//  Copyright © 2018 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomProjectsList: UIViewController {

    enum ListType {
        case publicProjects
        case privateProjects
        case searchProjects
    }
    
    @IBInspectable var isPublicProjectsAsDefault: Bool {
        set {
            listType = .publicProjects
        }
        get {
            return false
        }
    }

    var searchString: String = ""
    var arrCategoriesIds:[Int] = []

    var listType: ListType = .privateProjects
    var arrDatasource: [ProjectModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.listType == .privateProjects {
            self.tableView.isHidden = !CDockSDK.isLoggedIn()
        }
        refresh()
    }

    private func refresh() {
        switch self.listType {
        case .privateProjects:
            CDockSDK.getPrivateProjects(from: 0, to: 100) { [weak self] arr in
                if let arrProjects = arr as? [ProjectModel] {
                    self?.arrDatasource = arrProjects
                    self?.tableView.reloadData()
                }
            }
            break
        case .publicProjects:
            CDockSDK.getPublicProjects(from: 0, to: 100) { [weak self] arr in
                if let arrProjects = arr as? [ProjectModel] {
                    self?.arrDatasource = arrProjects
                    self?.tableView.reloadData()
                }
            }
            break
        case .searchProjects:
            CDockSDK.getSearchProjects(from: 0, to: 100, search: self.searchString, categoriesIds: self.arrCategoriesIds, blockOnComplete: { [weak self] arr in
                if let arrProjects = arr as? [ProjectModel] {
                    self?.arrDatasource = arrProjects
                    self?.tableView.reloadData()
                }
            })

            break
        }
    }
}

extension VCCustomProjectsList: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatasource.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let projectModel = self.arrDatasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCustomProjectsItem", for: indexPath) as! CellCustomProjectsItem
        cell.lblTitle.text = projectModel.title
        cell.lblDescription.text = projectModel.projectDescription
        cell.ivImage.setImageWithURLString(projectModel.mainImage ?? "")
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "CustomUI", bundle: nil).instantiateViewController(withIdentifier: "VCCustomProjectDetails") as! VCCustomProjectDetails
        vc.projectModel = self.arrDatasource[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)

    }
}
