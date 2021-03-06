import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/actions/parse_activity.dart';

Future<void> importActivitiesLocally({
  @required BuildContext context,
  @required Athlete athlete,
  @required Flushbar<Object> flushbar,
}) async {
  List<Activity> activities;

  flushbar = Flushbar<Object>(
    message: 'Importing activities from local directory',
    duration: const Duration(seconds: 1),
    icon: MyIcon.stravaDownloadWhite,
  )..show(context);
  await Activity.importFromLocalDirectory(athlete: athlete);
  flushbar = Flushbar<Object>(
    message: 'Activities moved into application',
    duration: const Duration(seconds: 1),
    icon: MyIcon.finishedWhite,
  )..show(context);

  activities = await athlete.activities;
  final List<Activity> downloadedActivities = activities
      .where((Activity activity) => activity.state == 'downloaded')
      .toList();
  for (final Activity activity in downloadedActivities) {
    await parseActivity(
      context: context,
      activity: activity,
      athlete: athlete,
      flushbar: flushbar,
    );
    await activity.autoTagger(athlete: athlete);
  }
  await flushbar.dismiss();
  flushbar = Flushbar<Object>(
    message: 'Activities imported!',
    duration: const Duration(seconds: 5),
    icon: MyIcon.finishedWhite,
  )..show(context);
}
