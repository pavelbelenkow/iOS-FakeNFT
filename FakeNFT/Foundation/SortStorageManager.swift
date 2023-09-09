import Foundation

final class SortStorageManager {
    
    static let shared = SortStorageManager()
    
    private let defaults = UserDefaults.standard
    
    private let sortOptionKey = "sortOption"
    private let sortDirectionKey = "sortDirection"
    
    var sortOption: SortOption {
        get {
            SortOption(rawValue: defaults.string(forKey: sortOptionKey) ?? "") ?? .name
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortOptionKey)
        }
    }
    
    var sortDirection: SortDirection {
        get {
            SortDirection(rawValue: defaults.string(forKey: sortDirectionKey) ?? "") ?? .ascending
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortDirectionKey)
        }
    }
}
