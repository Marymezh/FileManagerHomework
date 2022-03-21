//
//  ViewController.swift
//  FileManagerHomework
//
//  Created by Maria Mezhova on 14.03.2022.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    private let fileManager = FileManager.default
    private var currentDirectoryURL: URL
    private var directoryContent: [URL] = []

    init(directoryURL:URL) {
        self.currentDirectoryURL = directoryURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  //  private var content: [URL] = []
    
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
        
        setupNavBar()
        setupCollectionView()
        setupFileManager()
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
    
    private func setupNavBar() {
        navigationItem.title = "File Manager"
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setupFileManager() {
        self.directoryContent = try! fileManager.contentsOfDirectory(
            at: currentDirectoryURL,
            includingPropertiesForKeys: nil,
            options: [])
    }
}

extension FileManagerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var baseInset: CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCell.self),
            for: indexPath) as! CollectionViewCell
        
        let pictureURL = directoryContent[indexPath.item]
        cell.nameLabel.text = "Photo \(indexPath.item + 1)"
      //  let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.imageView.image = UIImage(contentsOfFile: pictureURL.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 7
        
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
}

extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let data = image.pngData()
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        
        let imagePath = currentDirectoryURL.appendingPathComponent("Photo - \(imageName)")

        fileManager.createFile(
            atPath: imagePath.path,
            contents: data,
            attributes: nil)
        directoryContent.append(imagePath)
        collectionView.reloadData()
        dismiss(animated: true)
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

