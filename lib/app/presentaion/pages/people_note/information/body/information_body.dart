import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:contact_notes/app/domain/entity/note_label.dart';
import 'package:contact_notes/app/domain/entity/people_note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class InformationBody extends StatefulWidget {
  InformationBody({super.key, required this.people, this.label, this.padding});
  PeopleNote people;
  NoteLabel? label;
  EdgeInsetsGeometry? padding;

  @override
  State<InformationBody> createState() => _InformationBodyState();
}

class _InformationBodyState extends State<InformationBody> {
  bool isNameFocus = false;

  final nameTextCtrl = TextEditingController();
  final nameFocus = FocusNode();

  final phoneTextCtrl = TextEditingController();

  final addressesTextCtrl = TextEditingController();

  final descriptionTextCtrl = TextEditingController();
  final occupationTextCtrl = TextEditingController();

  final countryTextCtrl = TextEditingController();

  final birthdayTextCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    isNameFocus = nameFocus.hasFocus;
    nameFocus.addListener(
      () {
        setState(() {
          isNameFocus = nameFocus.hasFocus;
        });
      },
    );
    if (widget.people.id != null) {
      nameTextCtrl.text = widget.people.name ?? "";
      phoneTextCtrl.text = widget.people.phoneNumber ?? "";
      addressesTextCtrl.text = widget.people.address ?? "";
      occupationTextCtrl.text = widget.people.occupation ?? "";
      countryTextCtrl.text = widget.people.country ?? "";
      descriptionTextCtrl.text = widget.people.desc ?? "";
      widget.people.isMale ??= true;
      if (widget.people.birthday != null) {
        String formattedDate =
            DateFormat('dd/MM/yyyy').format(widget.people.birthday!);
        birthdayTextCtrl.text = formattedDate;
      }
    }
  }

  @override
  void dispose() {
    nameTextCtrl.dispose();
    phoneTextCtrl.dispose();
    addressesTextCtrl.dispose();
    descriptionTextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context)!.name}*",
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.name,
                ),
                controller: nameTextCtrl,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required field';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.phone_number,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.phone_number),
                controller: phoneTextCtrl,
                maxLines: 1,
                maxLength: 15,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.phoneNumber = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.addresses,
              ),
              TextFormField(
                controller: addressesTextCtrl,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.address = value;
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addresses,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.people.latitude = 10.2;
                          widget.people.longitude = 10.6;
                        });
                      },
                      icon: const Icon(Icons.location_on)),
                ),
              ),
              Visibility(
                visible: widget.people.latitude != null &&
                    widget.people.longitude != null,
                child: Text(
                  "${widget.people.latitude} ${widget.people.longitude}",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.sex,
                  ),
                  Radio(
                      value: true,
                      activeColor: Colors.blue,
                      groupValue: widget.people.isMale,
                      onChanged: (value) {
                        setState(() {
                          widget.people.isMale = value == true ? true : false;
                        });
                      }),
                  Text(
                    AppLocalizations.of(context)!.male,
                  ),
                  Radio(
                      value: false,
                      activeColor: Colors.blue,
                      groupValue: widget.people.isMale,
                      onChanged: (value) {
                        setState(() {
                          widget.people.isMale = value == true ? true : false;
                        });
                      }),
                  Text(
                    AppLocalizations.of(context)!.female,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.birthday,
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          currentDate: widget.people.birthday,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100))
                      .then(
                    (value) {
                      if (value != null) {
                        setState(() {
                          widget.people.birthday = value;
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(value);
                          birthdayTextCtrl.text = formattedDate;
                        });
                      }
                    },
                  );
                },
                child: TextFormField(
                  enabled: false,
                  controller: birthdayTextCtrl,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.birthday,
                    suffixIcon: const Icon(
                      Icons.date_range_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.occupation,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.occupation),
                controller: occupationTextCtrl,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.occupation = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.country,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.country),
                controller: countryTextCtrl,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.country = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.description,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.description),
                controller: descriptionTextCtrl,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  widget.people.desc = value;
                },
              ),
            ],
          )),
    );
  }
}
