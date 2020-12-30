import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'item_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var query = "Hello World";
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    searchController.text = query;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter a search term!"
                ),
                controller: searchController,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.search),
                color: Colors.grey,
                onPressed: (){
                  if(searchController.text == ""){
                    showAlertDialog(context);
                  }
                  else{
                    setState(() {
                      query = searchController.text;
                    });
                  }
                }
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchResponses(query),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData && snapshot.data["Keyword"] == query){
                return ListView.builder(
                  itemCount: snapshot.data["Titles"].length,
                  itemBuilder: (BuildContext context, int index){
                    return ItemCard(
                        snapshot.data["Titles"][index],
                        snapshot.data["PageIds"][index],
                        snapshot.data["Thumbnails"][index] == null ? null : snapshot.data["Thumbnails"][index],
                        snapshot.data["Descriptions"][index]
                    );
                  }
                );
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        )
      ],
    );
  }
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hold up!"),
      content: Text("Search query can't be empty."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

final baseApi = "https://en.wikipedia.org";

Future<Map<String, dynamic>> fetchResponses(String query) async {
  var result = await http.get(baseApi+"/w/api.php?action=query&format=json&prop=pageimages|pageterms&generator=prefixsearch&redirects=1&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch="+query+"&gpslimit=10");

  String fileName = query+".json";
  var dir = await getTemporaryDirectory();
  File file = new File(dir.path+"/"+fileName);
  //Uncomment this code in case you want to delete a file from cache.
  /*try {
    file.delete();
    print("Successfully deleted");
  }
  catch(e){
    print(e);
  }*/
  if(file.existsSync()){
    print("......................................Loading from Cache................................................");
    var jsonData = file.readAsStringSync();
    Map<String, dynamic> decodedMap  = jsonDecode(jsonData);
    List<dynamic> pageIds = new List<dynamic>();
    List<dynamic> thumbnails = new List<dynamic>();
    List<String> titles = new List<String>();
    List<String> descriptions = new List<String>();
    for(var key in decodedMap.keys){
      pageIds.add(key);
      decodedMap[key]["thumbnail"] == null ? thumbnails.add(null) : thumbnails.add(decodedMap[key]["thumbnail"]["source"]);
      descriptions.add(decodedMap[key]['terms']['description'][0]);
      titles.add(decodedMap[key]['title']);
    }

    print(pageIds);
    print(thumbnails);
    print(descriptions);
    print(titles);

    Map<String, dynamic> resultMap = {"Keyword" : query, "Titles" : titles, "PageIds" : pageIds, "Thumbnails" : thumbnails, "Descriptions" : descriptions};

    return resultMap;
  }
  else{
    print("......................................Loading from API................................................");
    Map<String, dynamic> map = jsonDecode(result.body);
    Map<String, dynamic> decodedMap = map['query']['pages'];
    file.writeAsStringSync(jsonEncode(decodedMap), flush: true, mode: FileMode.write);
    print("Here");
    List<dynamic> pageIds = new List<dynamic>();
    List<dynamic> thumbnails = new List<dynamic>();
    List<String> titles = new List<String>();
    List<String> descriptions = new List<String>();
    for(var key in decodedMap.keys){
      pageIds.add(key);
      decodedMap[key]["thumbnail"] == null ? thumbnails.add(null) : thumbnails.add(decodedMap[key]["thumbnail"]["source"]);
      descriptions.add(decodedMap[key]['terms']['description'][0]);
      titles.add(decodedMap[key]['title']);
    }
    print(pageIds);
    print(thumbnails);
    print(descriptions);
    print(titles);

    Map<String, dynamic> resultMap = {"Keyword" : query, "Titles" : titles, "PageIds" : pageIds, "Thumbnails" : thumbnails, "Descriptions" : descriptions};

    return resultMap;
  }
}
