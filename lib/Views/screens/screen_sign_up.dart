import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mondaytest/controller/RegistrationController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenSignUp extends StatelessWidget {


  RegistrationController signUpController = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: (){Get.back();},
              child: Icon(Icons.arrow_back, color: Colors.blueAccent,)),
        ),
        backgroundColor: Color(0xFF022138),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 50.h,
              width: 80.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),

              ),
              child: Column(
                children: [
                  Text('Register Now ', style: TextStyle(
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),),


                  TextField(
                    controller: signUpController.nameController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle, color: Colors.blue, size: 16,),

                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                  TextField(
                    controller: signUpController.emailcontroller,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        icon: Icon(Icons.email, color: Colors.blue, size: 16,),

                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                  TextField(
                    controller: signUpController.ageController,
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                        icon: Icon(Icons.date_range, color: Colors.blue, size: 16,),

                        hintText: 'Age',
                        hintStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                  TextField(
                    controller: signUpController.passwordController,
                    style: TextStyle(color: Colors.blue),

                    decoration: InputDecoration(

                      icon: Icon(Icons.lock, color: Colors.blue, size: 16,),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    height: 7.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blueAccent),

                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        signUpController.SignUp();
                      },
                      child: Text('Submit'),

                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
