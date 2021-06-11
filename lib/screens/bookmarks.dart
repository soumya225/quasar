import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quasar/main.dart';
import 'package:quasar/models/story.dart';
import 'package:quasar/services/boxes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({Key? key}) : super(key: key);

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  final box = Boxes.getStories();

  Widget buildContent(List<Story> stories) {
    if(stories.isEmpty) {
      return Center(
        child: Text("No bookmarks to show"),
      );
    } else {
      return ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Theme.of(context).hoverColor,
            borderRadius: BorderRadius.circular(16.0),
            onTap: () async {
              final snackBar = SnackBar(content: Text("Could not open ${stories[index].url}"));

              await canLaunch(stories[index].url)
                  ? await launch(stories[index].url, forceWebView: true)
                  : ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.delete_outline_outlined),
                onPressed: () {
                  stories[index].delete();
                  //box.delete(stories[index].url);
                },
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  stories[index].title,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              subtitle: Text(
                stories[index].newsSite,
                style: TextStyle(
                  color: Color(0xBABABABA),
                  letterSpacing: 2.0,
                ),
              ),
              trailing: Text(
                "${timeago.format(stories[index].publishedAt)}",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute( builder: (context) => MyHomePage()),
            );
          },
        ),
        title: Image.asset(
            "assets/icons/in-app-icon.png",
            width: 160
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<Story>>(
        valueListenable: Boxes.getStories().listenable(),
        builder: (context, box, _) {
          final stories = box.values.toList().cast<Story>();

          return buildContent(stories);
        },
      ),
    );
  }
}
