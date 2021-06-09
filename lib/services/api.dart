import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quasar/models/story.dart';

class Api {
  final String url;

  Api({required this.url});


  Future<List<Story>> getStoriesFromUrl() async {
    List<Story> stories = [];

    http.Response response = await http.get(Uri.parse(url));

    List data = json.decode(response.body);

    data.forEach((element) {
      stories.add(Story(
        title: element["title"],
        url: element["url"],
        imageUrl: element["imageUrl"],
        newsSite: element["newsSite"],
        summary: element["summary"],
        publishedAt: DateTime.parse(element["publishedAt"]),
        updatedAt: DateTime.parse(element["updatedAt"]),
      ));
    });

    return stories;
  }

}