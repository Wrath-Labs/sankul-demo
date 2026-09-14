import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/activity.dart';
import '../models/activity.dart';

class ActivityNotifier extends Notifier<List<ActivityItem>> {
  @override
  List<ActivityItem> build() => buildSeedActivity();

  void add(ActivityItem item) => state = [item, ...state];
}

final activityProvider =
    NotifierProvider<ActivityNotifier, List<ActivityItem>>(ActivityNotifier.new);
