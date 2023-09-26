import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutCalls extends StatelessWidget {
  const LayoutCalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(left: 10, right: 5, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF075e55),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.link, size: 35, color: Colors.white,),
              ),
              title: Text('Create Call Link', style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),),
              subtitle: Text('Share a link for your whatsapp call', style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),),
            ),
            Text('Recent',style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),).paddingOnly(left: 10, top: 10, bottom: 10),
            ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF075e55),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(),
              ),
              title: Text('Create Call Link', style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),),
              subtitle: Row(
                children: [
                  Icon(Icons.call_made),
                  Text('Yesterday, 1:49 pm', style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),),
                ],
              ),
              trailing:Icon(Icons.call) ,
            ),
            ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF075e55),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(),
              ),
              title: Text('Create Call Link', style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),),
              subtitle: Row(
                children: [
                  Icon(Icons.call_made),
                  Text('Yesterday, 1:49 pm', style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),),
                ],
              ),
              trailing:Icon(Icons.missed_video_call_sharp) ,
            ),
          ],
        ),
      )
    );
  }
}
