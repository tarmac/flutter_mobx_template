// ignore_for_file: constant_identifier_names
enum Flavor { DEV, QA, PROD }

late final Flavor appFlavor;

extension FlavorExtension on Flavor {
  String get baseUrl {
    switch (this) {
      case Flavor.QA:
      case Flavor.PROD:
      case Flavor.DEV:
        return 'http://192.168.1.61:3000'; // <-- change this to your local IP address
    }
  }

  String get appTitle {
    switch (this) {
      case Flavor.QA:
        return 'SecretWall QA';
      case Flavor.DEV:
        return 'SecretWall DEV';
      case Flavor.PROD:
        return 'SecretWall';
    }
  }

  int get connectTimeout {
    switch (this) {
      case Flavor.DEV:
        return 20000;
      case Flavor.QA:
      case Flavor.PROD:
        return 5000;
    }
  }
}
