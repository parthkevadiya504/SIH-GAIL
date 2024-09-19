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
  int _currentTab = 0;

  List<Widget> screens = [
    home(),
    const leaves(),
    const attendance(),
    const profile(),
  ];
 Widget _currentScreen = home();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<IconData> listOfIcons = [
      Icons.home_rounded,
      Icons.calendar_month_rounded,
      Icons.dashboard_rounded,
      Icons.person_rounded,
    ];
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
                        const SizedBox(
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 10, 40),
        height: size.width * .250,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Center(
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * .024),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(
                      () {
                    _currentTab = index;
                    if(index == 0){
                      _currentScreen = home();
                    }
                    if( index == 1){
                      _currentScreen = leaves();
                    }
                    if( index == 2) {
                      _currentScreen = attendance();
                    }if( index == 3) {
                      _currentScreen = profile();
                    } },
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: EdgeInsets.only(
                      bottom: index == _currentTab ? 0 : size.width * .029,
                      right: size.width * .0422,
                      left: size.width * .0422,
                    ),
                    width: size.width * .128,
                    height: index == _currentTab ? size.width * .020 : 0,
                    decoration:  BoxDecoration(
                      color: primaryYellow,

                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                  ),
                  Icon(
                    listOfIcons[index],
                    size: size.width * .076,
                    color: index == _currentTab
                        ? primaryYellow
                        : mainBlack,
                  ),
                  SizedBox(height: size.width * .03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
