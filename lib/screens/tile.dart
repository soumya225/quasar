import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  static final customCacheManager = CacheManager(
    Config(
      "customCacheKey",
      stalePeriod: Duration(days: 1),
    )
  );

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
      splashColor: Theme.of(context).hoverColor,
      borderRadius: BorderRadius.circular(16.0),
      onTap: () async {
        final snackBar = SnackBar(content: Text("Could not open ${widget.story.url}"));

        await canLaunch(widget.story.url)
            ? await launch(widget.story.url, forceWebView: true)
            : ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).cardColor,
              Theme.of(context).primaryColor
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CachedNetworkImage(
                cacheManager: customCacheManager,
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
                      Flexible(
                        child: Text(
                          widget.story.newsSite,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xBABABABA),
                            letterSpacing: 2.0,
                          ),
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
                    "${timeago.format(widget.story.publishedAt)}",
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

