//
//  TodayListViewController.swift
//
//
//  Created by 박준홍 on 5/21/24.
//

import UIKit
import DownpourRx

final public class TodayListViewController: UIViewController {
    
    private let viewModel: TodayListViewModel
    
    public init(viewModel: TodayListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
}
