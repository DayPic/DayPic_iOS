//
//  SampleViewController.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import UIKit

final class SampleViewController: UIViewController {
    
    let viewModel: SampleViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(viewModel: SampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

