import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_weather.dart';
import 'package:weather_app/hourly_weather.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({super.key});

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = "Delhi";

      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openweatherapikey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An expected error occured';
      }

      //wrap it to the setstate so build function notices after every referesh,setstate rebuild the state function

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 113, 60, 118),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 40, 2, 48),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //adaptive helps to getalong with native property of operating system
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;

          final currenttemp = data['list'][0]['main']['temp'];
          final currentweather = data['list'][0]['weather'][0]['main'];
          final currentsky = data['list'][0]['weather'][0]['main'];
          final presuure = data['list'][0]['main']['pressure'];
          final humidity = data['list'][0]['main']['humidity'];
          final speed = data['list'][0]['wind']['speed'];
          //print(currentweather);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currenttemp K',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                currentsky == "Rain" || currentsky == "Clouds"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 60,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '$currentweather',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 80, 144, 176)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 10; i++)
                //       //we have to lazy loading the widget created on demand
                //         HourlyWeather(
                //           time: data['list'][i + 1]['dt_txt']
                //               .toString()
                //               .substring(11, 16),
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       "Rain" ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       "Clouds"
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temp: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: ((context, index) {
                        return HourlyWeather(
                          time: data['list'][index + 1]['dt_txt']
                              .toString()
                              .substring(11, 16),
                          icon: data['list'][index + 1]['weather'][0]['main'] ==
                                      "Rain" ||
                                  data['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      "Clouds"
                              ? Icons.cloud
                              : Icons.sunny,
                          temp: data['list'][index + 1]['main']['temp']
                              .toString(),
                        );
                      })),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Additionalweather(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      label1: humidity.toString(),
                    ),
                    Additionalweather(
                      icon: Icons.air,
                      label: 'Speed',
                      label1: speed.toString(),
                    ),
                    Additionalweather(
                      icon: Icons.umbrella,
                      label: 'Pressure',
                      label1: presuure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
