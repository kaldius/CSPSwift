extension Float: Value {
    init?(_ value: any Value) {
        if let intValue = value as? Int {
            self.init(intValue)
        } else if let floatValue = value as? Float {
            self.init(floatValue)
        } else {
            return nil
        }
    }
}
