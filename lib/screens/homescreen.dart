import 'package:flutter/material.dart';
import 'package:youtube_ecommerce/screens/virtualtryonpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red.shade900,
          title: const Text('Virtual try-on'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {})
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
//            header
              UserAccountsDrawerHeader(
                accountName: const Text('Koushik Halder'),
                accountEmail: const Text('kushhalder@gmail.com'),
                currentAccountPicture: GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(color: Colors.red.shade900),
              ),

//            body

              InkWell(
                onTap: () {},
                child: const ListTile(
                  title: Text('Mall'),
                  leading: Icon(Icons.home),
                ),
              ),

              InkWell(
                onTap: () {},
                child: const ListTile(
                  title: Text('Profile'),
                  leading: Icon(Icons.person),
                ),
              ),

              InkWell(
                onTap: () {},
                child: const ListTile(
                  title: Text('Cart'),
                  leading: Icon(Icons.shopping_basket),
                ),
              ),

              InkWell(
                onTap: () {},
                child: const ListTile(
                  title: Text('Categories'),
                  leading: Icon(Icons.dashboard),
                ),
              ),

              InkWell(
                onTap: () {},
                child: const ListTile(
                  title: Text('Favourites'),
                  leading: Icon(Icons.favorite),
                ),
              ),
            ],
          ),
        ),

        //body
        body: Column(children: [
          const SizedBox(height: 50),
          //Circle Avatar Virtual try-on image
          // ignore: prefer_const_constructors
          Center(
            child: const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 150,
              // ignore: prefer_const_constructors
              child: Center(
                child: CircleAvatar(
                  radius: 140,
                  backgroundImage: AssetImage(
                    'assets/images/virtualtryon.jpg',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

//Virtual Mirror text
          const Text(
            'Welcome to Virtual Mirror',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(height: 10),
          const Text(
            'Get Started',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),

          const SizedBox(height: 40),
//Clickable Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VirtualTryon()),
              );
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.purple),
            child: const Text(
              "CLICK HERE",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]));
  }
}
