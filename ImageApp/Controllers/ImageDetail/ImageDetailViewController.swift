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
        let imageWidth = 100
        let imageHeight = 100
        var xIndex = 0
        var yIndex = 0
        let maxWidth = Int(UIScreen.main.bounds.width + CGFloat(imageWidth))

        for i in 0 ..< imagesURL.count {
            var xPosition = xIndex * imageWidth

            if (xPosition > maxWidth) {
                xIndex = 0
                yIndex += 1
            }
            xPosition = xIndex * imageWidth
            let yPosition = yIndex * imageHeight
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: imageWidth, height: imageHeight)))

            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: imagesURL[i])
            imageView.layer.cornerRadius = 3
            stackImage.addSubview(imageView)
            xIndex += 1
        }
    }
}
