import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:ureport_ecaro/controllers/app_router.gr.dart';
import 'package:ureport_ecaro/controllers/connectivity_controller.dart';
import 'package:ureport_ecaro/models/message_handler.dart';
import 'package:ureport_ecaro/models/response_contact_creation.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import '../services/database_service.dart';
import '../locator/locator.dart';
import '../models/firebase_incoming_message.dart';
import '../services/network_operation/rapidpro_service.dart';
import '../services/click_sound_service.dart';
import '../models/response-local-chat-parsing.dart';
import '../services/notification-service.dart';
import 'package:crypto/crypto.dart';

class ChatController extends ConnectivityController {
  List<String> quicktype = [];
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  var contatct = "";
  var _rapidproservice = locator<RapidProService>();
  var _spservice = locator<SPUtil>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  List<MessageModel> messagearray = [];
  List<MessageModel> revlist = [];
  List<MessageModelLocal> localmessage = [];

  List<MessageModelLocal> ordered = [];
  List<MessageThread> messageThread = [];
  List<dynamic> quicktypedata = [];
  var filtermessage;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String messagestatus = "sending";

  late ResponseContactCreation responseContactCreation;
  var _urn = "";
  String _token = "";

  bool isLoaded = true;

  bool _selectall = false;
  bool _allitemselected = false;
  bool _isMessageCome = false;

  bool get isMessageCome => _isMessageCome;

  set isMessageCome(bool value) {
    _isMessageCome = value;
    notifyListeners();
  }

  bool get allitemselected => _allitemselected;

  set allitemselected(bool value) {
    _allitemselected = value;
    notifyListeners();
  }

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  bool get selectall => _selectall;

  set selectall(bool value) {
    _selectall = value;
    notifyListeners();
  }

  List<int> individualselect = [];
  List<MessageModelLocal> selectedMessage = [];
  List<MessageModelLocal> delectionmessage = [];

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  //done

  deleteMessage() async {
    for (int i = 0; i < individualselect.length; i++) {
      MessageModelLocal msgl = MessageModelLocal(
          message: "This Message was Deleted",
          sender: localmessage[individualselect[i]].sender,
          status: localmessage[individualselect[i]].status,
          quicktypest: "",
          time: localmessage[individualselect[i]].time);
      localmessage[individualselect[i]] = msgl;

      await _databaseHelper.updateSingleMessage(msgl);
    }
    selectall = false;
    notifyListeners();
  }

  deleteAllMessage() {}

  selectAllMessage() {
    individualselect.clear();
    selectedMessage.clear();
    List<MessageModelLocal> willReplacelist = [];

    willReplacelist.addAll(localmessage
        .where((element) => element.message != "This Message was Deleted"));

    List<MessageModelLocal> list = [];
    for (int i = 0; i < localmessage.length; i++) {
      if (localmessage[i].message != "This Message was Deleted") {
        individualselect.add(i);
      }
    }

    if (list.length > 0) selectedMessage.addAll(list);
    notifyListeners();
  }

  addSelectionMessage(MessageModelLocal msg) {
    selectedMessage.add(msg);
    notifyListeners();
  }

  deleteSelectionMessage(MessageModelLocal msg) {
    selectedMessage.remove(msg);
    notifyListeners();
  }

  replaceQuickReplayData(int index, data) async {
    List<dynamic> repdata = [];
    repdata.add(data);
    localmessage[index].quicktypest = '["$data"]';

    await _databaseHelper
        .updateQuicktypeMessage(localmessage[index].time, repdata)
        .then((value) async {
      await loadDefaultMessage();
      notifyListeners();
    });
  }

  addQuickType() async {
    print("addQuickType");
    var data = [];
    // repdata.add(data);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

    MessageModel messageModel = MessageModel(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: data,
        time: formattedDate);
    MessageModelLocal messageModelLocal = MessageModelLocal(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: jsonEncode(data),
        time: formattedDate);

    if (localmessage.length > 0) {
      localmessage[0] = messageModelLocal;
    } else {
      localmessage.add(messageModelLocal);
    }
    notifyListeners();
  }

  addQuickTypeCaseManagement() async {
    var data = [];
    // repdata.add(data);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

    MessageModel messageModel = MessageModel(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: data,
        time: formattedDate);
    MessageModelLocal messageModelLocal = MessageModelLocal(
        message: "",
        sender: "self",
        status: "Received",
        quicktypest: jsonEncode(data),
        time: formattedDate);

    if (localmessage.length > 0) {
      localmessage[0] = messageModelLocal;
    } else {
      localmessage.add(messageModelLocal);
    }
  }

  addSelectionItems(
    int index,
  ) {
    individualselect.add(index);

    notifyListeners();
  }

  removeIndex(
    int index,
  ) {
    individualselect.remove(
      index,
    );

    notifyListeners();
  }

  getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
    // print("this is firebase fcm token ==  ${_token}");
  }

  bool firstMessageStatus() {
    String firstvalue = _spservice.getValue("${SPUtil.FIRSTMESSAGE}_ro");
    if (firstvalue == "SENT") {
      return true;
    } else {
      return false;
    }
  }

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  addMessage(MessageModel messageModel) async {
    print("add message from push notification");
    _spservice.setValue("${SPUtil.FIRSTMESSAGE}_ro", "SENT");
    messagearray.clear();
    ordered.clear();

    messagearray.add(messageModel);
    await _databaseHelper
        .insertConversation(messagearray, "U-REPORT STAGING")
        .then((value) async {
      await _databaseHelper
          .getConversation("U-REPORT STAGING")
          .then((valuereal) {
        ordered.addAll(valuereal);
        localmessage = ordered.reversed.toList();
      });
    });

    notifyListeners();
  }

  addMessageFromPushNotification(
      MessageModel messageModel, String program) async {
    print("add message from push notification");
    // OK
    _spservice.setValue("${SPUtil.FIRSTMESSAGE}_ro", "SENT");
    messagearray.clear();
    ordered.clear();

    messagearray.add(messageModel);
    await _databaseHelper
        .insertConversation(messagearray, program)
        .then((value) async {
      await _databaseHelper
          .getConversation("U-REPORT STAGING")
          .then((valuereal) {
        ordered.addAll(valuereal);
        localmessage = ordered.reversed.toList();
      });
    });

    notifyListeners();
  }

  List<dynamic> quicdata(String ss) {
    print("quick data");
    List<dynamic> data = [];

    if (ss != "null" && ss.isNotEmpty && ss != "" && ss.isNotEmpty) {
      data = json.decode(ss);

      return data;
    } else {
      return data;
    }
  }

  deleteSingleMessage(time) async {
    await _databaseHelper.deleteSingelMessage(time, "U-REPORT STAGING");
  }

  delteAllMessage() async {
    await _databaseHelper.deleteConversation("U-REPORT STAGING");
    ordered.clear();
    localmessage.clear();
    notifyListeners();
  }

  createContact() async {
    print("Create contact called 0");
    _spservice.setValue(SPUtil.USER_ROLE, "regular");
    await getToken();
    if (_token.isNotEmpty) {
      String _urn = _spservice.getValue(SPUtil.CONTACT_URN);
      if (_urn.isEmpty) {
        String contactUrn = generateMd5(SPUtil.KEY_USER_EMAIL);
        var apiResponse = await _rapidproservice
            .createContact(contactUrn, _token, "-", onSuccess: (uuid) {
          contatct = uuid;
        }, onError: (Exception error) {
          print("ONERROR: $error");
        });
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          _spservice.setValue(SPUtil.CONTACT_URN, contactUrn);
          if (_spservice
                  .getValue("${"U-REPORT STAGING"}_${SPUtil.REG_CALLED}") !=
              "true") {
            print("Create contact called 1");
            sendMessage("join");
            _spservice.setValue(
                "${"U-REPORT STAGING"}_${SPUtil.REG_CALLED}", "true");
          }
        }
      } else if (_urn.isNotEmpty) {
        if (_spservice.getValue("${"U-REPORT STAGING"}_${SPUtil.REG_CALLED}") !=
            "true") {
          print("Create contact called 3");
          sendMessage("join");
          _spservice.setValue(
              "${"U-REPORT STAGING"}_${SPUtil.REG_CALLED}", "true");
        }
      }
    }
  }

  createIndividualCaseManagement(messagekeyword) async {
    print("case management called");
    await getToken();
    if (_token.isNotEmpty) {
      String _urn = _spservice.getValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE);
      //print("l============================== casemanegement ${_urn}");
      if (_urn.isEmpty) {
        String contactUrn = generateMd5(SPUtil.KEY_USER_EMAIL);
        // print("the new Contact urn for the individual casemanegement ${contact_urn}");
        var apiResponse = await _rapidproservice
            .createContact(contactUrn, _token, "Unknown", onSuccess: (uuid) {
          contatct = uuid;
        }, onError: (Exception error) {
          print("ONERROR: $error");
        });
        // getfirebase();
        if (apiResponse.httpCode == 200) {
          responseContactCreation = apiResponse.data;
          _spservice.setValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE, contactUrn);

          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

          MessageModel messageModel = MessageModel(
              message: messagekeyword,
              sender: "user",
              status: "Sending...",
              quicktypest: [""],
              time: formattedDate);
          // print("the message keyword is ..............${messagekeyword}");
          // addMessage(messageModel);
          List<MessageModel> list = [];
          list.add(messageModel);
          _databaseHelper.insertConversation(list, "U-REPORT STAGING");
          sendMessage(messagekeyword);
          messageModel.status = messagestatus;

          notifyListeners();
        }
      } else if (_urn.isNotEmpty) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

        MessageModel messageModel = MessageModel(
            message: messagekeyword,
            sender: "user",
            status: "Sending...",
            quicktypest: [""],
            time: formattedDate);
        // addMessage(messageModel);
        List<MessageModel> list = [];
        list.add(messageModel);
        _databaseHelper.insertConversation(list, "U-REPORT STAGING");
        sendMessage(messagekeyword);
        messageModel.status = messagestatus;

        notifyListeners();
      }
    }
  }

  List<String> detectedlink = [];

  deleteMsgAfterFiveDays() async {
    if (_spservice.getValue("${"U-REPORT STAGING"}_${SPUtil.DELETE5DAYS}") ==
        "true") {
      await _databaseHelper
          .getConversation("U-REPORT STAGING")
          .then((valuereal) {
        //get curreent date
        DateTime now = DateTime.now();
        //compare c_date with valuereal.date
        valuereal.forEach((element) async {
          DateTime valuetime =
              new DateFormat('dd-MM-yyyy hh:mm:ss a').parse(element.time);
          Duration sincetime = now.difference(valuetime);

          if (sincetime.inDays >= 5) {
            await deleteSingleMessage(element.time);
            notifyListeners();
          }
        });
      });
    }
  }

  List<String> getLinkClickable(String singleMessage) {
    List<String> stringlist = singleMessage.split(" ");

    List<String> dummy = [];

    TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

    RegExp exp =
        new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(singleMessage);

    matches.forEach((element) {
      detectedlink.add(singleMessage.substring(element.start, element.end));
    });

    return stringlist;
  }

  loadDefaultMessage() async {
    print("from load default message");

    ordered.clear();
    localmessage.clear();
    await _databaseHelper.getConversation("U-REPORT STAGING").then((valuereal) {
      ordered.addAll(valuereal);
      localmessage = ordered.reversed.toList();
      notifyListeners();
    });
  }

  sendMessage(String message) async {
    print("from send message");

    isMessageCome = true;
    String urn = "";
    String userRole = _spservice.getValue(SPUtil.USER_ROLE);

    if (userRole == "regular") {
      urn = _spservice.getValue(SPUtil.CONTACT_URN);
    } else {
      urn = _spservice.getValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE);
    }

    await _rapidproservice.sendMessage(
        message: message,
        onSuccess: (value) {
          // print("this response message $value");
          messagestatus = "Sent";
        },
        onError: (error) {
          //  print("this is error message $error");
          messagestatus = "failed";
        },
        urn: urn.isEmpty
            ? "${DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now())}"
            : urn,
        fcmToken: _token);
  }

  sendMessage1(String message, String urn) async {
    print("from send message 1 $urn");
    isMessageCome = true;
    // String formattedDate =
    //     DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
    // urn = formattedDate;
    // String urn = "";
    String userRole = _spservice.getValue(SPUtil.USER_ROLE);

    if (userRole == "regular") {
      urn = _spservice.getValue(SPUtil.CONTACT_URN);
    } else {
      urn = _spservice.getValue(SPUtil.CONTACT_URN_INDIVIDUAL_CASE);
    }

    await _rapidproservice.sendMessage(
        message: message,
        // message: message.isEmpty ? "join" : message,
        onSuccess: (value) {
          // print("this response message $value");
          messagestatus = "Sent";
        },
        onError: (error) {
          //  print("this is error message $error");
          messagestatus = "failed";
        },
        urn: urn,
        fcmToken: _token);
  }

  //on app notification
  getFirebase() {
    print("getFirebase called");
    FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage) {
      print("got message");
      print("Notify");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);

      print("remoteMessage->  ${remotemessage.data}");
      ClickSound.soundMsgReceived();

      List<dynamic> quicktypest;
      if (remotemessage.data["quick_replies"] != null) {
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      } else {
        quicktypest = [""];
      }

      var serverMessage = MessageModel(
          sender: 'server',
          message: remotemessage.data["message"],
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);

      if (remotemessage.data["title"] == "U-REPORT STAGING") {
        addMessage(serverMessage);
      } else {
        addMessageFromPushNotification(
            serverMessage, remotemessage.data["title"]);
      }

      isMessageCome = false;
    }).onError((e) {
      print("error-> ${e.toString()}");
    });
  }

  getFirebaseInitialMessage() {
    print("from getFirebaseInitialMessage");
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remotemessage) {
      print("controller init called");
      print("FirebaseInitial ${remotemessage?.data}");
      if (remotemessage != null) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
        List<dynamic> quicktypest;
        if (remotemessage.data["quick_replies"] != null) {
          quicktypest = json.decode(remotemessage.data["quick_replies"]);
        } else {
          quicktypest = [""];
        }
        //print("the notification message is ${remotemessage.notification!.body}");
        var notificationmessage_terminatestate = MessageModel(
            sender: 'server',
            message: remotemessage.notification!.body,
            status: "received",
            quicktypest: quicktypest,
            time: formattedDate);
        addMessage(notificationmessage_terminatestate);
        FirebaseNotificationService.display(remotemessage);
      } else {
        print("remoteMessage->: ${remotemessage}");
      }
    });
  }

// app background notification
  getFirebaseOnApp(context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remotemessage) {
      print("controller on App called");

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss a').format(now);
      List<dynamic> quicktypest;
      if (remotemessage.data["quick_replies"] != null) {
        quicktypest = json.decode(remotemessage.data["quick_replies"]);
      } else {
        quicktypest = [""];
      }
      var notificationmessage = MessageModel(
          sender: 'server',
          message: remotemessage.notification!.body,
          status: "received",
          quicktypest: quicktypest,
          time: formattedDate);
      addMessage(notificationmessage);
      FirebaseNotificationService.display(remotemessage);
      context.router.push(ChatRoute(from: "notification"));
    });
  }
}
