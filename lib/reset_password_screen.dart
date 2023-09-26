import 'package:ev_charging_station_finder_1_0/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // const ResetPasswordScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();

  // var passwordController = TextEditingController();
  //
  // bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Reset Password'
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onFieldSubmitted: (value)
              {
                print(value);
              },
              decoration: InputDecoration(
                  labelText: 'E-Mail Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  )
              ),
            ),
            SizedBox(
              height: 20.0,
            ),

            // TextFormField(
            //   controller: passwordController,
            //   keyboardType: TextInputType.visiblePassword,
            //   obscureText: _obscureText,
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(
            //       Icons.lock,
            //     ),
            //     suffixIcon: IconButton(
            //       icon: _obscureText
            //           ? Icon(Icons.visibility_off)
            //           : Icon(Icons.visibility),
            //       onPressed: () {
            //         setState(() {
            //           _obscureText = !_obscureText;
            //         });
            //       },
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 20.0,
            ),
            Container(
              color: Colors.blue,
              width: double.infinity,
              child: MaterialButton(
                onPressed: ()
                {
                  print(emailController.text);
                  //print(passwordController.text);
                  resetPassword();
                  print('Password Reset');
                },
                child: Container(
                  child: Text(
                    'GET LINK',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );

  }
  
  Future resetPassword() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text('Password Reset Link sent!'),
              actions: [
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            );
          }
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      // );
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }
  }
}
