import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_cubit.dart';
import 'package:contact_notes/app/presentaion/blocs/people_note/people_note_state.dart';
import 'package:contact_notes/app/presentaion/widgets/app_drawer.dart';
import 'package:contact_notes/app/presentaion/widgets/errors/empty_data.dart';
import 'package:contact_notes/app/presentaion/widgets/people_note/people_note_widget.dart';
import 'package:contact_notes/core/router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchTextController = TextEditingController();
  final searchFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    context.read<PeopleNoteCubit>().loaded();
  }

  @override
  void dispose() {
    searchFocus.unfocus();
    searchTextController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 5,
        title: TextFormField(
          controller: searchTextController,
          focusNode: searchFocus,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: FirebaseAuth.instance.currentUser?.photoURL !=
                        null
                    ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                    : null,
              ),
            ),
          ),
          onChanged: (value) {
            context.read<PeopleNoteCubit>().searchPeopleNoteByName(value);
          },
          onFieldSubmitted: (newValue) {
            searchFocus.unfocus();
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocBuilder<PeopleNoteCubit, PeopleNoteState>(
                builder: (context, state) {
                  if (state is PeopleNoteInitialState ||
                      state is PeopleNoteLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is PeopleNoteErrorState) {
                    return EmptyDataWidget();
                  }
                  if (state.subPeoples == null || state.subPeoples!.isEmpty) {
                    return EmptyDataWidget();
                  }
                  return ListView.builder(
                    cacheExtent: 1000,
                    itemCount: state.subPeoples!.length,
                    itemBuilder: (context, index) {
                      return PeopleNoteWidget.basic(
                        value: state.subPeoples![index],
                        onTap: () {
                          AppRouter.navigateToInformationPeopleNote(context,
                              peopleNote: state.subPeoples![index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(
        tag: DrawerTag.home,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.navigateToCreateNewPeopleNote(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
