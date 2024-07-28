import 'dart:convert';
import 'package:contact_notes/app/domain/entity/people_note.dart';

// ignore: must_be_immutable
class PeopleNoteModel extends PeopleNote {
  PeopleNoteModel._({
    required super.name,
    super.id,
    super.created,
    super.updated,
    super.desc,
    super.photos,
    super.relationships,
    super.idLabel,
    super.phoneNumber,
    super.address,
    super.isMale,
    super.birthday,
    super.country,
    super.maritalStatus,
    super.occupation,
    super.latitude,
    super.longitude,
  });
  factory PeopleNoteModel.fromEntity(PeopleNote entity) {
    return PeopleNoteModel._(
      name: entity.name,
      id: entity.id,
      created: entity.created,
      updated: entity.updated,
      desc: entity.desc,
      photos: entity.photos,
      idLabel: entity.idLabel,
      phoneNumber: entity.phoneNumber,
      relationships: entity.relationships,
      address: entity.address,
      isMale: entity.isMale,
      birthday: entity.birthday,
      country: entity.country,
      maritalStatus: entity.maritalStatus,
      occupation: entity.occupation,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'desc': desc,
      'idLabel': idLabel,
      'created': created?.toString(),
      'updated': updated?.toString(),
      'photos': photos.toString(),
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthday': birthday?.toString(),
      'country': country,
      'occupation': occupation,
      'maritalStatus': maritalStatus,
      'isMale': isMale == true ? 1 : 0,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic> toMapBackup() {
    if (photos != null) {
      for (int i = 0; i < photos!.length; i++) {
        photos![i] = photos![i].split('/').last;
      }
    }
    return {
      'id': id,
      'desc': desc,
      'idLabel': idLabel,
      'created': created?.toString(),
      'updated': updated?.toString(),
      'photos': photos.toString(),
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'birthday': birthday?.toString(),
      'country': country,
      'occupation': occupation,
      'maritalStatus': maritalStatus,
      'isMale': isMale == true ? 1 : 0,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PeopleNoteModel.fromMap(Map<String, dynamic> map) {
    final mapPhotos = map["photos"];
    List<String>? photos;
    if (mapPhotos is String) {
      // Loại bỏ các dấu ngoặc vuông đầu và cuối
      String trimmedStr = mapPhotos.substring(1, mapPhotos.length - 1);
      // xoá khoảng trắng
      trimmedStr = trimmedStr.replaceAll(RegExp(r'\s+'), '');
      // Chuyển chuỗi thành một danh sách
      List<String> result = trimmedStr.split(',');
      photos = result;
    }

    return PeopleNoteModel._(
      id: map['id'],
      desc: map['desc'] != null ? map['desc'] as String : null,
      idLabel: map['idLabel'],
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
      photos: photos,
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      isMale: map['isMale'] != null && map['isMale'] == 1 ? true : false,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      birthday:
          map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      occupation: map['occupation'],
      country: map['country'],
      maritalStatus: map['maritalStatus'],
    );
  }

  factory PeopleNoteModel.fromJson(String source) =>
      PeopleNoteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
