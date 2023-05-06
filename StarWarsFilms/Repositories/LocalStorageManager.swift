import RealmSwift

protocol LocalStorageManagable {
    func saveFilms(_ films: [Film]) throws
    func retrieveFilms() throws -> [Film]
}
// Local storage class for persisting films to support offline
class LocalStorageManager: LocalStorageManagable {
    private var realm: Realm?

    init(_ realm: Realm?) {
        self.realm = realm
    }

    func saveFilms(_ films: [Film]) throws {
        guard let realm = realm else {
            throw NSError(domain: "LocalStorageManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Realm not set"])
        }

        do {
            try realm.write {
                realm.add(films, update: .all)
            }
        } catch {
            throw NSError(domain: "LocalStorageManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to save films to Realm: \(error.localizedDescription)"])
        }
    }

    func retrieveFilms() throws -> [Film] {
        guard let realm = realm else {
            throw NSError(domain: "LocalStorageManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Realm not set"])
        }

        let films = realm.objects(Film.self)
        return Array(films)
    }
}
