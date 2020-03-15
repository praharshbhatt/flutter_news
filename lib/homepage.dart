import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternews/main.dart';
import 'package:flutternews/services/news.dart';
import 'package:flutternews/settings.dart';
import 'package:flutternews/view_article.dart';
import 'package:flutternews/widgets/dialogboxes.dart';
import 'package:path_provider/path_provider.dart';

import 'models/article.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Keys
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Today's Top Headlines",
          style: myAppTheme.textTheme.caption.copyWith(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () async {
              showSnackBar(scaffoldKey: scaffoldKey, text: "Refreshing...");

              //Reload
              await getNews();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Flutter News App", style: myAppTheme.textTheme.caption),
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, size: 25),
              title: Text("Settings", style: myAppTheme.textTheme.bodyText1),
              trailing: Icon(Icons.arrow_right, size: 25),
              onTap: () {
                //Close the drawer.
                Navigator.pop(context);

                //Open Settings
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //When Loading
          if (snapshot == null || snapshot.hasData == false) {
            return Center(
              child: Column(
                children: <Widget>[
                  //Flare Animation
                  Container(
                    width: size * 0.8,
                    height: size * 0.8,
                    child: FlareActor(
                      "assets/animations/NewsMedia.flr",
                      alignment: Alignment.center,
                    ),
                  ),
                  Text(
                    "Please wait, Loading...",
                    style: myAppTheme.textTheme.caption,
                  )
                ],
              ),
            );

            //No Results
          } else if (snapshot.data.length == 0 || snapshot.data == null) {
            return Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/animations/no_connection.gif",
                    fit: BoxFit.fitWidth,
                  ),
                  Text(
                    "No news found...\nAre you sure you're connected?",
                    style: myAppTheme.textTheme.caption,
                  )
                ],
              ),
            );

            //Results
          } else {
            return getNewsListView(snapshot.data);
          }
        },
        future: getNews(),
      ),
    );
  }

  //Returns the ListView containing the News
  ListView getNewsListView(List<Article> news) {
    showNewsFetchDateTime();

    return ListView.builder(
        itemCount: news.length,
        itemBuilder: (BuildContext context, int index) {
          if (news[index] == null) return Container();

          return ListTile(
            leading: Hero(
              tag: news[index].mediaUrl != null && news[index].mediaUrl != "" ? news[index].mediaUrl : news[index].link,
              child: Image.network(
                news[index].mediaUrl != null && news[index].mediaUrl != ""
                    ? news[index].mediaUrl
                    : "https://cdn0.iconfinder.com/data/icons/simplicity/512/news_article_blog-512.png",
                height: 240,
                width: 80,
              ),
            ),

            //Title
            title: Hero(
              tag: news[index].title,
              child: Text(
                news[index].title,
                style: myAppTheme.textTheme.caption,
              ),
            ),

            onTap: () {
              //Open This News
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewArticle(news[index])),
              );
            },
          );
        });
  }

  Future<void> showNewsFetchDateTime() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/news.xml');

    showSnackBar(scaffoldKey: scaffoldKey, text: "Last fetched: " + file.lastModifiedSync().toString());
  }
}
