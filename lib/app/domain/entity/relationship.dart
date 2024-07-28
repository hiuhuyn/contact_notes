// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Relationship extends Equatable {
  static const String stringUseMap = "relationship";
  int? id;
  int? idPerson1;
  int? idPerson2;
  String? description;
  Relationship({this.id, this.idPerson1, this.idPerson2, this.description});

  @override
  List<Object?> get props => [id, idPerson1, idPerson2, description];
  @override
  String toString() {
    return "Relationship(id: $id, idPerson1: $idPerson1, idPerson2: $idPerson2, description: $description)";
  }

  Relationship copyWith({
    int? id,
    int? idPerson1,
    int? idPerson2,
    String? description,
  }) {
    return Relationship(
      id: id ?? this.id,
      idPerson1: idPerson1 ?? this.idPerson1,
      idPerson2: idPerson2 ?? this.idPerson2,
      description: description ?? this.description,
    );
  }
}
