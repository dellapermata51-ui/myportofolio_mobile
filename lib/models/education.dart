import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    required this.institution,
    required this.startedAt,
    this.program = '',
    this.level = 's1',
    this.description = '',
    this.thumbnail,
    this.endedAt,
    this.id,
    this.levelDisplay = '',
    this.period = '',
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String institution;

  @JsonKey(defaultValue: '')
  final String program;

  @JsonKey(defaultValue: 's1')
  final String level;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String levelDisplay;
  @JsonKey(defaultValue: '')
  final String description;

  final String? thumbnail;
  final DateTime startedAt;
  final DateTime? endedAt;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String period;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
