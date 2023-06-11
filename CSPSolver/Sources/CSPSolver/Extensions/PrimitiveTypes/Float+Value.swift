extension Float: Value {
    // TODO: get rid of force cast by throwing error
    init?(_ value: any Value) {
        switch value {
        case is Int:
            self.init(value as! Int)
        case is Float:
            self.init(value as! Float)
        default:
            return nil
        }
    }
}
