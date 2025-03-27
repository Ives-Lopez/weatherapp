
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main()=>runApp(CupertinoApp(
  debugShowCheckedModeBanner: false,
  home: Homepage(),));

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();

}

class _HomepageState extends State<Homepage> {
  @override
  String location = "San Fernando";
  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";

  Map<String, dynamic> weatherData = {};

  Future<void> getWeatherData() async {

   try {
     String link ="https://api.openweathermap.org/data/2.5/weather?q="+ location +"&appid=155664d31803d4966b38bf9ea453e0bb";
     final response = await http.get(
         Uri.parse(link)
     );
     weatherData = jsonDecode(response.body);
    try {
      setState(() {
        temp = (weatherData["main"]["temp"] -273.15).toStringAsFixed(2) + "°";
        humidity = (weatherData["main"]["humidity"]).toString() + "%";
        windSpeed = weatherData["wind"]["speed"].toString() + " kph";
        weather= weatherData["weather"][0]["description"];

        if (weather!.contains("overcast")) {
          weatherStatus = CupertinoIcons.cloud_fill;
        }else if (weather!.contains("cloud")) {
          weatherStatus = CupertinoIcons.cloud;
        }else if (weather!.contains("broken")) {
          weatherStatus = CupertinoIcons.cloud;
        }

      });
    } catch (e) {
      showCupertinoDialog(context: context, builder: (context){
        return CupertinoAlertDialog(
          title: Text('Message'),
          content: Text("City not found"),
          actions: [
            CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: () {
              Navigator.pop(context);
            })
          ],
        );
      });
    }

     print(weatherData["cod"]);

     if(weatherData["cod"] == 200){
       print(weatherData["weather"][0]["description"]);

     } else {
       print("Invalid City!!");
     }
   } catch (e) {
     showCupertinoDialog(context: context, builder: (context){
       return CupertinoAlertDialog(
         title: Text('Message'),
         content: Text("No Internet Connection"),
         actions: [
           CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: () {
             Navigator.pop(context);
           }),
           CupertinoButton(child: Text('Retry', style: TextStyle(color: CupertinoColors.systemGreen),), onPressed: () {
             Navigator.pop(context);
             getWeatherData();
           })
         ],
       );
     });
   }

  }
  @override
  void initState() {
    getWeatherData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("iWeather"),
          trailing: CupertinoButton(child: Icon(CupertinoIcons.settings), onPressed: (){}),
        ),
        child: SafeArea(child: temp != "" ? Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('My Location', style: TextStyle(fontSize: 35),),
              SizedBox(height: 5,),
              Text('$location'),
              SizedBox(height: 10,),
              Text(" $temp", style: TextStyle(fontSize: 80),),

              Icon(weatherStatus, color: CupertinoColors.systemOrange, size: 90,),
              SizedBox(height: 10,),
              Text('$weather'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H: $humidity'),
                  SizedBox(width: 10,),
                  Text('W: $windSpeed')
                ],
              )
            ],
          ),
        ) : Center(child: CupertinoActivityIndicator(),)));
  }
}