

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  Icon prefixIcon;
  TextEditingController controller;
 final textInputType;
  final FormFieldValidator<String> validator;

  MyTextField({
    super.key,
    required this.textInputType,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        validator:validator,
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            suffixIcon: InkWell(
                onTap: () {
                  controller.clear();
                },
                child: const Icon(Icons.cancel)),
            prefixIcon: prefixIcon,
            fillColor: Colors.grey[300],
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          )
        ),
      ),
    );
  }
}
