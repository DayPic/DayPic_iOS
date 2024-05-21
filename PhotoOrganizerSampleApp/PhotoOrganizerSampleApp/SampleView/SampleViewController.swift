//
//  SampleViewController.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import UIKit
import DownpourRx
import SnapKit

final class SampleViewController: UIViewController {
    
    private let viewModel: SampleViewModel
    
    private let disposeBag: DisposeBag = .init()
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.setTitle("start test", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTestButtonLayout()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.loadPhotoOrganizer()
    }
    
    private func bind() {
        viewModel.isLoadingRelay
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { owner, isLoading in
                owner.testButton.backgroundColor = isLoading ? .lightGray : .magenta
                owner.testButton.isEnabled = !isLoading
            }
            .disposed(by: disposeBag)
    }
    
    init(viewModel: SampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTestButtonLayout() {
        self.view.addSubview(self.testButton)
        self.testButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }

}

