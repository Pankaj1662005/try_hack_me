import 'package:flutter/material.dart';
import 'package:hack_app/accessdata/alldataisasscess.dart';
import 'package:hack_app/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> folderColors = [
    kLightBlueColor,
    kLightYellowColor,
    kLightRedColor,
    kLightGreenColor,
    kLightBlueColor,
    kLightYellowColor,
    kLightRedColor,
    kLightGreenColor,
    kLightBlueColor,
    kLightYellowColor,
    kLightRedColor,
    kLightGreenColor,
    kLightBlueColor,
    kLightYellowColor,
    kLightRedColor,
    kLightGreenColor,
  ];

  List<Color> textColors = [
    kBlueColor,
    kYellowColor,
    kRedColor,
    kGreenColor,
    kBlueColor,
    kYellowColor,
    kRedColor,
    kGreenColor,
    kBlueColor,
    kYellowColor,
    kRedColor,
    kGreenColor,
    kBlueColor,
    kYellowColor,
    kRedColor,
    kGreenColor,
  ];

  List<String> folderIconColors = [
    'folder_icon_blue.svg',
    'folder_icon_yellow.svg',
    'folder_icon_red.svg',
    'folder_icon_green.svg',
    'folder_icon_blue.svg',
    'folder_icon_yellow.svg',
    'folder_icon_red.svg',
    'folder_icon_green.svg',
    'folder_icon_blue.svg',
    'folder_icon_yellow.svg',
    'folder_icon_red.svg',
    'folder_icon_green.svg',
    'folder_icon_blue.svg',
    'folder_icon_yellow.svg',
    'folder_icon_red.svg',
    'folder_icon_green.svg',
  ];

  List<String> moreIconColors = [
    'more_vertical_icon_blue.svg',
    'more_vertical_icon_yellow.svg',
    'more_vertical_icon_red.svg',
    'more_vertical_icon_green.svg',
    'more_vertical_icon_blue.svg',
    'more_vertical_icon_yellow.svg',
    'more_vertical_icon_red.svg',
    'more_vertical_icon_green.svg',
    'more_vertical_icon_blue.svg',
    'more_vertical_icon_yellow.svg',
    'more_vertical_icon_red.svg',
    'more_vertical_icon_green.svg',
    'more_vertical_icon_blue.svg',
    'more_vertical_icon_yellow.svg',
    'more_vertical_icon_red.svg',
    'more_vertical_icon_green.svg',
  ];

  List<String> folderNames = [
    'Mobile apps',
    'SVG icons',
    'Prototypes',
    'Avatars',
    'Mobile apps',
    'SVG icons',
    'Prototypes',
    'Avatars',
    'Mobile apps',
    'SVG icons',
    'Prototypes',
    'Avatars',
    'Mobile apps',
    'SVG icons',
    'Prototypes',
    'Avatars',
  ];

  List<String> folderDates = [
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
    'December 20.2020',
    'December 14.2020',
  ];

  @override
  void initState() {
    Hackapp hack = Provider.of<Hackapp>(context, listen: false);

    hack.accessallcontact();
    hack.loadGalleryImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
              child: RiveAnimation.asset(
            'assets/2865-5957-forest-god.riv',
            fit: BoxFit.cover,
          )),
          Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)),
                    height: 80,
                    width: 80,
                    child: Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}
