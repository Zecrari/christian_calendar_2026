// Auto-generated file
import 'package:flutter/material.dart';

class ChristianEvent {
  final String name;
  final String reference;
  final String verseText;
  final Color color;
  ChristianEvent(this.name, this.reference, this.color, this.verseText);
}

class PrayerReminder {
  final String name;
  final TimeOfDay time;
  final bool enabled;
  final int iconCode;
  final int colorValue;
  final String frequency;

  PrayerReminder({
    required this.name,
    required this.time,
    required this.enabled,
    required this.iconCode,
    required this.colorValue,
    this.frequency = 'Daily',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hour': time.hour,
    'minute': time.minute,
    'enabled': enabled,
    'iconCode': iconCode,
    'colorValue': colorValue,
    'frequency': frequency,
  };

  factory PrayerReminder.fromJson(Map<String, dynamic> json) {
    return PrayerReminder(
      name: json['name'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      enabled: json['enabled'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      frequency: json['frequency'] ?? 'Daily',
    );
  }
}

class MysteryModel {
  final String title;
  final String fruit;
  final String scripture;
  final String description;

  const MysteryModel({
    required this.title,
    required this.fruit,
    required this.scripture,
    required this.description,
  });
}

class SaintModel {
  final String name;
  final String bio;
  final String prayer;
  final bool isMajorFeast;

  const SaintModel({
    required this.name,
    required this.bio,
    required this.prayer,
    this.isMajorFeast = false,
  });
}
