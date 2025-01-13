import SwiftUI
import SwiftData

@Model
class Cache {
    var cacheID: String
    var data: Data
    var expiration: Date
    var creation: Date = Date()
    
    init(cacheID: String, data: Data, expiration: Date) {
        self.cacheID = cacheID
        self.data = data
        self.expiration = expiration
    }
}

final class CacheManager {
    @MainActor static let shared = CacheManager()
    
    // Separate Context For Cache Operations
    let context: ModelContext? = {
        guard let container = try? ModelContainer(for: Cache.self) else { return nil }
        let context = ModelContext(container: container)
        return context
    }()

    // CRUD Operations
    func insert(id: String, data: Data, expirationDays: Int) throws {
        guard let context else { return }
        
        // Checking if it's already existed
        if let cache = try get(id: id) {
            context.delete(cache)
        }
        
        let expiration = calculateExpirationDate(expirationDays)
        let cache = Cache(cacheID: id, data: data, expiration: expiration)
        context.insert(cache)
        try context.save()
    }
    
    func get(id: String) throws -> Cache? {
        guard let context else { return nil }
        
        let predicate = #Predicate<Cache> { $0.cacheID == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        // Since, it's only one
        descriptor.fetchLimit = 1
        
        if let cache = try context.fetch(descriptor).first {
            return cache
        }
        
        return nil
    }

    func remove(id: String) throws {
        guard let context else { return }
        if let cache = try get(id: id) {
            context.delete(cache)
            try context.save()
        }
    }
    
    func removeAll() throws {
        guard let context else { return }
        // Empty Fetch Descriptor will return all objects
        let descriptor = FetchDescriptor<Cache>()
        try context.enumerate(descriptor) {
            context.delete($0)
        }
        try context.save()
    }
    
    private func calculateExpirationDate(_ days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: .now) ?? .now
    }
}
