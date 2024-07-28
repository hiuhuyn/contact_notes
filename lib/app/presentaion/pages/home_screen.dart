import 'package:contact_notes/app/presentaion/pages/list_people_note_screen.dart';
import 'package:contact_notes/app/presentaion/pages/note_label_screen.dart';
import 'package:contact_notes/app/presentaion/pages/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indexPage = 0;
  final _controller = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: PageView(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  _indexPage = value;
                });
              },
              children: [
                const ListPeopleNoteScreen(),
                NoteLabelScreen(selectNewLabel: false),
                const SettingsScreen()
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label),
            label: "Labels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _indexPage,
        onTap: (value) {
          setState(() {
            _indexPage = value;
            _controller.jumpToPage(value);
          });
        },
      ),
    );
  }
}
