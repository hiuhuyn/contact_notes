import 'dart:convert';

import 'package:contact_notes/app/domain/entity/relationship.dart';

// ignore: must_be_immutable
class RelationshipModel extends Relationship {
  RelationshipModel({
    super.id,
    super.idPerson1,
    super.idPerson2,
    super.description,
  });
  factory RelationshipModel.fromEntity(Relationship entity) {
    return RelationshipModel(
      id: entity.id,
      idPerson1: entity.idPerson1,
      idPerson2: entity.idPerson2,
      description: entity.description,
    );
  }

  Relationship copyWith({
    int? id,
    String? idPerson1,
    String? idPerson2,
    String? description,
  }) {
    return Relationship(
      id: id ?? this.id,
      idPerson1: idPerson1 ?? this.idPerson1,
      idPerson2: idPerson2 ?? this.idPerson2,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idPerson1': idPerson1,
      'idPerson2': idPerson2,
      'description': description,
    };
  }

  Relationship toEntity() => Relationship(
        id: id,
        idPerson1: idPerson1,
        idPerson2: idPerson2,
        description: description,
      );

  factory RelationshipModel.fromMap(Map<String, dynamic> map) {
    return RelationshipModel(
      id: map['id'] != null ? map['id'] as int : null,
      idPerson1: map['idPerson1'] != null ? map['idPerson1'] as String : null,
      idPerson2: map['idPerson2'] != null ? map['idPerson2'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RelationshipModel.fromJson(String source) =>
      RelationshipModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
