//
//  PhotoViewController.swift
//  SeSacHW23
//
//  Created by 변정훈 on 2/4/25.
//

import UIKit
import PhotosUI
import SnapKit

class PhotoViewController: UIViewController {
    
    var contents: WeatherViewControllerDelegate?
    
    let pickerButton = UIButton()
    var photoImageList: [UIImage] = []
    lazy var photoCollectionView = createPhotoCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(pickerButtonClicked))
        configureView()
    }
    
    @objc
    func pickerButtonClicked() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.screenshots, .images])
        configuration.selectionLimit = 3
        configuration.mode = .default
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func configureView() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.backgroundColor = .white
    }
    
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.id, for: indexPath) as! PhotoCollectionViewCell
        cell.configureData(image: photoImageList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WeatherViewController()
        contents?.photoRecieved(value: photoImageList[indexPath.item])
        
        navigationController?.popViewController(animated: true)
    }
}

extension PhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    if let unwrappedImage = image as? UIImage {
                        self.photoImageList.append(unwrappedImage)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.photoCollectionView.reloadData()
        }
        
        dismiss(animated: true)
    }
}

extension PhotoViewController {
    private func createPhotoCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 3.5)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }
}
