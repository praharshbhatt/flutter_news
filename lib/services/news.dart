import 'dart:io';

import 'package:flutternews/models/article.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

//Fetches and returns the news
Future<List<Article>> getNews() async {
  if (await fetchNews() == false) {
    //Could not fetch the news from the internet.
    //Has to be a connection issue
    return null;
  } else {
    List lstNews = await readNews();
    return lstNews;
  }
}

//Fetches the XML file from the endpoint and saves it
Future<bool> fetchNews() async {
  final response = await http.get("https://news.yahoo.com/rss/");
  if (response.statusCode == 200) {
    write(response.body);
    return true;
  } else {
    return false;
  }
}

Future<bool> write(String text) async {
  bool blRet = true;

  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/news.xml');
  await file.writeAsString(text);

  return blRet;
}

//Reads the XML file from the Storage
Future<List<Article>> readNews() async {
  //Get the saved XML file from the storage
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/news.xml');

  //Parse the XML
  String strNews = await file.readAsString();
  xml.XmlDocument xmlDoc = xml.parse(strNews);

  return xmlDoc.findAllElements("item").map((e) {
//    print(
//      e.findElements("title").first.text,
//    );
    try {
      Article article = Article(
        e.findElements("title").first.text,
        strGetDescriptionFromHTML(e.findElements("description").first.text),
        e.findElements("link").first.text,
        e.findElements("pubDate").first.text,
      );
      String strMedia = e.findElements("media:content").toString();
      if (strGetURLFromMedia(strMedia) != "") article.mediaUrl = strGetURLFromMedia(strMedia);

      return article;
    } catch (e) {
      return null;
    }
  }).toList();
}

String strGetURLFromMedia(String strMedia) {
  if (strMedia == null || strMedia == "") return "";

  try {
    return strMedia.substring(strMedia.lastIndexOf("url=") + 5, strMedia.lastIndexOf(".jpg") + 4);
  } catch (e) {
    return "";
  }
}

String strGetDescriptionFromHTML(String strDescription) {
  if (strDescription == null || strDescription == "") return "";

  try {
    return strDescription.substring(
        strDescription.lastIndexOf("alt=") + 5, strDescription.lastIndexOf('" border="0"'));
  } catch (e) {
    return "";
  }
}
