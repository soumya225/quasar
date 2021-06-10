import 'package:hive/hive.dart';

part 'story.g.dart';


/*
HiveField numbers should not change.
Never reuse HiveField numbers.
Field types should not change.
 */

@HiveType(typeId: 0) 
class Story extends HiveObject {
  
  @HiveField(0)
  String title;

  @HiveField(1)
  String url;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String newsSite;

  @HiveField(4)
  String summary;

  @HiveField(5)
  DateTime publishedAt;

  @HiveField(6)
  DateTime updatedAt;

  Story({required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    required this.updatedAt});
}