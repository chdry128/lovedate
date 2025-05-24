
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

@override
_CompatibilityPageState createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
final TextEditingController _name1Controller = TextEditingController();
final TextEditingController _name2Controller = TextEditingController();
String _compatibilityResult = '';
String _nickname1 = '';
String _nickname2 = '';

Future<void> _checkCompatibility() async {
String name1 = _name1Controller.text;
String name2 = _name2Controller.text;

// Example API call to Groq AI for nickname suggestion
// Replace with your actual API endpoint and parameters
final response = await http.post(
Uri.parse('https://api.groq.ai/nickname'),
headers: {
'Content-Type': 'application/json',
},
body: jsonEncode({
'names': [name1, name2],
}),
);

if (response.statusCode == 200) {
var data = jsonDecode(response.body);
setState(() {
_nickname1 = data['nicknames'][0];
_nickname2 = data['nicknames'][1];
_compatibilityResult = 'Compatibility: 90%'; // Example result
});
} else {
setState(() {
_compatibilityResult = 'Error fetching data';
});
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Love Compatibility Checker'),
backgroundColor: Colors.pink,
),
body: Container(
padding: EdgeInsets.all(20.0),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Colors.pink, Colors.purple],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
TextField(
controller: _name1Controller,
decoration: InputDecoration(
hintText: 'Enter your name',
hintStyle: TextStyle(color: Colors.white),
border: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
),
style: TextStyle(color: Colors.white),
),
SizedBox(height: 20.0),
TextField(
controller: _name2Controller,
decoration: InputDecoration(
hintText: 'Enter your partner\'s name',
hintStyle: TextStyle(color: Colors.white),
border: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.white),
),
),
style: TextStyle(color: Colors.white),
),
SizedBox(height: 20.0),
ElevatedButton(
onPressed: _checkCompatibility,
style: ElevatedButton.styleFrom(
foregroundColor: Colors.white, backgroundColor: Colors.pinkAccent,
),
child: Text('Check Compatibility'),
),
SizedBox(height: 20.0),
Text(
_compatibilityResult,
style: TextStyle(
color: Colors.white,
fontSize: 18.0,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 10.0),
if (_nickname1.isNotEmpty && _nickname2.isNotEmpty)
Column(
children: [
Text(
'Your Nickname: $_nickname1',
style: TextStyle(
color: Colors.white,
fontSize: 16.0,
),
),
Text(
'Your Partner\'s Nickname: $_nickname2',
style: TextStyle(
color: Colors.white,
fontSize: 16.0,
),
),
],
),
],
),
),
);
}
}
