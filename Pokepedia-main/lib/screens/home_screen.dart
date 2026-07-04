import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokepedia/screens/pokemon_detals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokepedia = [];
  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      fetchData();
    }
    super.initState();
  }

  /*var pokepediaApi =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";*/
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset('assets/images/pokeball.png',
                width: 250, fit: BoxFit.fitHeight),
          ),
          const Positioned(
            top: 90,
            left: 15,
            child: Text(
              "Pokepedia",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 160,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                pokepedia != null
                    ? Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.4,
                          ),
                          itemCount: pokepedia.length,
                          itemBuilder: (context, index) {
                            var type = pokepedia[index]['type'][0];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: type == 'Grass'
                                          ? Colors.greenAccent
                                          : type == 'Fire'
                                              ? Colors.redAccent
                                              : type == 'Water'
                                                  ? Colors.blueAccent
                                                  : type == 'Electric'
                                                      ? Colors.yellowAccent
                                                      : type == 'Rock'
                                                          ? Colors.grey
                                                          : type == 'Ground'
                                                              ? Colors.brown
                                                              : type ==
                                                                      'Psychic'
                                                                  ? Colors
                                                                      .indigo
                                                                  : type ==
                                                                          'Fighthing'
                                                                      ? Colors
                                                                          .orange
                                                                      : type ==
                                                                              'Bug'
                                                                          ? Colors
                                                                              .lightGreen
                                                                          : type == 'Ghost'
                                                                              ? Colors.deepPurple
                                                                              : type == 'Normal'
                                                                                  ? Colors.black26
                                                                                  : type == 'Poison'
                                                                                      ? Colors.deepPurpleAccent
                                                                                      : Colors.pink,
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: -10,
                                          right: -10,
                                          child: Image.asset(
                                              'assets/images/pokeball.png',
                                              width: 100,
                                              fit: BoxFit.fitHeight),
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: 10,
                                          child: Text(
                                            pokepedia[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 10,
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(
                                                type.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: Colors.white30),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: CachedNetworkImage(
                                            imageUrl: pokepedia[index]['img'],
                                            height: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PokeDetails(
                                                  tag: index,
                                                  pokedetails: pokepedia[index],
                                                  color: type == 'Grass'
                                                      ? Colors.greenAccent
                                                      : type == 'Fire'
                                                          ? Colors.redAccent
                                                          : type == 'Water'
                                                              ? Colors
                                                                  .blueAccent
                                                              : type ==
                                                                      'Electric'
                                                                  ? Colors
                                                                      .yellowAccent
                                                                  : type ==
                                                                          'Rock'
                                                                      ? Colors
                                                                          .grey
                                                                      : type ==
                                                                              'Ground'
                                                                          ? Colors
                                                                              .brown
                                                                          : type == 'Psychic'
                                                                              ? Colors.indigo
                                                                              : type == 'Fighthing'
                                                                                  ? Colors.orange
                                                                                  : type == 'Bug'
                                                                                      ? Colors.lightGreen
                                                                                      : type == 'Ghost'
                                                                                          ? Colors.deepPurple
                                                                                          : type == 'Normal'
                                                                                              ? Colors.black26
                                                                                              : type == 'Poison'
                                                                                                  ? Colors.deepPurpleAccent
                                                                                                  : Colors.pink,
                                                )));
                                  }),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  void fetchData() {
    var url = Uri.https("raw.githubusercontent.com",
        "Biuni/PokemonGO-Pokedex/master/pokedex.json");
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var decodedData = jsonDecode(value.body);
        pokepedia = decodedData["pokemon"];
        setState(() {});
      }
    });
  }
}
