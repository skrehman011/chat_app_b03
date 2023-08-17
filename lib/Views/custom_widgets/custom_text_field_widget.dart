import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        children: [
          Icon(Icons.email, color: Colors.blueAccent,),
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',

            ),
          ),
        ],
      ),
    );
  }
}
