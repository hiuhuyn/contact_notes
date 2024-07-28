// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Note extends Equatable {
  int? id;
  String? desc;
  int? idLabel;
  DateTime? created;
  DateTime? updated;
  List<String>? photos;
  Note({
    this.id,
    this.desc,
    this.idLabel,
    this.created,
    this.updated,
    this.photos,
  });

  @override
  List<Object?> get props {
    return [
      id,
      desc,
      idLabel,
      created,
      updated,
      photos,
    ];
  }

  @override
  String toString() {
    return "id: $id, desc: $desc, created: $created, updated: $updated, photos: ${photos?.map(
          (e) => e.toString(),
        ).toList()}";
  }
}
