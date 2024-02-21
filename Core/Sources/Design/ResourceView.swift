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
            .disabled(!resource.isLoaded)
    }
}

public extension View {
    /// Adds a condition that controls whether the view is shown with an overlay matching a resource's state.
    ///
    /// If .loaded, the view is shown unmodified.
    /// if .loading, the view is redacted and shown with a progress view overlay.
    /// If .error, the view is redacted and shown with an error overlay
    /// - Parameter resource: A Resource value that determines how the view is shown, depending on the loading state of the resource.
    /// - Returns: The modified view.
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

