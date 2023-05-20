//
//  UIImageViewExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Kingfisher
import UIKit

extension UIImageView {
    @IBInspectable
    var newImageColor: UIColor {
        get { return self.tintColor }
        set { self.changeImageColor(color: newValue) }
    }

    func changeImageColor(color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }

    func setImage(
        urlString: String?,
        placeholder: UIImage? = nil,
        completionHandler: ((ImageDownloadResult) -> Void)? = nil
    ) {
        if let urlString = urlString, let url = URL(string: urlString) {
            self.kf.setImage(with: url, placeholder: placeholder) { result in
                switch result {
                case .success:
                    completionHandler?(.success)
                case .failure:
                    completionHandler?(.fail)
                }
            }
        } else {
            completionHandler?(.fail)
        }
    }
}

enum ImageDownloadResult {
    case success
    case fail
}
