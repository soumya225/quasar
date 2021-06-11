import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quasar/screens/bookmarks.dart';
import 'package:quasar/screens/loading.dart';
import 'package:quasar/screens/no_internet.dart';
import 'package:quasar/screens/tile.dart';
import 'package:quasar/services/api.dart';
import 'package:quasar/models/story.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StoryAdapter());
  await Hive.openBox<Story>("stories");
  runApp(MyApp());
}

/*
flutter run -d chrome --no-sound-null-safety --web-renderer=html
 */

final darkTheme = ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark
        ),
        brightness: Brightness.dark,
        canvasColor: Colors.black,
        hoverColor: Colors.grey[800],
        cardColor: Colors.black38,
        accentColor: Colors.pinkAccent,
        iconTheme: IconThemeData(
          color: Colors.pinkAccent,
          size: 56.0,
        ),
        fontFamily: "Verdana",
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quasar',
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
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
  bool isConnectedToInternet = true;

  Future getStories() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      isConnectedToInternet = false;
    } else {
      articles = await Api(url: "https://api.spaceflightnewsapi.net/v3/articles").getStoriesFromUrl();
      blogs = await Api(url: "https://api.spaceflightnewsapi.net/v3/blogs").getStoriesFromUrl();
      reports = await Api(url: "https://api.spaceflightnewsapi.net/v3/reports").getStoriesFromUrl();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getStories();
    super.initState();
  }

  Widget _buildList(double screenWidth, List<Story> list) {
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

    return isLoading
        ? Loading()
        : !isConnectedToInternet
          ? NoInternet()
          : DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                      icon: Icon(Icons.bookmarks_outlined),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute( builder: (context) => Bookmarks()),
                        );
                      },
                    ),
                  ],
                  title: Image.asset(
                      "assets/icons/in-app-icon.png",
                      width: 160
                  ),
                  centerTitle: true,
                  bottom: TabBar(
                    indicator: CircleTabIndicator(color: Theme.of(context).accentColor, radius: 3),
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

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;
  final Color color;
  final double radius;

  CircleTabIndicator({required this.color, required this.radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([ VoidCallback? onChanged ]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
