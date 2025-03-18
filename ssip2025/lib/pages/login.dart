import 'dart:ffi';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sim_data/sim_data.dart';
import 'package:flutter_sim_data/sim_data_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

// Import the generated ObjectBox file
import '../uI.dart';
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
  TextEditingController phoneController = TextEditingController();
  String? simPhoneNumber;
  bool isLoading = false;
  final _simData = SimData();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Separated permission handling
  Future<void> _requestPermissions() async {
    setState(() => isLoading = true);

    // First request notification permission
    bool notificationsAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!notificationsAllowed) {
      // Request notification permissions and wait for result
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Then handle SMS and phone permissions separately
    if (await Permission.phone.request().isGranted) {
      await fetchSimPhoneNumber();
    } else {
      print("SMS or phone permission denied");
    }

    setState(() => isLoading = false);
  }

  Future<void> fetchSimPhoneNumber() async {
    try {
      List<SimDataModel> simData = await _simData.getSimData();
      if (simData.isNotEmpty && simData.first.phoneNumber.isNotEmpty) {
        setState(() {
          simPhoneNumber = simData.first.phoneNumber;
          print(simPhoneNumber);
        });
      } else {
        print("No phone number found in SIM");
      }
    } catch (e) {
      print("Error fetching SIM data: $e");
    }
  }

  Future<void> sendOTP() async {
    try {
      final List<SimDataModel> simData = await _simData.getSimData();
      print("simPhone no in sendotp: $simPhoneNumber");

      if (simData.isNotEmpty) {
        print("hi");
        await _simData.sendSMS(
          phoneNumber: simPhoneNumber!,
          message: "Your OTP is 123456",
          subId: simData.first.subscriptionId,
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("OTP Sent"),
            content: Text("An OTP has been sent to $simPhoneNumber."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text("OK"),
              ),
            ],
          ),
        );

        print("OTP sent successfully!");
      }
    } catch (e) {
      print("in catch");
      print("Error sending OTP: $e");
    }
  }

  void showMismatchDialog(String enteredPhone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Phone Number Mismatch"),
        content: Text(
            "The entered phone number ($enteredPhone) does not match the SIM number ($simPhoneNumber). Please enter the correct number."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void login() {
    String enteredPhone = "91${phoneController.text.trim()}";
    print("entered no $enteredPhone");

    if (enteredPhone.isNotEmpty) {
      if (enteredPhone == simPhoneNumber) {
        print("Logging in with: $enteredPhone");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));

        // Proceed with login or OTP verification
      } else {
        print("Phone number mismatch: $enteredPhone");
        showMismatchDialog(enteredPhone);
      }
    } else {
      print("Enter a valid phone number");
    }
  }

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
                            onTap: () {
                              setState(() {
                                cheight = 100;
                                print("hiii");
                              });
                            },
                            controller: phoneController,
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
                              hintText: 'Phone No',
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
                          // TextFormField(
                          //     controller: passwordController,
                          //     style: GoogleFonts.poppins(
                          //       color: const Color(0xFF535353),
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: 14,
                          //     ),
                          //     obscureText: _isPasswordShow,
                          //     decoration: InputDecoration(
                          //       // labelText: 'Password',
                          //       labelStyle: GoogleFonts.poppins(
                          //           color: const Color(0xFF535353),
                          //           fontWeight: FontWeight.w600,
                          //           fontSize: 14),
                          //       hintText: 'Password',
                          //
                          //       hintStyle: const TextStyle(
                          //           color: Color(0xFF535353), fontSize: 14),
                          //       errorBorder: const OutlineInputBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(10)),
                          //           borderSide: BorderSide(
                          //             color: Colors.red,
                          //             width: 1.0,
                          //           )),
                          //
                          //       //  for Error
                          //
                          //       errorStyle:
                          //           const TextStyle(color: Colors.redAccent),
                          //       filled: true,
                          //       focusedBorder: const OutlineInputBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(10)),
                          //           borderSide: BorderSide(
                          //             color: Color(0xff47A5E4),
                          //             width: 1.0,
                          //           )),
                          //       border: InputBorder.none,
                          //       enabled: true,
                          //       fillColor: const Color(0xfff4f4f5),
                          //       suffixIcon: IconButton(
                          //           onPressed: () {
                          //             setState(() {
                          //               _isPasswordShow
                          //                   ? _isPasswordShow = false
                          //                   : _isPasswordShow = true;
                          //               _isPasswordShow
                          //                   ? eye = const Icon(
                          //                       CupertinoIcons.eye,
                          //                       color: Colors.black)
                          //                   : eye = const Icon(
                          //                       CupertinoIcons.eye_slash,
                          //                       color: Colors.black,
                          //                     );
                          //             });
                          //           },
                          //           icon: eye),
                          //       enabledBorder: const OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(10)),
                          //       ),
                          //     ),
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return "* Please Enter Password";
                          //       } //else if (passwordController.text.length < 6) {
                          //       return " Password Consist atlist 6 Character ";
                          //     } //else {}
                          //     // },
                          //     ),
                          // const SizedBox(
                          //   height: 20,
                          // ),

                          //-----------------------------------------Log IN Button--------------------------------------
                          SizedBox(
                            // margin: EdgeInsets.fromLTRB(0,, 0, 5),
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () => {
                                login(),
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(mainBlack),
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
