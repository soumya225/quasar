import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quasar/models/story.dart';

class Boxes {
  static Box<Story> getStories() {
    return Hive.box<Story>("stories");
  }
}