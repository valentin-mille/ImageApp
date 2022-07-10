//
//  ImageDetailViewController.swift
//  ImageApp
//
//  Created by Valentin Mille on 7/10/22.
//

import Kingfisher
import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - @IBOutlets

    @IBOutlet weak var stackImage: UIStackView!

    // MARK: - Properties

    var imagesURL: [URL] = []
    private var images: [UIImage] = []

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.addStack()
        }
    }

    // MARK: - Methods

    private func addStack() {
        for i in 0 ..< imagesURL.count {
            let xOffset = i * 100
            let yOffset = i * 10
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: CGSize(width: 100, height: 100)))
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: imagesURL[i])
            imageView.layer.cornerRadius = 3
            stackImage.addArrangedSubview(imageView)
        }
//        stackImage.layoutSubviews()
    }
}
