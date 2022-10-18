//
//  ViewController.swift
//  FileManagerHomework
//
//  Created by Maria Mezhova on 14.03.2022.
//

import UIKit
import SwipeCellKit

class FileManagerViewController: UIViewController {
    
    private let fileManager = FileManager.default
    private lazy var documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    private var directoryContent: [URL] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout)
        collectionView.isUserInteractionEnabled = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.systemGray2
        collectionView.toAutoLayout()
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFileManager()
        setupNavBar()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupFileManager() {
        self.directoryContent = try! fileManager.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: nil,
            options: [])
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Pictures Directory"
//        navigationItem.leftBarButtonItem = nil
//        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem?.tintColor = .red
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func dismissVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension FileManagerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SwipeCollectionViewCellDelegate {
   
    private var baseInset: CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCell.self),
            for: indexPath) as! CollectionViewCell
        
        let pictureURL = directoryContent[indexPath.item]
        cell.nameLabel.text = "Photo \(indexPath.item + 1)"
        cell.imageView.image = UIImage(contentsOfFile: pictureURL.path)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directoryContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let pictureURL = directoryContent[indexPath.item]
        let photoVC = SelectedPictureViewController()
        photoVC.imageView.image = UIImage(contentsOfFile: pictureURL.path)
        
        navigationController?.present(photoVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - baseInset * 4) / 3, height: (collectionView.frame.width - baseInset * 4) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return baseInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: baseInset, left: baseInset, bottom: .zero, right: baseInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, IndexPath in
            let imagePath = self.directoryContent[indexPath.item]
            try! self.fileManager.removeItem(at: imagePath)
            self.directoryContent.remove(at: IndexPath.item)
            self.collectionView.reloadData()
            }
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
}

extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let data = image.pngData()
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        let imagePath = documentsURL.appendingPathComponent("Photo - \(imageName)")

        fileManager.createFile(
            atPath: imagePath.path,
            contents: data,
            attributes: nil)
        directoryContent.append(imagePath)
        collectionView.reloadData()
        dismiss(animated: true)
    }
}



