import 'package:flutter/material.dart';
import 'api.dart';
import 'profil_card.dart';
import 'profil_page.dart';

class UsersArray extends StatefulWidget {
  
  const UsersArray({
    super.key
  });

  @override
  State<UsersArray> createState() => _UsersArrayState();
}

class _UsersArrayState extends State<UsersArray> {
  final List<Map<String, dynamic>> _users = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _loading = false;
  bool _moreResults = true;

  @override
  void initState() {  
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 600) { // changer plus tard
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || !_moreResults) return;

    setState(() => _loading = true);

    final news = await Api42.getUsers(page: _page);

    setState(() {
      _users.addAll(
        news.where((u) => u['active?'] == true).toList()
      );
      _page++;
      _loading = false;
      if (news.isEmpty) _moreResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.75,
      ),
      itemCount: _users.length + 1,
      itemBuilder: (context, index) {
        if (index == _users.length) {
          if (!_moreResults) return const SizedBox();
          return const Center(child: CircularProgressIndicator());
        }

        final user = _users[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilPage(login: user['login']),
              ),
            );
          },
          child:ProfilCard(
            name: user['displayname'] ?? 'Unknow user',
            imageUrl: user['image']?['versions']?['medium'] ?? 'https://ui-avatars.com/api/?name=${user['login']}&background=027823&color=fff',
          ),
        );
      },
    );
  }
}