import Foundation

/**
``SortStorageManager`` предоставляет методы для сохранения и установки настроек сортировки
  - Cодержит методы для сохранения и установки настроек сортировки в `UserDefaults`
  - Можно сохранить ``SortOption`` и ``SortDirection`` сортировки
*/
final class SortStorageManager {
    
    /// Объект ``SortStorageManager`` для доступа к методам сохранения и установки настроек
    static let shared = SortStorageManager()
    
    /// Объект `UserDefaults` для сохранения настроек сортировки
    private let defaults = UserDefaults.standard
    
    /// Ключ для сохранения ``SortOption`` сортировки
    private let sortOptionKey = "sortOption"
    
    /// Ключ для сохранения ``SortDirection`` сортировки
    private let sortDirectionKey = "sortDirection"
    
    /// Тип сортировки для сохранения и установки
    var sortOption: SortOption {
        get {
            SortOption(rawValue: defaults.string(forKey: sortOptionKey) ?? "") ?? .name
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortOptionKey)
        }
    }
    
    /// Направление сортировки для сохранения и установки
    var sortDirection: SortDirection {
        get {
            SortDirection(rawValue: defaults.string(forKey: sortDirectionKey) ?? "") ?? .ascending
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortDirectionKey)
        }
    }
}
