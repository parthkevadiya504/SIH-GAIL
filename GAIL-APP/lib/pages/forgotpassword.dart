
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff30B4FF),
        body: Stack(children: [
          Positioned(
            top: 50,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 350,
              width: 350,
              child: Image.asset('assets/images/login.png'),
            ),
          ),
          Positioned(
              top: 400,
              child: Container(
                height: 900,
                width: 430,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff101010),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Password",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff47A5E4),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      //-----------------OTP is Send to rahulkeshwala**@gmail.com-----------------------------

                      //--------------------------------------------Verify OTP-------------------------------------------------------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(

                              //controller: passwordController,
                              style: GoogleFonts.poppins(
                                color: Color(0xFF535353),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              // obscureText: _isPasswordShow,
                              decoration: InputDecoration(
                                // labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(
                                    color: Color(0xFF535353),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                                hintText: 'Create new Password',

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
                                fillColor: Color(0xfff4f4f5),

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

                          SizedBox(
                            height: 25,
                          ),

                          TextFormField(

                              //controller: passwordController,
                              style: GoogleFonts.poppins(
                                color: Color(0xFF535353),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              // obscureText: _isPasswordShow,
                              decoration: InputDecoration(
                                // labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(
                                    color: Color(0xFF535353),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                                hintText: ' Re-Enter Password',

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
                                fillColor: Color(0xfff4f4f5),

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

                          SizedBox(
                            height: 35,
                          ),

                          //-----------------------------------------Submit Button--------------------------------------
                          SizedBox(
                            // margin: EdgeInsets.fromLTRB(0,, 0, 5),
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>const LoginScreen(),
                                // if (formKey.currentState!.validate())
                                //  {
                                //  print("Validation done"),
                                //  login(emailController.text.toString(), passwordController.text.toString())
                                // },
                              ))},
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color(0xff47A5E4)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Color(0xff47A5E4))),
                                ),
                              ),
                              child: Text(
                                "Submit",
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
                    ],
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
