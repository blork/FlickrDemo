# Demo Flickr App

This is a sample application which uses the Flickr API. The project is intended to show a modern SwiftUI app, with an MVVM architecture with a high degree of modularisation and testability. Many of the choices are overkill for an application of this size, but serve to illustrate a solid foundation upon which a larger app could be sustainably grown.

This project reflects around 10-12 hours of effort.

Note: Ideally, the Flickr API key would not appear in the git history, but it is included here in order make it easy to run the app.

The app is composed of 6 modules/packages split over 3 layers:

- Base Layer
	- Base
		- Contains utility methods and classes
	
- Core Layer
	- API
		- Contains networking code, such as creating and performing requests, and decoding responses into structs.
	- Design
		- Contains shared design code, such as styles, design values, and commonly shared stand-alone views.
	- Model
		- Contains domain object definitions that can be shared between features and the design library. There is duplication with the networking structs, but I prefer to have a separation between DOs and DTOs, as these model objects often have other responsibilities or need to do extra formatting which the network layer doesn't need to know. 
	
- Feature Layer
	- BrowsePhotos
		- A list of recent photos with search functionality and a detail page.
	- Nearby
		- A list of "nearby" photos presented in a map interface. The detail page from BrowsePhotos is imported and used - I'm happy to keep it in BrowsePhotos, but a case could be made to move it into the Design package instead.
	
The features are then imported by the main app target and composed into a tabview, with each tab being the "root view" of the feature. 

There are also 2 additional "mini app" targets which allow the features to be launched directly and independently of one another. This can be very useful in development, when you want to jump directly to the feature you are working on.

The features are composed of multiple SwiftUI Views named as "Screens" for clarity. Each of these has a ViewModel which performs the specific logic needed for thew view. This often takes the form of network requests which are performed by specific Repositories. These  the network requests from the API package and transform the decoded API structs into Model objects for consumption by views.

By having the separation of ViewModel and Repository, Unit Testing the VMs becomes simple as they can be provided Stub/Fake/Mock repos which return specific data in test, so simple assertions can be made.

The project makes use of Unit Tests for logic and Snapshot tests for UI, using the [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) library.