import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikipedia_app/main_view.dart';
import 'package:http/http.dart' as http;
import 'package:wikipedia_app/web_view.dart';

class ItemCard extends StatelessWidget {
  String cardName;
  String pageId;
  String thumbnail;
  String description;
  ItemCard(this.cardName, this.pageId, this.thumbnail, this.description);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async{
        var loading = true;
        if(loading){
          showAlertDialog(context);
        }
        var result = await http.get(baseApi+"/w/api.php?action=query&prop=info&pageids="+pageId+"&inprop=url&format=json");
        loading = false;
        if(!loading){
          Navigator.of(context).pop();
          var body = jsonDecode(result.body);
          var url = body["query"]["pages"][pageId]["fullurl"];
          var title = body["query"]["pages"][pageId]["title"];
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebPage(url, title))
          );
        }
      },
      child : Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 60,
          width: screenWidth,
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              border: Border.all(
                color: Colors.grey[900],
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: thumbnail == null ? Icon(Icons.image, size: 40,) :Image.network(thumbnail),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(cardName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Flexible(
                      child: Text(description),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           Center(
             child: CircularProgressIndicator(),
           )
         ],
       ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
