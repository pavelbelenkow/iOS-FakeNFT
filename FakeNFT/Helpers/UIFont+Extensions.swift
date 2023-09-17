import UIKit

extension UIFont {

    enum NFTFont {
        static let regular13 = UIFont(
            name: "SFPro-Regular",
            size: 13
        ) ?? UIFont.systemFont(ofSize: 13)

        static let regular15 = UIFont(
            name: "SFPro-Regular",
            size: 15
        ) ?? UIFont.systemFont(ofSize: 15)

        static let regular17 = UIFont(
            name: "SFPro-Regular",
            size: 17
        ) ?? UIFont.systemFont(ofSize: 17)

        static let medium10 = UIFont(
            name: "SFPro-Medium",
            size: 10
        ) ?? UIFont.systemFont(
            ofSize: 10,
            weight: .medium
        )

        static let bold17 = UIFont(
            name: "SFPro-Bold",
            size: 17
        ) ?? UIFont.boldSystemFont(ofSize: 17)

        static let bold22 = UIFont(
            name: "SFPro-Bold",
            size: 22
        ) ?? UIFont.boldSystemFont(ofSize: 22)

        static let bold32 = UIFont(
            name: "SFPro-Bold",
            size: 32
        ) ?? UIFont.boldSystemFont(ofSize: 32)

        static let bold34 = UIFont(
            name: "SFPro-Bold",
            size: 34
        ) ?? UIFont.boldSystemFont(ofSize: 34)
    }
}
