// ignore_for_file: must_be_immutable
import 'package:delivery/controller/auth_controller.dart';
import 'package:delivery/model/allinonboardscreen.dart';
import 'package:delivery/styles/app_colors.dart';
import 'package:delivery/styles/text_styles.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
        "assets/images/designf.jpg",
        "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
        "Prepard by exparts"),
    AllinOnboardModel(
        "assets/images/designs.jpg",
        "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
        "Delivery to your home"),
    AllinOnboardModel(
        "assets/images/designt.jpg",
        "There are many variations of passages of Lorem Ipsum available. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary",
        "Enjoy with everyone"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Food Express",
          style: KTextStyle.headerTextStyle,
        ),
        backgroundColor: AppColors.blue,
      ),
      backgroundColor: AppColors.whiteshade,
      body: Stack(
        children: [
          PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: allinonboardlist.length,
              itemBuilder: (context, index) {
                return PageBuilderWidget(
                    title: allinonboardlist[index].titlestr,
                    description: allinonboardlist[index].description,
                    imgurl: allinonboardlist[index].imgStr);
              }),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allinonboardlist.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          currentIndex < allinonboardlist.length - 1
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (currentIndex > 0) {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeInOut);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.turquoise,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                        ),
                        child: const Text(
                          "Previous",
                          style: KTextStyle.authButtonTextStyle,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (currentIndex < allinonboardlist.length - 1) {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.easeInOut);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0))),
                        ),
                        child: const Text(
                          "Next",
                          style: KTextStyle.authButtonTextStyle,
                        ),
                      )
                    ],
                  ),
                )
              : Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  left: MediaQuery.of(context).size.width * 0.33,
                  child: ElevatedButton(
                    onPressed: () {
                      /* Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OtpVerification()));
                       */
                      AuthController().retrieveSession(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    child: const Text(
                      "Get Started",
                      style: KTextStyle.authButtonTextStyle,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: AppColors.kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? AppColors.primarygreen
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  String title;
  String description;
  String imgurl;

  PageBuilderWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.whiteshade), // Cambia el color a bluelith
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Image.asset(imgurl),
          ),
          const SizedBox(
            height: 20,
          ),
          // Título Texto
          Text(title,
              style: const TextStyle(
                  color: AppColors.primarygreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          // Descripción
          Text(description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: AppColors.primarygreen,
                fontSize: 14,
              ))
        ],
      ),
    );
  }
}
