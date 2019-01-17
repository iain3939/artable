//
//  ViewController.swift
//  Artable
//
//  Created by iain Allen on 02/01/2019.
//  Copyright © 2019 iain Allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.loginVC)
        present(controller, animated: true, completion: nil)
    }


}

