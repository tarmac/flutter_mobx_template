// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  QA,
  PROD,
}

Flavor? appFlavor;

extension FlavorExtension on Flavor {
  String get baseUrl {
    switch (this) {
      case Flavor.QA:
        return 'http://192.168.2.110:3000';
      case Flavor.PROD:
        return 'http://192.168.2.110:3000';
      case Flavor.DEV:
        return 'http://192.168.2.110:3000';
      default:
        return 'http://192.168.2.110:3000';
    }
  }

    String get appTitle {
        switch (this) {
      case Flavor.QA:
        return 'SecretWall QA';
      case Flavor.PROD:
        return 'SecretWall';
      case Flavor.DEV:
        return 'SecretWall DEV';
      default:
        return 'SecretWall';
    }
  }
}
