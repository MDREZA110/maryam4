import 'package:flutter/material.dart';
import 'package:maryam/models/user.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? imagePath; // Optional image at the end
  final VoidCallback? onClick;
  final User? user;
  final DateTime? selectedDate;
  final bool? hideCursor;

  const CustomTextField(
      {super.key,
      this.hideCursor,
      this.user,
      this.onClick,
      required this.hintText,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.imagePath, // Pass image path if
      this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        readOnly: hideCursor ?? false,
        onTap: onClick,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle:
              const TextStyle(color: Colors.grey), // Light grey hint text
          filled: true,
          fillColor: Colors.grey[100], // Light grey background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide.none, // No border
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: imagePath != null // If image is provided, show it
              ? Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(
                    imagePath!,
                    width: 20,
                    height: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
