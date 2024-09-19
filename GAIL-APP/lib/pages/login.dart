// import 'dart:ffi';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gail/uI.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the generated ObjectBox file
import 'Mainhome.dart';
import 'home.dart';
import 'otpverification.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Icon eye = const Icon(
    CupertinoIcons.eye_slash,
    color: Colors.black,
  );
  bool _isPasswordShow = false;



// Helper function to show an alert dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List Role = [
    "Faculty",
    "Student",
  ];
  var selectedRole;


  @override
  Widget build(BuildContext context) {

   double cheight = MediaQuery.of(context).size.height;
   double top = 350;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff30B4FF),
        body: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset('assets/images/Login_Img.png'),
          ),
          Positioned(
              top: top,
              child: AnimatedContainer(
                duration: const Duration(microseconds: 300),

                height: cheight,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log",
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101010),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "in",
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: primaryRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            onTap:(){
                              setState(() {
                                cheight = 100;
                                print("hiii");

                              });
                            },
                            controller: usernameController,
                            enableSuggestions: true,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF535353),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              //letterSpacing: 1,
                            ),
                            // keyboardType: TextInputType.emailAddress,
                            // autofillHints: [AutofillHints.email],
                            decoration: const InputDecoration(
                              // labelText: 'Username / Email',
                              errorStyle:
                                  const TextStyle(color: Colors.redAccent),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.0,
                                  )),
                              hintText: 'Username / Email',
                              hintStyle: TextStyle(
                                  color: Color(0xff535353), fontSize: 14),
                              filled: true,
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Color(0xffD6F0FF),
                                    width: 1.0,
                                  )),
                              border: InputBorder.none,
                              fillColor: Color(0xfff4f4f5),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          //--------------------------------Password---------------------------------
                          TextFormField(
                              controller: passwordController,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF535353),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              obscureText: _isPasswordShow,
                              decoration: InputDecoration(
                                // labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF535353),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                                hintText: 'Password',

                                hintStyle: const TextStyle(
                                    color: Color(0xFF535353), fontSize: 14),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    )),

                                //  for Error

                                errorStyle:
                                    const TextStyle(color: Colors.redAccent),
                                filled: true,
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      color: Color(0xff47A5E4),
                                      width: 1.0,
                                    )),
                                border: InputBorder.none,
                                enabled: true,
                                fillColor: const Color(0xfff4f4f5),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordShow
                                            ? _isPasswordShow = false
                                            : _isPasswordShow = true;
                                        _isPasswordShow
                                            ? eye = const Icon(
                                                CupertinoIcons.eye,
                                                color: Colors.black)
                                            : eye = const Icon(
                                                CupertinoIcons.eye_slash,
                                                color: Colors.black,
                                              );
                                      });
                                    },
                                    icon: eye),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* Please Enter Password";
                                } //else if (passwordController.text.length < 6) {
                                return " Password Consist atlist 6 Character ";
                              } //else {}
                              // },
                              ),
                          const SizedBox(
                            height: 20,
                          ),

                          //-----------------------------------------Log IN Button--------------------------------------
                          SizedBox(
                            // margin: EdgeInsets.fromLTRB(0,, 0, 5),
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) =>  Home()),
                              )
                              },


                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    mainBlack),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                ),
                              ),
                              child: Text(
                                "Send OTP",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
