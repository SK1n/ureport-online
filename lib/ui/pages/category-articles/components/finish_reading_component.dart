import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/controllers/app_router.gr.dart';
import 'package:ureport_ecaro/ui/shared/general_button_component.dart';
import 'package:ureport_ecaro/utils/constants.dart';

class FinishReadingComponent extends StatefulWidget {
  const FinishReadingComponent({
    super.key,
    required this.translation,
    required this.translationProfile,
    required this.storyId,
    required this.onRateArticle,
    required this.initRating,
    required this.showRating,
  });

  final Map<String, String> translation;
  final Map<String, String> translationProfile;
  final bool showRating;
  final String storyId;
  final int initRating;
  final Function(int) onRateArticle;

  @override
  State<FinishReadingComponent> createState() => _FinishReadingComponentState();
}

class _FinishReadingComponentState extends State<FinishReadingComponent> {
  Map<int, bool> stars = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };
  late int rating;

  @override
  void initState() {
    rating = widget.initRating;
    for (int i = 0; i < widget.initRating; i++) {
      stars[i] = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(167, 45, 111, 1),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                widget.translation["bottom_text1"]! +
                    widget.storyId.toString() +
                    "-lea" +
                    widget.translation["bottom_text2"]!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              MainAppButtonComponent(
                  color: Colors.white,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  title: widget.translation["claim_badge_button"]!,
                  onPressed: () {
                    context.router.replaceAll([
                      ProfileScreenRoute(translation: widget.translationProfile)
                    ]);
                  }),
            ]),
          ),
          widget.showRating
              ? Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 1,
                  color: Colors.white,
                )
              : Container(),
          widget.showRating
              ? Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    widget.translation["rating"]!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : Container(),
          widget.showRating
              ? Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: GestureDetector(
                              onTap: () {
                                rating = 0;
                                setState(() {
                                  stars.forEach((key, value) {
                                    if (key <= index + 1) {
                                      rating++;
                                      stars[key] = true;
                                    } else {
                                      stars[key] = false;
                                    }
                                  });
                                });
                                widget.onRateArticle(rating);
                              },
                              child: Icon(
                                stars.values.elementAt(index)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.white,
                                size: 50,
                              )),
                        );
                      }),
                )
              : Container(),
        ],
      ),
    );
  }
}
