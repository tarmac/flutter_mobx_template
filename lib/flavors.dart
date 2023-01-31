// ignore_for_file: constant_identifier_names
enum Flavor { DEV, QA, PROD }

late final Flavor appFlavor;

extension FlavorExtension on Flavor {
  String get baseUrl {
    switch (this) {
      case Flavor.QA:
      case Flavor.PROD:
      case Flavor.DEV:
      default:
        return 'http://192.168.2.110:3000';
    }
  }

  String get appTitle {
    switch (this) {
      case Flavor.QA:
        return 'SecretWall QA';
      case Flavor.DEV:
        return 'SecretWall DEV';
      case Flavor.PROD:
      default:
        return 'SecretWall';
    }
  }

  int get connectTimeout {
    switch (appFlavor) {
      case Flavor.DEV:
        return 20000;
      default:
        return 5000;
    }
  }
}
