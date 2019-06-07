//
//  VCCustomProjectDetails.swift
//  TEVNoLogin
//
//  Created by Kirill Pyulzyu on 10/01/2019.
//  Copyright © 2019 EDIT GmbH. All rights reserved.
//

import UIKit
import CDockFramework

class VCCustomProjectDetails: UIViewController {
    var projectModel: ProjectModel!

    @IBOutlet weak var stackImages: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCategories: UILabel!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblEstimate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateControlsState()
        handleUpdates()

        for projectImage in projectModel.arrImages as! [ProjectImage] {
            let iv = UIImageView()
            iv.setImageWithURLString(projectImage.url ?? "")
            iv.translatesAutoresizingMaskIntoConstraints = false
            stackImages.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: stackImages.widthAnchor).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }


        self.lblTitle.text = projectModel.title ?? ""
        self.lblDescription.text = projectModel.projectDescription ?? ""
        self.lblCategories.text = projectModel.tags ?? ""


        refreshProject()
    }



    @IBAction func onBtnOpenTapped(_ sender: Any) {
        CDockSDK.openProject(self.projectModel)
    }

    @IBAction func onBtnDownloadTapped(_ sender: Any) {
        CDockSDK.downloadProject(self.projectModel)
        self.updateControlsState()
        self.updateProgress(progress: 0)
        self.updateEstimate(estimate: 0, speed: 0)
    }
    
    @IBAction func onBtnUpdateTapped(_ sender: Any) {
        CDockSDK.downloadProject(self.projectModel)
        self.updateControlsState()
        self.updateProgress(progress: 0)
        self.updateEstimate(estimate: 0, speed: 0)
    }

    @IBAction func onBtnRefreshTapped(_ sender: Any) {
        self.refreshProject()
    }
    
    func updateProgress(progress: Double) {
        self.lblProgress.text = String(format: "%d%%", Int(progress * 100))
    }
    
    func updateEstimate(estimate: Double, speed: Double) {
        if (estimate == 0) {
            self.lblEstimate.text = "";
            return;
        }
        
        let f = DateComponentsFormatter()
        f.allowedUnits = [.second, .minute, .hour]
        f.unitsStyle = .abbreviated
        f.zeroFormattingBehavior = [.dropLeading, .pad]
        self.lblEstimate.text = String(format:"%0.2f kB/s / %@", speed / 1024, f.string(from: estimate) ?? "")
    }

    func updateControlsState() {
        let projectState = CDockSDK.projectState(projectModel)
        switch projectState {
        case none:
            self.btnOpen.isEnabled = false
            self.btnDownload.isEnabled = true
            self.btnUpdate.isEnabled = false
            self.lblProgress.isHidden = true
            self.lblEstimate.isHidden = true
            break;
        case syncInProgress:
            self.btnOpen.isEnabled = false
            self.btnDownload.isEnabled = false
            self.btnUpdate.isEnabled = false
            self.lblProgress.isHidden = false
            self.lblEstimate.isHidden = false
            break;
        case syncFinished:
            self.btnOpen.isEnabled = true
            self.btnDownload.isEnabled = false
            self.btnUpdate.isEnabled = false
            self.lblProgress.isHidden = true
            self.lblEstimate.isHidden = true
            break;
        case syncInterrupted:
            self.btnOpen.isEnabled = false
            self.btnDownload.isEnabled = true
            self.btnUpdate.isEnabled = false
            self.lblProgress.isHidden = true
            self.lblEstimate.isHidden = true
            break;
        case needUpdate:
            self.btnOpen.isEnabled = true
            self.btnDownload.isEnabled = false
            self.btnUpdate.isEnabled = true
            self.lblProgress.isHidden = true
            self.lblEstimate.isHidden = true
            break;

        default:
            break;

        }
    }



    func handleUpdates() {
        CDockSDK.setBlockCallbacks { [weak self] (type: CDockSDKCallbackType, userInfo: [AnyHashable: Any]!) in
            guard let s = self else {
                return
            }

            guard let projectId = userInfo["projectId"] as? Int, projectId == s.projectModel.projectId else {
                return
            }

            switch (type) {
            case syncProgress:
                if let progress = userInfo["progress"] as? Double {
                    if projectId == self?.projectModel.projectId ?? -1 {
                        self?.updateProgress(progress: progress)
                    }
                }
                break;

            case syncSuccess:
                s.updateControlsState()
                break;

            case syncFailed:
                s.updateControlsState()
                break;

            case syncEstimate:
                if let estimate = userInfo["estimate"] as? Double, let speed = userInfo["speed"] as? Double {
                    s.updateEstimate(estimate: estimate, speed: speed)
                }

                break;

            default:
                break;
            }
        }
    }

    private func refreshProject() {
        CDockSDK.getProject(self.projectModel.projectId) { [weak self] model in
            self?.projectModel = model
            self?.updateControlsState()
        }
    }
}
