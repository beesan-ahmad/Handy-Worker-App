import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(imageName, fit: BoxFit.fitWidth, width: 350, height: 350);
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: const Color(0xFF626262),
    
    style: TextStyle(color: const Color(0xFF626262).withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF848484).withOpacity(0.7),
      ),
      labelText: text,
      labelStyle: TextStyle(color: const Color(0xFF848484).withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: const Color(0xFFB2B2B2).withOpacity(0.5),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,

        
        
  );
}
//   bool _obscureText = true;

// TextField reusableTextField(String text, IconData icon, bool isPasswordType,
//     TextEditingController controller) {
//   return TextField(
//     controller: controller,
//     obscureText: true,
//     enableSuggestions: !isPasswordType,
//     autocorrect: !isPasswordType,
//     cursorColor: Colors.white,
//     style: TextStyle(color: Color(0xFF626262).withOpacity(0.9)),
//     decoration: InputDecoration(
//       prefixIcon: Icon(
//         icon,
//         color: Color(0xFF848484).withOpacity(0.7),
//       ),
//       labelText: text,
//       labelStyle: TextStyle(color: Color(0xFF848484).withOpacity(0.9)),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Color(0xFFB2B2B2).withOpacity(0.5),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: const BorderSide(width: 0, style: BorderStyle.none),
//       ),
//       suffixIcon: isPasswordType
//           ? IconButton(
//               icon: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//               ),
//               onPressed: () {
//                 _obscureText = !_obscureText;
//               },
//             )
//           : null,
//     ),
//     keyboardType: isPasswordType
//         ? TextInputType.visiblePassword
//         : TextInputType.emailAddress,
//   );
// }

// TextField reusableTextField(String text, IconData icon, bool isPasswordType,
//     TextEditingController controller) {
//   bool _obscureText = isPasswordType;
//   return TextField(
//     controller: controller,
//     obscureText: _obscureText,
//     enableSuggestions: !isPasswordType,
//     autocorrect: !isPasswordType,
//     cursorColor: Colors.white,
//     style: TextStyle(color: Color(0xFF626262).withOpacity(0.9)),
//     decoration: InputDecoration(
//       prefixIcon: Icon(
//         icon,
//         color: Color(0xFF848484).withOpacity(0.7),
//       ),
//       labelText: text,
//       labelStyle: TextStyle(color: Color(0xFF848484).withOpacity(0.9)),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Color(0xFFB2B2B2).withOpacity(0.5),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: const BorderSide(width: 0, style: BorderStyle.none),
//       ),
//       suffixIcon: isPasswordType
//           ? IconButton(
//               icon: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscureText = !_obscureText;
//                 });
//               },
//             )
//           : null,
//     ),
//     keyboardType: isPasswordType
//         ? TextInputType.visiblePassword
//         : TextInputType.emailAddress,
//   );
// }



Container signinButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(110, 10, 110, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return const Color(0xFF00ABB3);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Container getstart(BuildContext context, String name, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(110, 10, 110, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return const Color(0xFF00ABB3);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

 
 
//  import 'package:flutter/material.dart';

// Image logoWidget(String imageName) {
//   return Image.asset(imageName, fit: BoxFit.fitWidth, width: 350, height: 350);
// }

// TextField reusableTextField(String text, IconData icon, bool isPasswordType, 
//   TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       obscureText: isPasswordType,
//       enableSuggestions: !isPasswordType,
//       autocorrect: !isPasswordType,
//       cursorColor: Color(0xFFB2B2B2),
//       style: TextStyle(color: Color(0xFFB2B2B2).withOpacity(0.5)),
//       decoration: InputDecoration(prefixIcon: Icon(icon, color: Color(0xFF848484)),
//       labelText: text,
//       labelStyle : TextStyle(color: Color(0xFF848484)),
//       filled: true,
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       fillColor: Color(0xFFB2B2B2).withOpacity(0.5),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0), 
//         borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
//       ),
//       keyboardType: isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,

//       );
  
//   }

 
 
 

 
    

 
    