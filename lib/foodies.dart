import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

var bannerItems = ["Burger", "Cheese Chilly", "Noodles", "Pizza"];
var bannerImages = [
  "images/burger.jpg",
  "images/cheesechilly.jpg",
  "images/noodles.jpg",
  "images/pizza.jpg"
];

class MyHomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Future<List<Widget>> createList() async{
      List<Widget> items = [];
      String dataString = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      List<dynamic> dataJSON = jsonDecode(dataString);


      for (var object in dataJSON) {

      String finalString = "";
      List <dynamic> dataList = object["placeItems"];
      for (var item in dataList) {
        finalString = finalString + item + " | ";
      }
        
        items.add(Padding(
          padding: EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2.0,
                  blurRadius: 5.0,
                )
              ]
            ),
            margin: EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                  child: Image.asset(object["placeImage"], width: 80, height: 80, fit: BoxFit.cover,),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(object["placeName"]),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(finalString, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.black54), maxLines: 1,),
                        ),
                        Text("Min. Order: ${object["minOrder"]}", style: TextStyle(fontSize: 12.0, color: Colors.black54), maxLines: 1,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        );
      }
      return items;
    }

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
                      Text('Foodies', style: TextStyle(fontSize: 50, fontFamily: "Samantha"),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.person)),
                    ],
                  ),
                ),
                BannerArea(),
                Container(
                  child: FutureBuilder(
                    initialData: <Widget>[Text(" ")],
                    future: createList(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: snapshot.data!,
                          ),
                        );
                      }
                      else {
                        return CircularProgressIndicator();
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.black,
        onPressed: (){},
        child: Icon(Icons.fastfood_rounded, color: Colors.white,),  
      ),
    );
  }
}


class BannerArea extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller = PageController(viewportFraction: 0.8, initialPage: 1);

    List<Widget> banners = <Widget>[];
    
    for(int i = 0; i < bannerItems.length; i++){
      var bannerView = Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(bannerImages[i],
                fit: BoxFit.cover,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                    ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bannerItems[i], style: TextStyle(fontSize: 25.0, color: Colors.white),),
                    Text("for free if you can run", style: TextStyle(fontSize: 14.0, color: Colors.white),),
                  ],
                ),
              ),
            ],
          ), 
        ),
      );

      banners.add(bannerView);
    }

    return SizedBox(
      width: screenWidth,
      height: screenWidth*9/16,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,
      ),
    );
  }
}