import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  final String? Function(String?)? validator; // Validator function
  final ValueChanged<String>? onChanged;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
    this.onChanged,
    this.validator,
  });

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _toggleShow = true; // State variable for password visibility

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        style: const TextStyle(fontSize: 20),
        controller: widget.textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.black54),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          suffixIcon: widget.isPass
              ? IconButton(
                  icon: Icon(
                    _toggleShow ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _toggleShow = !_toggleShow; // Toggle password visibility
                    });
                  },
                )
              : null,
        ),
        keyboardType: widget.textInputType,
        obscureText: widget.isPass ? _toggleShow : false, // Use the toggle state
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}