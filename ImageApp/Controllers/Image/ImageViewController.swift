//
//  ImageViewController.swift
//  ImageApp
//
//  Created by Valentin Mille on 7/10/22.
//

import UIKit

class ImageViewController: UIViewController {
    // MARK: - @IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    // MARK: - Properties

    private var imagesData: Images?
    private let searchController = UISearchController()
    private let minImageToSelect = 2
    // Large Image URL
    private var selectedImagesIndex: [IndexPath] = [] {
        didSet {
            if selectedImagesIndex.count > 0 {
                self.searchController.searchBar.isUserInteractionEnabled = false
            } else {
                self.searchController.searchBar.isUserInteractionEnabled = true
            }
        }
    }

    private let alertNetwork = UIAlertController(
        title: "Network Error",
        message: "Oops, you seem not connected to internet. Please try again.",
        preferredStyle: .alert)

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Images"
        prepareCollectionView()
        prepareSearchBar()
        prepareAlert()
        loadImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.deleteItems(at: selectedImagesIndex)
        collectionView.reloadData()
        selectedImagesIndex.removeAll()
        nextButton.isEnabled = false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Methods

    private func prepareSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.text = ""
    }

    private func prepareAlert() {
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.loadImages()
        })
        alertNetwork.addAction(dismissAction)
    }

    private func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "GoToDetail" {
            if let imageDetailVC = segue.destination as? ImageDetailViewController {
                for index in selectedImagesIndex {
                    if let url = URL(string: imagesData?.hits[index.row].largeImageURL ?? "") {
                        imageDetailVC.imagesURL.append(url)
                    }
                }
            }
        }
    }

    // MARK: - @IBActions

    @IBAction
    func GoToDetail(_: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToDetail", sender: self)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        imagesData?.hits.count ?? 0
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath) as! ImageCollectionViewCell
        if let previewURL = imagesData?.hits[indexPath.row].previewURL {
            cell.setupView(imageURL: previewURL)
        }
        return cell
    }

    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath)
        -> CGSize {
        CGSize(width: 100, height: 100)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImagesIndex.append(indexPath)
        nextButton.isEnabled = selectedImagesIndex.count >= minImageToSelect
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedImagesIndex.firstIndex(where: { $0 == indexPath }) {
            selectedImagesIndex.remove(at: index)
        }
    }
}

// MARK: - Network

extension ImageViewController {
    private func loadImages(searchText: String = "") {
        if Reachability.isConnectedToNetwork() {
            ImageService
                .getImages(params: ImageParameter(searchText: searchText)) { (result: Result<Images, APIServiceError>) in
                    switch result {
                    case .success(let images):
                        self.imagesData = images
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    case .failure(let error):
                        // TODO: Handle Error (display an alert)
                        print("Error: \(error)")
                    }
                }
        }
        else {
            DispatchQueue.main.async {
                self.present(self.alertNetwork, animated: true)
            }
        }
    }
}

// MARK: UISearchBarDelegate

extension ImageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        if let text = searchBar.text {
            loadImages(searchText: text)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if imagesData?.hits.count ?? 0 == 0 {
            loadImages()
        }
        searchBar.text = ""
    }
}
