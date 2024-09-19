import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../uI.dart';
import 'Attendance.dart';
import 'Leaves.dart';
import 'Profile.dart';
import 'home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _isSelected = 0;
  List<Widget> body = [
    Icon(
      Icons.home,
      color: mainBlack,
    ),
    Icon(Icons.calendar_month, color: mainBlack),
    Icon(Icons.report, color: mainBlack),
    Icon(Icons.person_2_rounded, color: mainBlack),
  ];
  List<Widget> screens = [
    home(),
    const leaves(),
    const attendance(),
    const profile(),
  ];
  Widget _currentScreen = home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.center, children: [
        _currentScreen,
        Positioned(
            top: 60,
            //top heading
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
              height: 160,
              width: 370,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff1B1B1B).withOpacity(0.25),
                      offset: const Offset(
                        0.0,
                        4.0,
                      ),
                      blurRadius: 24.0,
                      spreadRadius: 2.0,
                    ),
                  ]),
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Heading
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last Check in-Out",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: lightFontColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Today".toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .5,
                            color: mainBlack,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "11:30 AM",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: primaryRed,
                      ),
                    ),
                    Text(
                      "6.5 Hours, in Side",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: green,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "1.5 Hours",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: mainBlack,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          ", Out Side from Site",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .5,
                            color: lightFontColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: 35,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primaryRed),
                    child: Center(
                      child: Text(
                        "OUT",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ]),
            ))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
            _currentScreen = screens[newIndex];
            _isSelected = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded,
                color: _isSelected == 0 ? primaryYellow : mainBlack, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded,
                color: _isSelected == 1 ? primaryYellow : mainBlack, size: 30),
            label: "Leave",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_rounded,
                color: _isSelected == 2 ? primaryYellow : mainBlack, size: 30),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _isSelected == 3 ? primaryYellow : mainBlack,
              size: 30,
            ),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
