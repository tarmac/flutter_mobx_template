import 'dart:convert';
import 'dart:io';

Map<String, dynamic> fixture(String filename) => jsonDecode(File('./test/fixtures/$filename').readAsStringSync());

List<Map<String, dynamic>> fixtureList(String filename) =>
    (jsonDecode(File('./test/fixtures/$filename').readAsStringSync()) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
