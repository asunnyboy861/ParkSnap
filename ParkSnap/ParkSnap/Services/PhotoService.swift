import UIKit
import PhotosUI

@Observable
final class PhotoService {
    var selectedPhoto: UIImage?
    var showCamera = false
    var showPhotoPicker = false

    func compressImage(_ image: UIImage, maxDimension: CGFloat = 1200, quality: CGFloat = 0.7) -> Data? {
        let scale = min(maxDimension / image.size.width, maxDimension / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized?.jpegData(compressionQuality: quality)
    }
}
