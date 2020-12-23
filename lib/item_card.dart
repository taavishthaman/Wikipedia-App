import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikipedia_app/web_view.dart';

class ItemCard extends StatelessWidget {
  String cardName;
  String cardUrl;
  ItemCard(this.cardName, this.cardUrl);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebPage(cardUrl, cardName)),
        );
      },
      child : Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 50,
          width: screenWidth,
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              border: Border.all(
                color: Colors.grey[900],
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12)
          ),
          child: Center(
            child:Text(cardName),
          ),
        ),
      )
    );
  }
}
