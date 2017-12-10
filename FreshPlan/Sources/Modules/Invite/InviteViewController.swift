//
//  InviteViewController.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class InviteViewController: UIViewController {
    private var viewModel: InviteViewModelProtocol!
    private var router: InviteRouter!
    
    public convenience init(viewModel: InviteViewModel, router: InviteRouter) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = router
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
