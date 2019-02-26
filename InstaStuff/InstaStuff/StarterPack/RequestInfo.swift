struct RequestInfo<T, E> {
    
    // MARK: - Nested Type
    
    enum Info {
        case ok(T)
        case error(E?)
    }
    
    // MARK: - Properties
    
    let result: T?
    
    let error: E?
    
    var info: Info {
        if let result = result {
            return .ok(result)
        } else {
            return .error(error)
        }
    }
}
