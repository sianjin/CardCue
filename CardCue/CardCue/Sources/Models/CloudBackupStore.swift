import Foundation

// Mirrors selected UserDefaults keys to NSUbiquitousKeyValueStore as a private,
// per-account backup so data survives app deletion/reinstall.
//
// Not multi-device sync: data is only ever pulled from iCloud when local storage
// is empty (fresh install). Once local data exists, incoming iCloud changes are
// never applied, so two devices on the same iCloud account never overwrite each
// other's data.
enum CloudBackupStore {
    private static var cloud: NSUbiquitousKeyValueStore { .default }

    static func mirror(_ data: Data, forKey key: String) {
        cloud.set(data, forKey: key)
    }

    static func mirror(_ strings: [String], forKey key: String) {
        cloud.set(strings, forKey: key)
    }

    /// Returns cloud-backed data for `key`, but only when local UserDefaults has
    /// nothing yet — i.e. a fresh install being restored from a prior backup.
    static func restoreDataIfLocalEmpty(forKey key: String) -> Data? {
        guard UserDefaults.standard.data(forKey: key) == nil else { return nil }
        return cloud.data(forKey: key)
    }

    static func restoreStringsIfLocalEmpty(forKey key: String) -> [String]? {
        guard UserDefaults.standard.stringArray(forKey: key) == nil else { return nil }
        return cloud.array(forKey: key) as? [String]
    }
}
