import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quasar/models/story.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class StoryGridTile extends StatelessWidget {
  final Story story;

  StoryGridTile({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final snackBar = SnackBar(content: Text("Could not open ${story.url}"));

        await canLaunch(story.url)
            ? await launch(story.url, forceWebView: true)
            : ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              story.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0,),
          Text(
            story.newsSite,
            style: TextStyle(color: Color(0xBABABABA)),
          ),
          Text(
            story.title,
          ),
          Text(
            "Published ${timeago.format(story.publishedAt)}",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ],
      ),
    );
  }
}

