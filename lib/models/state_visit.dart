import 'package:hive/hive.dart';

part 'state_visit.g.dart';

@HiveType(typeId: 0)
class StateVisit extends HiveObject {
  @HiveField(0)
  String code; // e.g. "MN"

  @HiveField(1)
  bool visited;

  @HiveField(2)
  String favoriteThing;

  StateVisit({
    required this.code,
    this.visited = false,
    this.favoriteThing = '',
  });
}
