import 'package:ev_charging_station_finder_1_0/contact_us_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';

class TermsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Terms & Conditions'
        ),
        centerTitle: true,
      ),
      // drawer: SideBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0,20.0,20.0,),
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/SaveEnergy.png'),
                width: 250, // Set the desired width
                height: 250, // Set the desired height
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 20,
              // ),
              Text(
                'Charging Pal',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Go Green!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),

              Text(
                'Welcome to Charging Pal. By using this app, you agree to these terms and conditions, which constitute a legally binding agreement between you and our company. If you do not agree to these terms, please do not use the app.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),

              SizedBox(
                height: 30.0,
              ),

              Text(
                  '1. License: Our company grants you a limited, non-exclusive, non-transferable, revocable license to use the app for personal, non-commercial purposes only.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                '2. User Conduct: You agree not to use the app for any illegal or unauthorized purpose, and you agree to comply with all laws and regulations in connection with your use of the app. You also agree not to harass, abuse, or harm other users of the app, or to interfere with their use of the app in any way.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '3. Privacy: We respect your privacy and will collect, use, and disclose your personal information in accordance with our Privacy Policy, which is available within the app.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '4. Intellectual Property: The app and its contents, including but not limited to text, graphics, images, logos, and software, are the property of our company or its licensors, and are protected by copyright, trademark, and other laws. You may not copy, reproduce, distribute, or create derivative works based on the app or its contents without our prior written permission.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '5. Disclaimer of Warranties: THE APP AND ITS CONTENTS ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '6. Limitation of Liability: OUR COMPANY SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF OR RELATED TO YOUR USE OF THE APP OR ITS CONTENTS, EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '7. Termination: We may terminate your use of the app at any time without notice, for any reason or no reason, in our sole discretion.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '8. Governing Law: These terms and conditions shall be governed by and construed in accordance with the laws of EGYPT, without giving effect to any principles of conflicts of law.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 30.0,
              ),

              Text(
                '9. Amendments: We may amend these terms and conditions at any time by posting the amended terms on the app. Your continued use of the app after such posting shall constitute your acceptance of the amended terms.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),

              SizedBox(
                height: 20.0,
              ),

              Text.rich(
                TextSpan(
                  text: 'If you have any questions about these terms and conditions, please ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: 'Contact us',
                      style: TextStyle(
                        //color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // add your navigation function here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactUsScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              Text(
                'Last updated: 7th of April 2023',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
