import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/note_label/note_label_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/router/app_router.dart';

enum DrawerTag {
  home,
  noteLabel,
  share,
  settings,
  unknown,
}

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {
  AppDrawer({super.key, required this.tag, this.idNoteLabelSelect});
  DrawerTag tag;
  String? idNoteLabelSelect;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<NoteLabelCubit>().loaded();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Drawer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.amber),
              currentAccountPicture: CircleAvatar(
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL !=
                        null
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
              ),
              accountName: Text(
                "${FirebaseAuth.instance.currentUser?.displayName}",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "${FirebaseAuth.instance.currentUser?.email}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            _buildItem(
              title: AppLocalizations.of(context)!.home,
              tag: DrawerTag.home,
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
                AppRouter.navigateToHome(context);
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            _buildItem(
              title: AppLocalizations.of(context)!.note_label,
              icon: Icons.label,
              tag: DrawerTag.noteLabel,
              trailing: Text(AppLocalizations.of(context)!.more),
              onTap: () {
                Navigator.pop(context);
                AppRouter.navigateToNoteTag(context, selectNewLabel: true);
              },
            ),
            _listLabel(context),
            const Divider(
              color: Colors.grey,
            ),
            _buildItem(
              title: AppLocalizations.of(context)!.share_data,
              icon: Icons.share_outlined,
              tag: DrawerTag.share,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildItem(
              title: AppLocalizations.of(context)!.settings,
              icon: Icons.settings_outlined,
              tag: DrawerTag.settings,
              onTap: () async {
                Navigator.pop(context);
                AppRouter.navigateToSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Column _listLabel(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<NoteLabelCubit, NoteLabelState>(
          builder: (context, state) {
            if (state is NoteLabelInitialState) {
              return const SizedBox();
            }
            if (state is NoteLabelLoadingState) {
              return const ListTile(title: CircularProgressIndicator());
            }
            if (state is NoteLabelErrorState) {
              return Text(
                state.error!.message,
                style: const TextStyle(color: Colors.red),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.notes?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildItem(
                  title: "${state.notes![index].name}",
                  tag: DrawerTag.noteLabel,
                  icon: Icons.label_important_outline,
                  iconColor: state.notes![index].color != null
                      ? Color(state.notes![index].color!)
                      : null,
                  selected: widget.idNoteLabelSelect == state.notes![index].id,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      widget.idNoteLabelSelect = state.notes![index].id;
                    });
                    AppRouter.navigateToNoteTag(context,
                        noteLabel: state.notes![index]);
                  },
                );
              },
            );
          },
        ),
        _buildItem(
          title: AppLocalizations.of(context)!.new_label,
          tag: DrawerTag.noteLabel,
          icon: Icons.add,
          selected: false,
          onTap: () {
            Navigator.pop(context);
            AppRouter.navigateToNoteTag(context, selectNewLabel: true);
          },
        ),
      ],
    );
  }

  Widget _buildItem({
    IconData? icon,
    Color? iconColor,
    required String title,
    Widget? subtitle,
    VoidCallback? onTap,
    required DrawerTag tag,
    Widget? trailing,
    bool selected = true,
  }) {
    bool isSelected = widget.tag == tag && selected;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (tag != DrawerTag.settings) {
            widget.tag = tag;
          }
        });
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected && subtitle == null
              ? Colors.blue.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: ListTile(
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (trailing != null) trailing,
            ],
          ),
          selected: isSelected,
          selectedColor: Colors.blue,
          subtitle: subtitle,
          leading:
              Icon(icon, color: iconColor ?? (isSelected ? Colors.blue : null)),
        ),
      ),
    );
  }
}
