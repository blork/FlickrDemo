import SwiftUI

struct OneTimeTask: ViewModifier {

    @State private var hasAppeared = false
    private let action: (() async -> Void)
    
    init(perform action: @escaping (() async -> Void)) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.task {
            if !hasAppeared {
                hasAppeared = true
                await action()
            }
        }
    }
}

public extension View {
    func oneTimeTask(perform action: @escaping (() async -> Void)) -> some View {
        modifier(OneTimeTask(perform: action))
    }
}
