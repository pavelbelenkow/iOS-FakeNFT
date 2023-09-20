import Foundation

/**
``SortStorageManager`` предоставляет методы для получения и сохранения настроек сортировки
  - Cодержит методы для получения и сохранения настроек сортировки в `UserDefaults`
  - Можно сохранить ``SortOption`` и ``SortDirection`` сортировки
*/
final class SortStorageManager {

    /// Объект ``SortStorageManager`` для доступа к методам получения и сохранения настроек
    static let shared = SortStorageManager()

    /// Объект `UserDefaults` для сохранения настроек сортировки
    private let defaults = UserDefaults.standard

    /// Ключ для получения типа ``SortOption`` сортировки
    private let sortOptionKey = "sortOption"

    /// Ключ для получения направления ``SortDirection`` сортировки
    private let sortDirectionKey = "sortDirection"

    /// Тип сортировки для получения и сохранения
    var sortOption: SortOption {
        get {
            SortOption(rawValue: defaults.string(forKey: sortOptionKey) ?? "") ?? .name
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortOptionKey)
        }
    }

    /// Направление сортировки для получения и сохранения
    var sortDirection: SortDirection {
        get {
            SortDirection(rawValue: defaults.string(forKey: sortDirectionKey) ?? "") ?? .ascending
        }
        set {
            defaults.set(newValue.rawValue, forKey: sortDirectionKey)
        }
    }
}
