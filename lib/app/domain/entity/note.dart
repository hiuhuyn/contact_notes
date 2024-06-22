// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Note extends Equatable {
  String? id;
  String? desc;
  String? idLabel;
  DateTime? created;
  DateTime? updated;
  List<String>? photos;
  String? author;
  Note({
    this.id,
    this.desc,
    this.idLabel,
    this.created,
    this.updated,
    this.photos,
    this.author,
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
      author,
    ];
  }

  @override
  String toString() {
    return "id: $id, desc: $desc, created: $created, updated: $updated, photos: ${photos?.map(
          (e) => e.toString(),
        ).toList()}";
  }
}
