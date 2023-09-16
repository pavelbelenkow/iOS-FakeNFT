import UIKit

extension UIImage {
    
    enum NFTIcon {
        static let cart = UIImage(named: "Cart") ?? UIImage(systemName: "bag.fill")!
        static let cartAdd = UIImage(named: "CartAdd") ?? UIImage(systemName: "bag.badge.plus")!
        static let cartDelete = UIImage(named: "CartDelete") ?? UIImage(systemName: "bag.badge.minus")!
        static let catalogue = UIImage(named: "Catalogue") ?? UIImage(systemName: "square.stack.fill")!
        static let chevronLeft = UIImage(named: "ChevronLeft") ?? UIImage(systemName: "chevron.left")!
        static let chevronForward = UIImage(named: "ChevronForward") ?? UIImage(systemName: "chevron.forward")!
        static let liked = UIImage(named: "Liked") ?? UIImage(systemName: "heart.fill")!
        static let notLiked = UIImage(named: "NotLiked") ?? UIImage(systemName: "heart")!
        static let profile = UIImage(named: "Profile") ?? UIImage(systemName: "person.crop.circle.fill")!
        static let sorting = UIImage(named: "Sorting") ?? UIImage(systemName: "arrow.up.arrow.down.circle.fill")!
        static let statistics = UIImage(named: "Statistics") ?? UIImage(systemName: "flag.2.crossed.fill")!
        static let xmark = UIImage(named: "Xmark") ?? UIImage(systemName: "xmark")!
        
        static let starActive = UIImage(named: "StarActive") ?? UIImage(systemName: "star")!
        static let starNoActive = UIImage(named: "StarNoActive") ?? UIImage(systemName: "star")!
        static let zeroStars = UIImage(named: "ZeroStars") ?? UIImage(systemName: "star")!
        static let oneStar = UIImage(named: "OneStar") ?? UIImage(systemName: "star")!
        static let twoStars = UIImage(named: "TwoStars") ?? UIImage(systemName: "star")!
        static let threeStars = UIImage(named: "ThreeStars") ?? UIImage(systemName: "star")!
        static let fourStars = UIImage(named: "FourStars") ?? UIImage(systemName: "star")!
        static let fiveStars = UIImage(named: "FiveStars") ?? UIImage(systemName: "star")!
        
        static let paginator = UIImage(named: "Paginator") ?? UIImage(systemName: "dot.circle")!
        static let xmarkUniversal = UIImage(named: "XmarkUniversal") ?? UIImage(systemName: "xmark")!
    }
    
    enum NFTImage {
        static let onboardingOne = UIImage(named: "Onboarding_1") ?? UIImage(systemName: "photo")!
        static let onboardingTwo = UIImage(named: "Onboarding_2") ?? UIImage(systemName: "photo")!
        static let onboardingThree = UIImage(named: "Onboarding_3") ?? UIImage(systemName: "photo")!
    }
    
    class func colorForTabBar(color: UIColor) -> UIImage {
        let rect = CGRectMake(
            0.0,
            0.0,
            1.0,
            1.0
        )
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return image
    }
    
    enum NFTImage {
        static let successPaymentResult = UIImage(named: "SuccessPaymentResult") ?? UIImage(systemName: "checkmark.circle")!
        static let failurePaymentResult = UIImage(named: "FailurePaymentResult") ?? UIImage(systemName: "xmark.circle")!
    }
}
