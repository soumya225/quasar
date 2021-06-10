import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quasar/models/story.dart';
import 'package:quasar/services/boxes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class StoryGridTile extends StatefulWidget {
  final Story story;

  StoryGridTile({Key? key, required this.story}) : super(key: key);

  @override
  _StoryGridTileState createState() => _StoryGridTileState();
}

class _StoryGridTileState extends State<StoryGridTile> {
  final box = Boxes.getStories();
  Icon _bookmarkIcon = Icon(Icons.bookmark_outline_rounded);

  @override
  void initState() {
    if (box.containsKey(widget.story.url)) {
      _bookmarkIcon = Icon(Icons.bookmark_rounded);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () async {
        final snackBar = SnackBar(content: Text("Could not open ${widget.story.url}"));

        await canLaunch(widget.story.url)
            ? await launch(widget.story.url, forceWebView: true)
            : ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CachedNetworkImage(
                imageUrl: widget.story.imageUrl,
                placeholder: (context, url) {
                  return SpinKitFadingFour(
                    color: Colors.white70,
                    shape: BoxShape.rectangle,
                  );
                },
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.story.newsSite,
                        style: TextStyle(
                          color: Color(0xBABABABA),
                          letterSpacing: 2.0,
                        ),
                      ),
                      IconButton(
                          icon: _bookmarkIcon,
                          onPressed: () {
                            if(!box.containsKey(widget.story.url)) {
                              box.put(widget.story.url, widget.story);
                              _bookmarkIcon = Icon(Icons.bookmark_rounded);
                            } else {
                              box.delete(widget.story.url);
                              _bookmarkIcon = Icon(Icons.bookmark_outline_rounded);
                            }
                            setState(() {

                            });
                          }
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      widget.story.title,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    "Published ${timeago.format(widget.story.publishedAt)}",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  SizedBox(height: 8.0,),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

