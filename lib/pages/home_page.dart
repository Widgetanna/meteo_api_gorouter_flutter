import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_meteo_flutter/components/weather_card.dart';
import 'package:my_meteo_flutter/models/weather_model.dart';
import 'package:my_meteo_flutter/service/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Future<List<WeatherData>> weatherdata;

  @override
  void initState() {
    weatherdata = WeatherService().fetchTemperatures();
    super.initState();
  }

  String cityName = '';
  //variable pour la condition pour mettre placeholder en rouge
  bool isCityNameEmpty = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 41, 125),
          title: const Text(
            'Ma météo du jour 🌤️',
            style: TextStyle(
              color: Colors.white, // Définir la couleur du texte sur blanc
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cloud.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => context.push('/geoloc'),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 300, top: 10),
                      child: Icon(Icons.location_on,
                          size: 50, color: Color.fromARGB(255, 13, 37, 145)),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<WeatherData>>(
                      future: weatherdata,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.count(
                            crossAxisCount: 2,
                            children: [
                              for (var i = 0; i < snapshot.data!.length; i++)
                                MyWidget(
                                  snapshot.data?[i].city ?? '',
                                  snapshot.data?[i].temperature ?? 0.0,
                                  snapshot.data?[i].localtime ?? '',
                                ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Erreur: ${snapshot.error}"),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              height: 210,
              color: const Color.fromARGB(255, 13, 41, 125),
            ),
            Positioned(
              left: 50,
              right: 50,
              bottom: 50,
              // button qui envoye la valeur ville vers la page localisation
              child: ElevatedButton(
                onPressed: () {
                  //avec la condition si le champ est vide afficher placeholder en rouge
                  if (cityName.isNotEmpty) {
                    GoRouter.of(context).go('/localisation', extra: cityName);
                      print(cityName);
                   } else {
                    setState(() {
                      isCityNameEmpty = true;
                    });
                    
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 13, 41, 125),
                  foregroundColor: const Color.fromARGB(255, 13, 41, 125),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text(
                  'GET WEATHER',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Carlito',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.location_city),
                  hintText:
                      isCityNameEmpty ? 'City name (required)' : 'City name',
                  hintStyle: TextStyle(
                    color: isCityNameEmpty ? Colors.red : Colors.grey,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    cityName = value;
                    print(cityName);
                    isCityNameEmpty = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
