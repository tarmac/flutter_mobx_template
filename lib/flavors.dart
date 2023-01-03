// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  QA,
  PROD,
}

// ignore: avoid_classes_with_only_static_members
class F {
  static Flavor? appFlavor;

  static String get baseUrl {
    switch (appFlavor) {
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

  static String get title {
        switch (appFlavor) {
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
