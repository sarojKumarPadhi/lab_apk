import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'New_Patient.dart';

class AddressAutofill extends StatefulWidget {
  const AddressAutofill({Key? key}) : super(key: key);

  @override
  State<AddressAutofill> createState() => _AddressAutofillState();
}


class _AddressAutofillState extends State<AddressAutofill> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String _sessoinToken = '999334';
  List<dynamic>_placesList=[];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() async {
    if (_sessoinToken == null) {
      setState(() {
        _sessoinToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String PLACES_API_KEY="AIzaSyBaZWnJ0KrnuL_ile3HbJwrtD_zspXj0Lw";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request='$baseURL?input=$input&key=$PLACES_API_KEY&_sessoinToken=$_sessoinToken';
    var response=await http.get(Uri.parse(request));
    if(response.statusCode==200){
        setState(() {
          _placesList=jsonDecode(response.body.toString())['predictions'];
        });
    }
    else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("𝐩𝐚𝐭𝐢𝐞𝐧𝐭 𝐥𝐨𝐜𝐚𝐭𝐢𝐨𝐧"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.location_on_sharp),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "search here",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
            ),
            Expanded(child: ListView.builder(
              itemCount: _placesList.length,
              itemBuilder:(context, index) {
                return ListTile(
                  onTap: () async{
                    NewPatient.location=_placesList[index]["description"];
                    List<Location>location=await locationFromAddress(_placesList[index]["description"]);
                    // Fluttertoast.showToast(msg: location.last.latitude.toString());
                    // Fluttertoast.showToast(msg: location.last.longitude.toString());
                    Navigator.pop(context);
                  },
                      title: Text(_placesList[index]["description"]),
                );

            }, ))
          ],
        ),
      ),
    );
  }
}
