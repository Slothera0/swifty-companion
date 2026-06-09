import 'package:flutter/material.dart';
import 'api.dart';

class ProfilPage extends StatefulWidget {
  final String login;
  const ProfilPage({super.key, required this.login});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map<String, dynamic>? _user;
  bool _loading = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerProfil();
  }

  Future<void> _chargerProfil() async {
    try{
      final user = await Api42.getUser(widget.login)
        .timeout(const Duration(seconds: 10));
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _erreur = 'Délai dépassé, vérifie ta connexion ou si le login existe';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erreur != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_erreur!),
              TextButton(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _erreur = null;
                  });
                  _chargerProfil();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _user!;
    final cursus = (user['cursus_users'] as List?)
      ?.firstWhere(
        (c) => c['grade'] != 'Pisciner' && c['skills'] != null,
        orElse: () => null,
      );
    final skillCount = cursus?['skills']?.length ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container( 
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(user['login']),
              ),
              background: Image.network(
                user['image']?['versions']?['large'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _sectionStats(user),
          ),
          SliverToBoxAdapter(
            child: _sectionInfos(user), 
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: const Text(
                'Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var skill =cursus?['skills']?[index];
                return ListTile(
                  title: Text(skill['name']),
                  trailing: Text(skill['level'].toStringAsFixed(2)),
                );
              },
              childCount: skillCount ?? 0,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Projets',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              final projet = user['projects_users'][index];
              return ListTile(
                title: Text(projet['project']['name']),
                trailing: Text(
                            projet['final_mark']?.toString() ?? 'En cours',
                            style: TextStyle(
                              color: projet['validated?'] == true
                                  ? Colors.green
                                  : projet['final_mark']?.toString() != null ? Colors.orange : Colors.grey,
                            ),
                            ),
              );
            },
            childCount: user['projects_users']?.length ?? 0,
          ),)
        ],
      ),
    );
  }

  Widget _sectionStats(Map<String, dynamic> user) {
    final cursus = (user['cursus_users'] as List?)
      ?.firstWhere(
        (c) => c['grade'] != 'Pisciner',
        orElse: () => null,
      );

    final double level = cursus?['level']?.toDouble() ?? user['cursus_users']?[0]?['level'] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stat('Level', level.toStringAsFixed(2)),
          _stat('Points', user['correction_point']?.toString() ?? '0'),
          _stat('Wallet', '${user['wallet'] ?? 0} ₳'),
        ],
      ),
    );
  }

  Widget _sectionInfos(Map<String, dynamic> user) {
    String campus = user['campus']?[0]?['name'] ?? 'Inconnu';
    if (campus == 'Forty2' && user['campus']?[1]?['name'] != null) {
      campus = user['campus']?[1]?['name'];
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Infos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _ligne(Icons.email, user['email'] ?? ''),
          _ligne(Icons.location_on, campus),
          _ligne(Icons.desktop_windows, user['location'] ?? 'offline'),
        ],
      ),
    );
  }

  Widget _stat(String label, String valeur) {
    return Column(
      children: [
        Text(valeur, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _ligne(IconData icone, String texte) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icone, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(texte),
        ],
      ),
    );
  }
}