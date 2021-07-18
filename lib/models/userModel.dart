import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppUser {
  static String phone;
  static String name;
  static DateTime dob;
  static String doorNo;
  static String streetName;
  static String cityName;
  static String pincode;
  static String fcmToken;
  static bool isLoggedIn;
  static int userType;

  FirebaseFirestore db = FirebaseFirestore.instance;

  static void set(String phone) {
    AppUser.name = "";
    AppUser.phone = phone;
    AppUser.dob = null;
    AppUser.doorNo = "";
    AppUser.streetName = "";
    AppUser.cityName = "";
    AppUser.pincode = "";
    AppUser.isLoggedIn = false;
    AppUser.userType = 0;
  }

  static void update({
    String name,
    DateTime dob,
    String doorNo,
    String streetName,
    String cityName,
    String pincode,
    bool isLoggedIn,
    String fcmToken,
    int userType,
  }) {
    AppUser.name = name;
    AppUser.dob = dob;
    AppUser.doorNo = doorNo;
    AppUser.streetName = streetName;
    AppUser.cityName = cityName;
    AppUser.pincode = pincode;
    AppUser.isLoggedIn = isLoggedIn;
    AppUser.fcmToken = fcmToken;
    AppUser.userType = userType;
  }

  Map<String, Object> get getMap {
    return {
      'name': AppUser.name,
      'phone': AppUser.phone,
      'dob': AppUser.dob.toString(),
      'doorNo': AppUser.doorNo,
      'streetName': AppUser.streetName,
      'cityName': AppUser.cityName,
      'pincode': AppUser.pincode,
      'fcmToken': AppUser.fcmToken,
      'userType': AppUser.userType,
    };
  }

  Future<void> updateInfoInDb() async {
    await db.collection("User").doc(AppUser.phone).set(getMap);
  }

  Future<bool> get getInfoFromDb async {
    var temp = false;

    var value = await db.collection("User").doc(AppUser.phone).get();
    if (value.exists) {
      temp = true;
      update(
        name: value.data()['name'],
        dob: DateTime.parse(value.data()['dob']),
        doorNo: value.data()["doorNo"],
        streetName: value.data()["streetName"],
        cityName: value.data()["cityName"],
        pincode: value.data()["pincode"],
        isLoggedIn: AppUser.isLoggedIn,
        fcmToken: value.data()['fcmToken'],
        userType: value.data()['userType'],
      );
      FirebaseMessaging fbm = FirebaseMessaging.instance;
      String fcmToken = await fbm.getToken();
      await db
          .collection("User")
          .doc(AppUser.phone)
          .update({"fcmToken": fcmToken});
    }

    return temp;
  }

  Future<void> updateAddress(
      {String doorNo,
      String streetName,
      String cityName,
      String pincode}) async {
    await db.collection("User").doc(AppUser.phone).update({
      'doorNo': doorNo,
      'cityName': cityName,
      'streetName': streetName,
      'pincode': pincode,
    });
  }
}
