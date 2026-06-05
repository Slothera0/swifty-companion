import 'package:flutter/material.dart';
import 'profil_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hauteur = MediaQuery.of(context).size.height;
    final largeur = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: largeur * 0.1,
        right: largeur * 0.1,
        bottom: hauteur * 0.4
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search a login',
              hintText: 'ex: avoyer',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            onSubmitted: (valeur) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilPage(login: valeur),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}