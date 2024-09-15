// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'forgotpassword.dart';

class otpverification extends StatefulWidget {
  const otpverification({super.key});

  @override
  State<otpverification> createState() => _otpverification();
}

class _otpverification extends State<otpverification>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
  }

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
                            "Verify",
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
                            "OTP",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "OTP is send to",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff535353),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "rahulkeshwala@gmail.com",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff16376E),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //--------------------------------------------Verify OTP-------------------------------------------------------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OTPTextField(
                            outlineBorderRadius: 6,
                            length: 4,
                            width: MediaQuery.of(context).size.width - 60,
                            fieldWidth: 50,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Color(0xffF4F4F5),
                              focusBorderColor: Color(0xff47A5E4),
                            ),
                            keyboardType: TextInputType.number,
                            onCompleted: (pin) {
                              // Handle completed OTP input
                              // otpList will contain the entered OTP
                            },
                            onChanged: (pin) {
                              setState(() {
                                //  otpList = pin.split('');
                                // otpbox.text = pin;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      //-----------------------------------------Verify Button--------------------------------------
                      SizedBox(
                        // margin: EdgeInsets.fromLTRB(0,, 0, 5),
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => forgotpassword())),
                            // if (formKey.currentState!.validate())
                            //  {
                            //  print("Validation done"),
                            //  login(emailController.text.toString(), passwordController.text.toString())
                            // },
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Color(0xff47A5E4)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      color: Color(0xff47A5E4))),
                            ),
                          ),
                          child: Text(
                            "Verify OTP",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      //-----------------------------Did' Get OTP? Resend--------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Didn't Get OTP?",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff535353),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Resend",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff16376E),
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
