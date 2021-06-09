import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quasar/screens/loading.dart';
import 'package:quasar/screens/tile.dart';
import 'package:quasar/services/api.dart';
import 'package:quasar/models/story.dart';


void main() {
  runApp(MyApp());
}

/*
flutter run -d chrome --no-sound-null-safety --web-renderer=html
 */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quasar',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Story> articles = [];
  List<Story> blogs = [];
  List<Story> reports = [];

  bool isLoading = true;

  Future getStories() async {
    articles = await Api(url: "https://api.spaceflightnewsapi.net/v3/articles").getStoriesFromUrl();
    blogs = await Api(url: "https://api.spaceflightnewsapi.net/v3/blogs").getStoriesFromUrl();
    reports = await Api(url: "https://api.spaceflightnewsapi.net/v3/reports").getStoriesFromUrl();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getStories();
    super.initState();
  }

  Widget _buildList(double screenWidth, List list) {
    int _crossAxisCount = 0;

    if(screenWidth < 600) _crossAxisCount = 2;
    else if(screenWidth < 1200) _crossAxisCount = 3;
    else if(screenWidth < 2000) _crossAxisCount = 4;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return StoryGridTile(story: list[index]);
        },
        staggeredTileBuilder: (index) {
          return StaggeredTile.fit(1);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return isLoading ? Loading() : DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Articles"),
              Tab(text: "Blogs"),
              Tab(text: "Reports"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(screenWidth, articles),
            _buildList(screenWidth, blogs),
            _buildList(screenWidth, reports),
          ],
        ),
      ),
    );
  }
}
