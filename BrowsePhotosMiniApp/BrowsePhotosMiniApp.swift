import BrowsePhotos
import SwiftUI

@main
struct BrowsePhotosMiniApp: App {
    
    var body: some Scene {
        WindowGroup {
            BrowsePhotos.Root(photoRepository: StubPhotoRepository(photos: .preview))
        }
    }
}
