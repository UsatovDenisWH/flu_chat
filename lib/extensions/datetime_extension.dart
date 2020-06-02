import 'dart:core';

import 'package:flutter/foundation.dart';

extension DateTimeExtension on DateTime {
  static final SECOND = 1000;
  static final MINUTE = 60 * SECOND;
  static final HOUR = 60 * MINUTE;
  static final DAY = 24 * HOUR;

  String humanizeDiff({DateTime date}) {
    DateTime inDate = date ?? DateTime.now();
    int diffTime = inDate.difference(this).inMilliseconds;
    bool isPastTime = diffTime > 0;
    diffTime = diffTime.abs();

    if (diffTime >= 0 * SECOND && diffTime < 1 * SECOND) {
      return "только что";
    } else if (diffTime >= 1 * SECOND && diffTime < 45 * SECOND) {
      return isPastTime ? "несколько секунд назад" : "через несколько секунд";
    } else if (diffTime >= 45 * SECOND && diffTime < 75 * SECOND) {
      return isPastTime ? "минуту назад" : "через минуту";
    } else if (diffTime >= 75 * SECOND && diffTime < 45 * MINUTE) {
      return isPastTime
          ? "${diffTime ~/ MINUTE} ${declinationOfTime(diffTime ~/ MINUTE, TimeUnits.MINUTE)} назад"
          : "через ${diffTime ~/ MINUTE} ${declinationOfTime(diffTime ~/ MINUTE, TimeUnits.MINUTE)}";
    } else if (diffTime >= 45 * MINUTE && diffTime < 75 * MINUTE) {
      return isPastTime ? "час назад" : "через час";
    } else if (diffTime >= 75 * MINUTE && diffTime < 22 * HOUR) {
      return isPastTime
          ? "${diffTime ~/ HOUR} ${declinationOfTime(diffTime ~/ HOUR, TimeUnits.HOUR)} назад"
          : "через ${diffTime ~/ HOUR} ${declinationOfTime(diffTime ~/ HOUR, TimeUnits.HOUR)}";
    } else if (diffTime >= 22 * HOUR && diffTime < 26 * HOUR) {
      return isPastTime ? "день назад" : "через день";
    } else if (diffTime >= 26 * HOUR && diffTime < 360 * DAY) {
      return isPastTime
          ? "${diffTime ~/ DAY} ${declinationOfTime(diffTime ~/ DAY, TimeUnits.DAY)} назад"
          : "через ${diffTime ~/ DAY} ${declinationOfTime(diffTime ~/ DAY, TimeUnits.DAY)}";
    } else {
      return isPastTime ? "более года назад" : "более чем через год";
    }
  }

  String declinationOfTime([int value, TimeUnits unit]) {
    var absValue = value.abs();

    if (absValue >= 11 && absValue <= 19) {
      switch (unit) {
        case TimeUnits.SECOND:
          return "секунд";
        case TimeUnits.MINUTE:
          return "минут";
        case TimeUnits.HOUR:
          return "часов";
        case TimeUnits.DAY:
          return "дней";
      }
    } else if (absValue % 10 == 1) {
      switch (unit) {
        case TimeUnits.SECOND:
          return "секунду";
        case TimeUnits.MINUTE:
          return "минуту";
        case TimeUnits.HOUR:
          return "час";
        case TimeUnits.DAY:
          return "день";
      }
    } else if (absValue % 10 >= 2 && absValue % 10 <= 4) {
      switch (unit) {
        case TimeUnits.SECOND:
          return "секунды";
        case TimeUnits.MINUTE:
          return "минуты";
        case TimeUnits.HOUR:
          return "часа";
        case TimeUnits.DAY:
          return "дня";
      }
    } else {
      switch (unit) {
        case TimeUnits.SECOND:
          return "секунд";
        case TimeUnits.MINUTE:
          return "минут";
        case TimeUnits.HOUR:
          return "часов";
        case TimeUnits.DAY:
          return "дней";
      }
    }
    // uncertain input parameters
    return "";
  }
}

enum TimeUnits { SECOND, MINUTE, HOUR, DAY }
