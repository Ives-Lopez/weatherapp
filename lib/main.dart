import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() => runApp(CupertinoApp(
  debugShowCheckedModeBanner: false,
  home: Homepage(),
));

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String location = "San Fernando";
  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";

  Map<String, dynamic> weatherData = {};
  bool isMetric = true; // true for Celsius, false for Fahrenheit
  bool isLightMode = true;

  Future<void> getWeatherData() async {
    try {
      String link =
          "https://api.openweathermap.org/data/2.5/weather?q=" +
              location +
              "&appid=155664d31803d4966b38bf9ea453e0bb";
      final response = await http.get(Uri.parse(link));
      weatherData = jsonDecode(response.body);

      try {
        setState(() {
          temp = isMetric
              ? (weatherData["main"]["temp"] - 273.15).toStringAsFixed(2) + "°C"
              : ((weatherData["main"]["temp"] - 273.15) * 9 / 5 + 32)
              .toStringAsFixed(2) +
              "°F";
          humidity = (weatherData["main"]["humidity"]).toString() + "%";
          windSpeed = weatherData["wind"]["speed"].toString() + " kph";
          weather = weatherData["weather"][0]["description"];

          if (weather!.contains("overcast")) {
            weatherStatus = CupertinoIcons.cloud_fill;
          } else if (weather!.contains("cloud")) {
            weatherStatus = CupertinoIcons.cloud;
          } else if (weather!.contains("broken")) {
            weatherStatus = CupertinoIcons.cloud;
          } else if (weather!.contains("light rain")) {
            weatherStatus = CupertinoIcons.cloud_drizzle;
          } else if (weather!.contains("sunny")) {
            weatherStatus = CupertinoIcons.sun_max;
          } else if (weather!.contains("heavy rain")) {
            weatherStatus = CupertinoIcons.cloud_heavyrain;
          }
        });
      } catch (e) {
        _showErrorDialog("City not found");
      }

      if (weatherData["cod"] != 200) {
        _showErrorDialog("Invalid City!!");
      }
    } catch (e) {
      _showErrorDialog("No Internet Connection");
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Message'),
            content: Text(message),
            actions: [
              CupertinoButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  void _openSettings() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SettingsPage(
        currentLocation: location,
        isMetric: isMetric,
        isLightMode: isLightMode,
        onLocationChanged: (String newLocation) {
          setState(() {
            location = newLocation;
          });
          getWeatherData();
        },
        onMetricChanged: (bool metric) {
          setState(() {
            isMetric = metric;
          });
          getWeatherData();
        },
        onThemeChanged: (bool lightMode) {
          setState(() {
            isLightMode = lightMode;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("iWeather"),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.settings, size: 30),
          onPressed: _openSettings,
        ),
      ),
      child: SafeArea(
        child: temp != ""
            ? Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text('My Location', style: TextStyle(fontSize: 35)),
              SizedBox(height: 5),
              Text('$location'),
              SizedBox(height: 10),
              Text(
                " $temp",
                style: TextStyle(fontSize: 80),
              ),
              Icon(weatherStatus,
                  color: CupertinoColors.systemOrange, size: 90),
              SizedBox(height: 10),
              Text('$weather'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H: $humidity'),
                  SizedBox(width: 10),
                  Text('W: $windSpeed')
                ],
              ),
            ],
          ),
        )
            : Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String currentLocation;
  final bool isMetric;
  final bool isLightMode;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<bool> onMetricChanged;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentLocation,
    required this.isMetric,
    required this.isLightMode,
    required this.onLocationChanged,
    required this.onMetricChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController locationController =
    TextEditingController(text: currentLocation);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(

        middle: Text("Settings"),
        trailing: CupertinoButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CupertinoTextField(
                placeholder: "Enter Location",
                controller: locationController,
              ),
            ),
            CupertinoButton(
              child: Text("Update Location"),
              onPressed: () {
                onLocationChanged(locationController.text);
                Navigator.pop(context);
              },
            ),
            CupertinoFormRow(
              prefix: Text("Metric System"),
              child: CupertinoSwitch(
                value: isMetric,
                onChanged: (value) {
                  onMetricChanged(value);
                },
              ),
            ),
            CupertinoFormRow(
              prefix: Text("Light Mode"),
              child: CupertinoSwitch(
                value: isLightMode,
                onChanged: (value) {
                  onThemeChanged(value);
                },
              ),
            ),
            CupertinoButton(
              child: Text("About"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("MEMBERS"),
                      content: Text("IVAN G. LOPEZ,  IVES G. LOPEZ"),


                      actions: [
                        CupertinoButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
