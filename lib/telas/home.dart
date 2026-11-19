import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/telas/sobre.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.green),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    width: 200,
                    height: 100,
                    image: AssetImage('assets/images/upf.png'),
                  ),
                  Text(
                    'App Aula',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Contador'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.of(context).pushNamed('/contador');
              },
            ),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Sobre o app'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.of(context).pushNamed('/sobre');
              },
            ),

            ListTile(
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text('Crud Memória'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.of(context).pushNamed('/usuario_crud');
              },
            ),

            ListTile(
              leading: const Icon(Icons.supervised_user_circle_rounded),
              title: const Text('Crud SQLite'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.of(context).pushNamed('/usuario_crud_sqlite');
              },
            ),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                SystemNavigator.pop(); // close the app
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bem-vindo ao App Aula!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  width: 150,
                  height: 150,
                  image: AssetImage('assets/images/upf.png'),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/contador');
                },
                child: const Text('Ir para Contador'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/usuario_crud');
                },
                child: const Text('CRUD Memória'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/usuario_crud_sqlite');
                },
                child: const Text('CRUD SQLite'),
              ),
              const SizedBox(height: 12),                            
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SobrePage()),
                  );
                },
                child: const Text('Ir para Sobre App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





