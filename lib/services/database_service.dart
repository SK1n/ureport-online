import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:ureport_ecaro/models/opinion_search_list.dart';
import 'package:ureport_ecaro/models/response-local-chat-parsing.dart';
import 'package:ureport_ecaro/models/response-opinion-localdb.dart';

import '../models/firebase_incoming_message.dart';
import '../models/response_opinions.dart' as opinionArray;
import '../utils/database_constant.dart';

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // var dir = await getDatabasesPath();
    // var path = dir + "database.db";
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'ureport_online_db.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table ${DatabaseConstant.tableName} ( 
          ${DatabaseConstant.columnID} integer primary key, 
          ${DatabaseConstant.columnPROGRAM} text,
          ${DatabaseConstant.columnTitle} text,
          ${DatabaseConstant.columnFeatured} text,
          ${DatabaseConstant.columnSummary} text,
          ${DatabaseConstant.columnContent} text,
          ${DatabaseConstant.columnVideoId} text,
          ${DatabaseConstant.columnAudioLink} text,
          ${DatabaseConstant.columnTags} text,
          ${DatabaseConstant.columnImages} text,
          ${DatabaseConstant.columnCategory} text,
          ${DatabaseConstant.columnCreated_on} text)
        ''');
        db.execute('''
          create table ${DatabaseConstant.tableNameOpinion} ( 
          ${DatabaseConstant.columnIDOpinion} integer primary key, 
          ${DatabaseConstant.columnTitleOpinion} text,
          ${DatabaseConstant.columnCategoryOpinion} text,
          ${DatabaseConstant.columnOrganizationOpinion} text,
          ${DatabaseConstant.columnProgramOpinion} text,
          ${DatabaseConstant.columnQuestionOpinion} text,
          ${DatabaseConstant.columnPollDateOpinion} text)
   
        ''');

        db.execute('''
          create table ${DatabaseConstant.tableNameMessage} ( 
          ${DatabaseConstant.columnIDmessage} integer primary key AUTOINCREMENT NOT NULL, 
          ${DatabaseConstant.message} text,
          ${DatabaseConstant.sender} text,
          ${DatabaseConstant.status} text,
          ${DatabaseConstant.columnPROGRAM} text,
          ${DatabaseConstant.quicktypest} text,
          ${DatabaseConstant.time} text)
         
        ''');
      },
    );
    return database;
  }

  //Opinion section

  Future<bool> insertOpinion(
      List<opinionArray.Result?> list, String program) async {
    var db = await this.database;

    list.forEach((element) async {
      await db.insert(
          DatabaseConstant.tableNameOpinion,
          {
            DatabaseConstant.columnIDOpinion: element!.id,
            DatabaseConstant.columnTitleOpinion: element.title,
            DatabaseConstant.columnCategoryOpinion: element.category.name,
            DatabaseConstant.columnOrganizationOpinion: element.org,
            DatabaseConstant.columnPollDateOpinion: element.pollDate.toString(),
            DatabaseConstant.columnProgramOpinion: program,
            DatabaseConstant.columnQuestionOpinion:
                jsonEncode(element.questions),
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    return true;
  }

  Future<List<OpinionSearchList>> getOpinionCategories(String program) async {
    List<OpinionSearchList> opinionCategory = [];

    var db = await this.database;

    var result = await db.rawQuery(
        "SELECT DISTINCT category FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER BY LOWER(category) ASC");
    var resultTitle = await db.rawQuery(
        "SELECT id,title,poll_date,category FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER by id DESC");
    result.forEach((element) {
      List<OpinionSearchItem> titles = [];
      var category = ResultOpinionLocal.fromJson(element);
      resultTitle.forEach((element) {
        var title = ResultOpinionLocal.fromJson(element);
        if (title.category == category.category) {
          titles.add(
              new OpinionSearchItem(title.id, title.title, title.polldate));
        }
      });
      opinionCategory.add(new OpinionSearchList(category.category, titles));
    });
    return opinionCategory;
  }

  Future<List<ResultOpinionLocal>> getOpinions(String program, int id) async {
    List<ResultOpinionLocal> opinion = [];
    var db = await this.database;
    var result;
    if (id == 0) {
      result = await db.rawQuery(
          "SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' order by ${DatabaseConstant.columnIDOpinion} DESC limit 1");
    } else {
      result = await db.rawQuery(
          "SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnIDOpinion} = $id order by ${DatabaseConstant.columnIDOpinion} DESC limit 1");
    }
    result.forEach((element) {
      var list = ResultOpinionLocal.fromJson(element);
      opinion.add(list);
    });

    return opinion;
  }

  Future<int> getOpinionCount(String program) async {
    Database db = await this.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnProgramOpinion} = '$program'"));
    print("Opinion count: $count");
    print("Opinion count: $program");
    return count!;
  }

  //Chat section

  Future<bool> insertConversation(
      List<MessageModel> list, String program) async {
    var db = await this.database;
    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());
      await db.insert(
          DatabaseConstant.tableNameMessage,
          {
            DatabaseConstant.message: element.message,
            DatabaseConstant.sender: element.sender,
            DatabaseConstant.status: element.status,
            DatabaseConstant.quicktypest: jsonEncode(element.quicktypest),
            DatabaseConstant.time: element.time,
            DatabaseConstant.columnPROGRAM: program,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    return true;
  }

  Future<List<MessageModelLocal>> getConversation(String program) async {
    List<MessageModelLocal> _conversation = [];
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    var result = await db.rawQuery(
        "SELECT * FROM ${DatabaseConstant.tableNameMessage} WHERE program = '$program'");
    result.forEach((element) {
      var list = MessageModelLocal.fromJson(element);
      _conversation.add(list);
    });
    return _conversation;
  }

  Future<bool> deleteConversation(String program) async {
    var db = await this.database;
    db.transaction((txn) async {
      var batch = txn.batch();

      batch.delete(DatabaseConstant.tableNameMessage,
          where: "program = '$program'");
      await batch.commit();
    });
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    // await db.rawDelete("delete FROM ${DatabaseConstant.tableNameMessage}");
    print("message deleted");
    return true;
  }

  deleteSingelMessage(time, String program) async {
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    await db.rawDelete(
        "delete  FROM ${DatabaseConstant.tableNameMessage} where ${DatabaseConstant.time}='$time'");
    return true;
  }

  Future<bool> updateSingleMessage(MessageModelLocal msg) async {
    var db = await this.database;
    await db
        .rawQuery(
            "UPDATE  ${DatabaseConstant.tableNameMessage} SET ${DatabaseConstant.message} ='${msg.message}', ${DatabaseConstant.quicktypest}='null' where ${DatabaseConstant.time}='${msg.time}'")
        .then((value) {
      return true;
    });
    return false;
  }

  Future<bool> updateQuicktypeMessage(time, data) async {
    var db = await this.database;
    await db
        .rawDelete(
            "UPDATE  ${DatabaseConstant.tableNameMessage} SET ${DatabaseConstant.quicktypest} ='${jsonEncode(data)}' where ${DatabaseConstant.time}='$time'")
        .then((value) {
      return true;
    });

    return false;
  }

  Future<int> getMessageCount(String program) async {
    Database db = await this.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ${DatabaseConstant.tableNameMessage} WHERE program = '$program'"));
    return count!;
  }
}
