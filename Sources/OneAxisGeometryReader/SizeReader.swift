import SwiftUI

struct SizeReader : PreferenceKey, Equatable {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
