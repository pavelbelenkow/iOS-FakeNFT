import Foundation

extension String {
    var toURL: URL {
        URL(string: self) ?? URL(fileURLWithPath: "")
    }
}
