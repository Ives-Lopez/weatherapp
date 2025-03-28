import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

      navigationBar: CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("Location"),
            CupertinoTextField(
              placeholder: "Enter City",
              onChanged: (value) {
                // Implementation to change the location
              },
            ),
            SizedBox(height: 10),
            Text("Icon:"),
            Row(children: [
              CupertinoSwitch(value: true, onChanged: (value) {
                // Implementation for icon switch
              }),
              Text("Show Icon"),
            ]),
            SizedBox(height: 10),
            Text("Metric System"),
            Row(children: [
              CupertinoSwitch(value: true, onChanged: (value) {
                // Implementation for metric system switch
              }),
              Text("Use Celsius"),
            ]),
            SizedBox(height: 10),
            Text("Light Mode"),
            Row(children: [
              CupertinoSwitch(value: false, onChanged: (value) {
                // Implementation for light mode switch
              }),
              Text("Enable Light Mode"),
            ]),
            SizedBox(height: 10),
            Text("About"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("This is a simple weather app using OpenWeather API."),
            ),
          ],
        ),
      ),
    );
  }
}