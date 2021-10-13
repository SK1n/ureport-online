import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/database/database_helper.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingDetails extends StatefulWidget {
  @override
  _SettingDetailsState createState() => _SettingDetailsState();
}

class _SettingDetailsState extends State<SettingDetails> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  var spservice = locator<SPUtil>();
  late String switchstate;
  late String soundstate;
  late String notificationstate;
  bool statesf = true;
  bool statesNotification = true;
  bool statesSound = true;
  bool isNotificationClickable = false;

  @override
  void initState() {
    switchstate = spservice.getValue(SPUtil.DELETE5DAYS);
    if (switchstate == "true") {
      statesf = true;
    } else
      statesf = false;

    soundstate = spservice.getValue(SPUtil.SOUND);
    print("Sound state : $soundstate");
    if (soundstate == "false") {
      statesSound = false;
    } else
      statesSound = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  ClickSound.soundClose();
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 80,
                  child: Image(
                    height: 35,
                    width: 35,
                    color: Colors.black,
                    image: AssetImage("assets/images/v2_ic_back.png"),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.settings}",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      child: Image(
                        color: RemoteConfigData.getTextColor(),
                        image: AssetImage("assets/images/v2_ic_settings.png"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 7),
                decoration: BoxDecoration(
                  color: RemoteConfigData.getBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      AppLocalizations.of(context)!.notification,
                      style: TextStyle(
                          color: RemoteConfigData.getTextColor(),
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/v2_ic_sound.png",
                              height: 18,
                              width: 18,
                              color: RemoteConfigData.getTextColor(),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                                "${AppLocalizations.of(context)!.on}/${AppLocalizations.of(context)!.off}",
                              style: TextStyle(
                                  color: RemoteConfigData.getTextColor(),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Switch(
                            activeColor: Colors.grey,
                            value: statesNotification,
                            onChanged: (value) {
                              ClickSound.soundTap();
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 7),
                decoration: BoxDecoration(
                  color: RemoteConfigData.getBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      AppLocalizations.of(context)!.sound,
                      style: TextStyle(
                          color: RemoteConfigData.getTextColor(),
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/v2_ic_sound.png",
                              height: 18,
                              width: 18,
                              color: RemoteConfigData.getTextColor(),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                                "${AppLocalizations.of(context)!.on}/${AppLocalizations.of(context)!.off}",
                              style: TextStyle(
                                  color: RemoteConfigData.getTextColor(),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Switch(
                            activeColor: Colors.white,
                            value: statesSound,
                            onChanged: (value) {
                              ClickSound.soundTap();
                              setState(() {
                                statesSound = value;
                                spservice.setValue(
                                    SPUtil.SOUND, value.toString());
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                decoration: BoxDecoration(
                  color: RemoteConfigData.getBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.chat,
                      style: TextStyle(
                          color: RemoteConfigData.getTextColor(),
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/v2_ic_sound.png",
                                height: 18,
                                width: 18,
                                color: RemoteConfigData.getTextColor(),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  "${AppLocalizations.of(context)!.five_days_delete_text}",
                                  style: TextStyle(
                                      color: RemoteConfigData.getTextColor(),
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                            activeColor: Colors.white,
                            value: statesf,
                            onChanged: (value) {
                              ClickSound.soundTap();
                              setState(() {
                                statesf = value;
                                spservice.setValue(
                                    SPUtil.DELETE5DAYS, value.toString());
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/v2_ic_setting_chat.png",
                                height: 18,
                                width: 18,
                                color: RemoteConfigData.getTextColor(),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.remove_all_message_text,
                                  style: TextStyle(
                                      color: RemoteConfigData.getTextColor(),
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            ClickSound.soundClick();
                            deleteMessageDialog();
                          },
                          child: Container(
                            height: 25,
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.remove,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteMessageDialog() {
    AlertDialog alert = AlertDialog(
      content: Text(AppLocalizations.of(context)!.delete_message),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context)!.delete,style: TextStyle(color: Colors.red),),
          onPressed: () async {
            ClickSound.soundClick();
            await _databaseHelper
                .deleteConversation()
                .then((value) {
              Navigator.pop(context);
              Provider.of<ChatController>(
                  context,
                  listen: false)
                  .localmessage
                  .clear();
              Provider.of<ChatController>(
                  context,
                  listen: false)
                  .notifyListeners();
            });
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            ClickSound.soundClick();
            Navigator.pop(context);
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
