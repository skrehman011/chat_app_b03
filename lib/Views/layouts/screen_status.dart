import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenStatus extends StatelessWidget {
  const ScreenStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
            children: [
              ListTile(
                title: Text(
                  'Status',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.black),
                ),
                trailing: Icon(
                  Icons.more_vert_outlined,
                  size: 25,
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 23,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red, // Badge color
                        ),
                        child: Icon(Icons.add, size: 20,),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  'My Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Tap to add status update',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                child: Row(
                  children: [
                    Text('Recent update',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.grey),),

                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 23,
                ),
                title: Text(
                  'User name',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                subtitle: Text(
                  '33 mintes ago',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
        ),
          ),
          Positioned(
            right: 16,
              bottom: 10,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {

                      },
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(Icons.edit, color: Colors.black, size: 25, ),
                    ).paddingOnly(bottom: 15),
                  ),
                  FloatingActionButton(
                    onPressed: () {

                    },
                    backgroundColor: Color(0xFF075e55),
                    child: Icon(Icons.camera_alt, ),
                  ),

                ],
              ))
        ]
      ),


    );
  }
}
