import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

var usersRef = FirebaseFirestore.instance.collection("users");
var chatsRef = FirebaseDatabase.instance.ref().child('chats');
User? get currentUser => FirebaseAuth.instance.currentUser;


Future<String> buildDynamicLinks(String title, String des, String image, String groupId, bool isShort) async {
  String url = 'https://mychatapp1.page.link';
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: url,
    link: Uri.parse('$url/$groupId'),
    androidParameters: AndroidParameters(
      packageName: 'com.example.mondaytest',
      minimumVersion: 0,
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      description: des,
      imageUrl: Uri.parse("$image"),
      title: title,
    ),
  );
  log("Group Link: $groupId");

  if (isShort) {
    final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    log("Short Link: ${dynamicUrl.shortUrl}");
    return dynamicUrl.shortUrl.toString();
  }
  final longDynamicUrl = await FirebaseDynamicLinks.instance.buildLink(parameters);
  // String? desc = '${dynamicUrl.shortUrl.toString()}';

  return longDynamicUrl.toString();
}