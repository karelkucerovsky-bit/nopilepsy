import Foundation

public enum NopiNumberFormatters {
    public static let scoreFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f
    }()

    public static let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .percent
        f.maximumFractionDigits = 0
        return f
    }()

    public static let decimalFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        return f
    }()

    public static func scoreString(_ score: Double) -> String {
        scoreFormatter.string(from: NSNumber(value: score)) ?? "\(Int(score))"
    }

    public static func percentString(_ value: Double) -> String {
        percentFormatter.string(from: NSNumber(value: value)) ?? "\(Int(value * 100))%"
    }
}
