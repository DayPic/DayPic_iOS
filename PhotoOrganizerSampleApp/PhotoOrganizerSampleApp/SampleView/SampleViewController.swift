//
//  SampleViewController.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import UIKit
import DownpourRx
import SnapKit
import Photos

final class SampleViewController: UIViewController {
    
    private let viewModel: SampleViewModel
    private let disposeBag: DisposeBag = .init()
    
    private let loadButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.setTitle("Load Encoders", for: .normal)
        button.setTitle("Loading...", for: .disabled)
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.setTitle("Categorize", for: .normal)
        button.setTitle("working...", for: .disabled)
        return button
    }()
    
    private let updateDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CategorizedImageCell.self,
            forCellWithReuseIdentifier: "CategorizedImageCell"
        )
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayouts()
        bind()
        self.listView.dataSource = self
    }
    
    private func bind() {
        self.viewModel.isLoadingRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, isLoading in
                owner.loadButton.backgroundColor = isLoading ? .lightGray : .systemBlue
                owner.loadButton.isEnabled = !isLoading
            }
            .disposed(by: disposeBag)
        
        self.viewModel.isCategorizingRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, isCategorizing in
                owner.startButton.backgroundColor = isCategorizing ? .lightGray : .systemBlue
                owner.startButton.isEnabled = !isCategorizing
            }
            .disposed(by: disposeBag)
        
        self.viewModel.didLoadDataRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                if let photoManager = owner.viewModel.unsafeOrganizedPhotoManager {
                    owner.listView.reloadData()
                    owner.updateDateLabel.text = photoManager.updatedDate.toString()
                }
            }
            .disposed(by: disposeBag)
        
        
        self.loadButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.viewModel.loadPhotoOrganizer()
            }
            .disposed(by: disposeBag)
        
        self.startButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                Task {
                    await owner.viewModel.getPhotoAndOrganizeImage()
                }
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
    
}

extension SampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.unsafeOrganizedPhotoManager?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategorizedImageCell",
            for: indexPath
        ) as? CategorizedImageCell
        else {
            return UICollectionViewCell()
        }
        if let photo = viewModel.unsafeOrganizedPhotoManager?.photos[indexPath.row] {
            cell.configure(with: photo)
        }
        return cell
    }
}

extension SampleViewController {
    private func setLayouts() {
        setLoadEncodersButtonLayout()
        setStartButtonLayout()
        setUpdateDateLabelLayout()
        setListLayout()
    }
    
    private func setLoadEncodersButtonLayout() {
        self.view.addSubview(self.loadButton)
        self.loadButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setStartButtonLayout() {
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func setUpdateDateLabelLayout() {
        self.view.addSubview(self.updateDateLabel)
        updateDateLabel.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setListLayout() {
        self.view.addSubview(self.listView)
        self.listView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.updateDateLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
