import Flickr
import SwiftUI

struct ContentView: View {
    
    @State var photoURL: URL? = nil
    
    var body: some View {
        AsyncImage(url: photoURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .task {
            let client = FlickrClient(
                session: URLSession.shared,
                apiKey: Configuration.flickrKey
            )

            do {
                let photos = try await client.recent()
                photoURL = photos.first?.url
                
                let info = try await client.info(for: photos.first!.id)
                print(info.dates)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
