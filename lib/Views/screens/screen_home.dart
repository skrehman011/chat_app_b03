import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mondaytest/Views/layouts/layout_calls.dart';
import 'package:mondaytest/Views/layouts/layout_community.dart';
import 'package:mondaytest/Views/screens/screen_log_in.dart';
import 'package:mondaytest/Views/layouts/screen_status.dart';
import 'package:mondaytest/homepagestf.dart';


class ScreenHome extends StatelessWidget {


  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
    child: Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              // toolbarHeight: 100,
              backgroundColor: Color(0xFF075e55),
              floating: true,
              pinned: true,
              title: Text('Whatsapp'),
              actions: [
                Container(
                  width: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      Icon(Icons.search),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'logout') {
                            FirebaseAuth.instance.signOut().then((value) => Get.offAll(ScreenLogIn()));
                          }
                          if (value == 'New group') {
                             Get.offAll(ScreenLogIn());
                          }
                          // You can add more items and their corresponding actions here
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            'Logout',
                            'New group',
                            'Setting',
                            'Advertise',
                            'Linked Device',
                          ].map((String option) {
                            return PopupMenuItem<String>(
                              value: option.toLowerCase(),
                              child: Text(option),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),

              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: TabBar(
                  indicatorColor: Colors.white,
                    indicatorWeight: 3,

                    tabs: [
                      Tab( icon: Icon(Icons.groups),),
                      Tab( text: 'Chat',),
                      Tab(  text: 'Status',),
                      Tab( text: 'Calls',),
                    ]),
              ),
            )
          ],
          body: TabBarView(
              children: [
                LayoutCommunity(),
                HomePage(),
                ScreenStatus(),
                LayoutCalls(),
              ])
      ),
    ),
  );
}
