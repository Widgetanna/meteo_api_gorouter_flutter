import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:my_meteo_flutter/components/localisation_cart.dart';
import 'package:my_meteo_flutter/models/weather_model.dart';
import 'package:my_meteo_flutter/service/weather_service.dart';

class Localisation extends StatefulWidget {
  final String cityName;
  const Localisation({required this.cityName, super.key});

  @override
  State<Localisation> createState() => _Localisation();
}

class _Localisation extends State<Localisation> {
  late Future<WeatherData?> weatherdata;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    weatherdata = WeatherService().getCityFromTextField(widget.cityName);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 233, 237),
        title: const Text('Ma météo du jour 🌤️'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          // image du fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/sky.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Container pour 2 icônes
          Positioned(
            top: 10.0,
            left: 0.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //icone geolocalisation
                  IconButton(
                    onPressed: () async {
                      final cityFromGeolocalisation =
                          await WeatherService().getCityName();
                      setState(() {
                        weatherdata = Future.value(cityFromGeolocalisation);
                      });
                    },
                    icon: const Icon(Icons.location_on,
                          size: 50, color: Color.fromARGB(255, 13, 37, 145)),
                   
                  ),
                  IconButton(
                   onPressed: () => GoRouter.of(context).go('/', extra: {'cityName': widget.cityName}),
                    icon: Icon(Icons.location_city,
                        size: 50, color: Colors.blue[100]),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 150.0,
            left: 60.0,
            child: FutureBuilder<WeatherData?>(
              future: weatherdata,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InputWidget(
                    snapshot.data?.city ?? '',
                    snapshot.data?.temperature ?? 0.0,
                    snapshot.data?.localtime ?? '',
                    snapshot.data?.text ?? '',
                  );
                } else if (snapshot.hasError) {
                  return const Text("Désolé, erreur");
                }
                // Spinner
                return const Center(
                  child: SpinKitRotatingCircle(
                    color: Colors.white,
                    size: 180.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 210,
        color: const Color.fromARGB(255, 13, 41, 125),
      ),
    );
  }
}
