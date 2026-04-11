# flutter_mobx_template

This project serves as a template / example of an MVVM / mobx based architecture.
For that purpose we built an app called SecretWall which allows for anonymous posting of messages in a unique shared public "wall".
Since we don't have a backend with a REST API to go with it we faked one using [json-server](https://www.npmjs.com/package/json-server)

This project uses FVM to pin down a flutter version. Let's install that first:

```bash
brew install fvm
```

Before running the app start the fake server with

```bash
npm install -g json-server
npx json-server --watch db.json --host 0.0.0.0 --port 3000
```

You will also need to update the IP used by the mobile app to your current dev machine IP, you should do so in `lib/flavors.dart`

```dart
  String get baseUrl {
    switch (this) {
      case Flavor.QA:
      case Flavor.PROD:
      case Flavor.DEV:
      default:
        return 'http://192.168.1.31:3000'; // <-- change this to your local IP address
  }
```


Generate necessary dart code by running:

```bash
make gen-code
```

After that you can run any of the app's flavors from your IDE from the `lib/main_dev.dart`, `lib/main_qa.dart` or `lib/main_prod.dart`.

From command line with:

```bash
fvm flutter run lib/main_dev.dart
```


The main use cases for the app are:
1) open the app and see a list (newest first) of all the posts
2) post a new anonymous entry to be displayed for everyone 

### Architecture

- This project strings to follow [Model–view–viewmodel (MVVM)][mvvm] for its architecture.
  - `models` are stored in the /models directory
  - each screen on the app is a `view`
  - `views` should use `viewmodels` exclusively to manage data/service calls (instead of using models/services directly)


### Services

- Services are used to connect to external data sources and APIs.
- Generally, Services are stateless.
- Services should not execute business logic, they only work as an adapter/proxy to REST APIs or other data sources.

### Repositories

- Repositories handle data operations. For example: Fetching data from a service.
- They provide a clean API so that the rest of the app can retrieve this data easily.
- They know where to get the data from and what API calls to make when data is updated.
- Repositories can accesss Services to make remote calls and can process Models returned from services.
- Repositories are the mediators between data sources, such as local databases, data in files, web services, and caches.
- Repositories can contain global state.
- Repositories can access local persisted state (shared preferences, local DB, etc).

### Models

- They represent the business concepts and related business logic required by the app to fulfill it's use cases
- Models that share a common root model or have an certain amount of cohesion should be group together in a subfolder.
- Model subfolders will mostly match 1 to 1 to the repository name that provide those models.
- Models are usually deserialized from JSON when they are being return in a REST API service, although this is not a requiremient.

### ViewModels

- Holds the local view state and business logic of a view.
- Follows the lifecycle of its view.
- A new instance of a viewModel is usually created when a view is loaded and destroyed when navigating away.
- ViewModels reference Repositories (via GetIt) to access global state and execute business logic.
- ViewModels should NOT access Services directly. This should be done through a Repository.
- Usually viewModels are defined as one per View.
- ViewModels should NOT include any widget related code.

### Views

- Each view represents a screen in the mobile app.
- Every view has in its own  <name>_view.dart file as the entry point.
- Views should contain as little buisness logic as possible. Push business logic into viewModels instead.
- Views should never directly reference Repositories or Services. This should be done through a viewModel.
- All data displayed in a view comes from a viewModel which is responsable from fetching and managing that data.

## Tests

- Tests should mirror the same folder structure of the class that they are testing.

## boot.dart

- Initialization and startup logic should be done here.
- Initalize locators, SDKs, etc.
- Called by all Flavors.

## main_<flavor>.dart

- Entry point for each Flavor of the app
- There is one Flavor per environment (dev, qa, prod)
- Use `flavors.dart` to define Flavor specific values that are not secret (baseURL, etc).

[mvvm]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel
