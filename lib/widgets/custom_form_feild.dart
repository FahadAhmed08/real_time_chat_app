import 'package:flutter/material.dart';

class CustomFormFeild extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obsecureText;
  final void Function(String?) onSaved;
  const CustomFormFeild({
    super.key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    this.obsecureText = false,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obsecureText,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
            hintText: hintText, border: const OutlineInputBorder()),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomFormFeild extends StatelessWidget {
//   final double height;
//   final String hintText;
//   final RegExp validationRegEx;

//   const CustomFormFeild({
//     super.key,
//     required this.height,
//     required this.hintText,
//     required this.validationRegEx,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       child: TextFormField(
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Field cannot be empty';
//           }
//           if (!validationRegEx.hasMatch(value)) {
//             return 'Enter a valid $hintText';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
