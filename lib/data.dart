import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Talk {
  final String startTime;
  final String length;
  final String title;
  final String label;
  final String place;
  final String description;
  final Speaker speaker;

  Talk.fromJson(Map jsonMap) :
    startTime = jsonMap['start_time'],
    length = jsonMap['length'],
    title = jsonMap['title'],
    label = jsonMap['label'],
    place = jsonMap['place'],
    description = jsonMap['description'],
    speaker = Speaker.fromJson(jsonMap['speaker']);

  String toString() => 'Palestra: $title';
}

class Speaker{
  final String name;
  final List<String> thumbnail;
  final String bio;
  final String contact;

  Speaker.fromJson(Map<String, dynamic> jsonMap) :
    name = jsonMap['name'],
    thumbnail = List<String>.from(jsonMap['thumbnail']),
    bio = jsonMap['bio'],
    contact = jsonMap['contact'];
}

Future<List<Talk>> getTalksFromAsset() async {
  final jsonObj =
      json.decode(await rootBundle.loadString('assets/javaneiros.json'));
  return jsonObj
      .map<Talk>((jsonConf) => Talk.fromJson(jsonConf))
      .toList();
}

void launchBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}