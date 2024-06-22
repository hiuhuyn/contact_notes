import 'dart:convert';

import 'package:contact_notes/app/domain/entity/note_label.dart';

// ignore: must_be_immutable
class NoteLabelModel extends NoteLabel {
  NoteLabelModel({
    super.id,
    super.name,
    super.color,
  });
  factory NoteLabelModel.fromEntity(NoteLabel entity) {
    return NoteLabelModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
    );
  }

  factory NoteLabelModel.fromMap(Map<String, dynamic> map) {
    return NoteLabelModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      color: map['color'] != null ? map['color'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
    };
  }

  NoteLabel toEntity() => NoteLabel(
        id: id,
        name: name,
        color: color,
      );

  NoteLabelModel copyWith({
    String? id,
    String? name,
    int? color,
  }) {
    return NoteLabelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteLabelModel.fromJson(String source) =>
      NoteLabelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NoteLabel(id: $id, name: $name, color: $color)';
}
