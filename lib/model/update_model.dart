import 'dart:io';

class UpdateModel {
  String version;
  bool isForceUpdate;
  String oldVersion;
  String frequency; // [day,hour]
  String frequencyValue;
  String platform;
  String? note;
  String? rollout;

  UpdateModel({
    required this.version,
    required this.isForceUpdate,
    this.oldVersion = '1.0.0',
    this.frequency = 'day',
    this.frequencyValue = "1",
    this.platform = '',
    this.rollout = 'SPECIFIC',//[ALL,SPECIFIC]
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) => UpdateModel(
        version: json['version']??"1.0.0",
        isForceUpdate: json['is_force_update']??false,
        oldVersion: json['old_version'] ?? "1.0.0",
        frequency: json['frequency'] ?? "day",
        frequencyValue: json['frequency_value'] ?? "1",
        platform: json['platform'] ?? "",
        rollout: json['rollout'] ?? "SPECIFIC",
      );

  int get oldIntVersion {
    return int.tryParse(oldVersion.replaceAll(".", "")) ?? 0;
  }

  int get intVersion {
    return int.tryParse(version.replaceAll(".", "")) ?? 0;
  }

  Duration get duration {
    if (frequency.toLowerCase() == "day") {
      return Duration(days: int.tryParse(frequencyValue) ?? 0);
    } else {
      return Duration(hours: int.tryParse(frequencyValue) ?? 0);
    }
  }

  bool get isAndroid{
    return (Platform.isAndroid && platform == 'ANDROID');
  }

  bool get isIOS{
    return (Platform.isIOS && platform == 'IOS');
  }
}
