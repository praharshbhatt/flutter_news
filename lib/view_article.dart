import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternews/main.dart';

import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/article.dart';

class ViewArticle extends StatefulWidget {
  Article article;

  ViewArticle(this.article);

  @override
  _ViewArticleState createState() => _ViewArticleState(article);
}

class _ViewArticleState extends State<ViewArticle> {
  Article article;

  _ViewArticleState(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            article.title,
            style: myAppTheme.textTheme.caption.copyWith(color: Colors.white),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            //Image
            Hero(
              tag: article.mediaUrl != null && article.mediaUrl != "" ? article.mediaUrl : article.link,
              child: Image.network(
                article.mediaUrl != null && article.mediaUrl != ""
                    ? article.mediaUrl
                    : "https://cdn0.iconfinder.com/data/icons/simplicity/512/news_article_blog-512.png",
                fit: BoxFit.fitWidth,
              ),
            ),

            //Title
            Hero(
              tag: article.title,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  article.title,
                  style: myAppTheme.textTheme.headline1,
                ),
              ),
            ),

            //Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //Date
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    article.pubDate,
                    style: myAppTheme.textTheme.bodyText1.copyWith(color: Colors.grey),
                  ),
                ),

                //Open Article
                IconButton(
                  icon: Icon(
                    Icons.open_in_new,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    //Open
                    _launchURL(article.link);
                  },
                ),

                //Share
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    //Share
                    Share.share(article.link);
                  },
                )
              ],
            ),

            //Description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.description,
                style: myAppTheme.textTheme.bodyText1.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
