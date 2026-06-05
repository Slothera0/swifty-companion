import 'package:flutter/material.dart';
import 'users_array.dart';
import 'profil_page.dart';
import 'search_page.dart';

void main() async {
  runApp(const Swifty());
}

class Swifty extends StatelessWidget {
  const Swifty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty',
      home: const HomePage(title: 'Swifty'),

    );
  }
  
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget _page() {
    switch (_selectedIndex) {
      case 0: return UsersArray();
      case 1: return ProfilPage(login: 'arvoyer');
      case 2: return SearchPage();
      default: return UsersArray();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 120, 35),
        title: Text(widget.title),
      ),
      body:  _page(),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              heroTag: 'btn_users',
              shape: const CircleBorder(),
              backgroundColor: _selectedIndex == 0
                  ? Color.fromARGB(255, 0, 120, 35)
                  : Colors.grey,
              onPressed: () => setState(() => _selectedIndex = 0),
              child: const Icon(Icons.people),
            )),

            SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              heroTag: 'btn_profil',
              shape: const CircleBorder(),
              backgroundColor: _selectedIndex == 1
                  ? Color.fromARGB(255, 0, 120, 35)
                  : Colors.grey,
              onPressed: () => setState(() => _selectedIndex = 1),
              child: const Icon(Icons.person),
            )),

            SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              heroTag: 'btn_search',
              shape: const CircleBorder(),
              backgroundColor: _selectedIndex == 2
                  ? Color.fromARGB(255, 0, 120, 35)
                  : Colors.grey,
              onPressed: () => setState(() => _selectedIndex = 2),
              child: const Icon(Icons.search),
            )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
