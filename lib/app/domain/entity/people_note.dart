// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:contact_notes/app/domain/entity/note.dart';

// ignore: must_be_immutable
class PeopleNote extends Note {
  static const String stringUseMap = "people";
  String? name;
  String? phoneNumber;
  String? address;
  bool? isMale; // save sqlite = 1 if true and 0 if false
  DateTime? birthday;
  String? occupation;
  String? country;
  String? maritalStatus;
  double? latitude;
  double? longitude;
  List<Map<String, dynamic>>?
      relationships; // key: "relationship" : Relationship, "people" : PeopleNote
  PeopleNote({
    super.id,
    super.created,
    super.updated,
    super.desc,
    super.photos,
    super.idLabel,
    required this.name,
    this.relationships,
    this.phoneNumber,
    this.address,
    this.isMale,
    this.birthday,
    this.occupation,
    this.country,
    this.maritalStatus,
    this.latitude,
    this.longitude,
  }) {
    created ??= DateTime.now();
    updated ??= DateTime.now();
    isMale ??= true;
  }
  @override
  List<Object?> get props => [
        super.props,
        name,
        phoneNumber,
        address,
        isMale,
        latitude,
        longitude,
        relationships,
        birthday,
        occupation,
        country,
        maritalStatus,
      ];
  @override
  String toString() {
    return "${super.toString()}, name: $name, phone: $phoneNumber, address: $address, isMale: $isMale, latitude: $latitude, longitude: $longitude, relationships: $relationships, birthday: $birthday, occupation: $occupation, country: $country,MaritalStatus: $maritalStatus";
  }

  PeopleNote copyWith({
    int? id,
    String? desc,
    int? idLabel,
    DateTime? created,
    DateTime? updated,
    List<String>? photos,
    String? name,
    String? phoneNumber,
    String? address,
    bool? isMale,
    DateTime? birthday,
    String? occupation,
    String? country,
    String? maritalStatus,
    double? latitude,
    double? longitude,
    List<Map<String, dynamic>>?
        relationships, // key: "relationship" : Relationship, "people" : PeopleNote
  }) {
    return PeopleNote(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      idLabel: idLabel ?? this.idLabel,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      photos: photos != null
          ? List<String>.from(photos)
          : this.photos != null
              ? List<String>.from(this.photos!)
              : null,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      isMale: isMale ?? this.isMale,
      birthday: birthday ?? this.birthday,
      occupation: occupation ?? this.occupation,
      country: country ?? this.country,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      relationships: relationships != null
          ? List.from(relationships)
          : this.relationships != null
              ? List.from(this.relationships!)
              : null,
    );
  }
}
