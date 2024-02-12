import SwiftUI
import Base

struct ResourceViewModifier<T>: ViewModifier {
    let resource: Resource<T>
    
    func body(content: Content) -> some View {
        content
            .opacity(resource.isLoaded ? 1.0 : 0.3)
            .redacted(reason: resource.isLoaded ? .init() : .placeholder)
            .overlay {
                switch resource {
                case .loading:
                    ProgressView()
                case .error(let error):
                    ContentUnavailableView(error.localizedDescription, systemImage: "exclamationmark.triangle")
                case .loaded:
                    EmptyView()
                }
            }
    }
}

public extension View {
    func loading<T>(resource: Resource<T>) -> some View {
        modifier(ResourceViewModifier(resource: resource))
    }
}

#Preview("Loading") {
    Text(String.lipsum)
        .loading(resource: Resource<String>.loading)
        .padding()
}

#Preview("Loaded") {
    Text(String.lipsum)
        .loading(resource: Resource<String>.loaded("Hello"))
        .padding()
}

#Preview("Error") {
    Text(String.lipsum)
        .loading(resource: Resource<String>.error(PreviewError.whoops))
        .padding()
}

