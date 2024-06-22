import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NoteLabel extends Equatable {
  String? id;
  String? name;
  int? color;

  NoteLabel({
    this.id,
    this.name,
    this.color,
  });
  @override
  String toString() {
    return "NoteLabel(id: $id, name: $name, color: $color)";
  }

  @override
  List<Object?> get props => [id, name, color];
}
