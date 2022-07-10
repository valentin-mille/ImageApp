//
//  ImageCollectionViewCell.swift
//  ImageApp
//
//  Created by Valentin Mille on 7/10/22.
//

import Kingfisher
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK: - @IBOutlets

    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties

    static let identifier = "ImageCollectionViewCell"

    // MARK: - View lifecycle

    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 5 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderColor = UIColor(named: "Select")!.cgColor
        isSelected = false
    }

    // MARK: - Methods

    func setupView(imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        }
    }
}
