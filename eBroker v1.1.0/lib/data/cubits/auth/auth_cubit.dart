import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/api.dart';
import '../../../utils/helper_utils.dart';
import '../../../utils/hive_utils.dart';
import '../../../utils/ui_utils.dart';
import '../../helper/custom_exception.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthProgress extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  bool isAuthenticated = false;

  Authenticated(this.isAuthenticated);
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

class AuthCubit extends Cubit<AuthState> {
  //late String name, email, profile, address;
  AuthCubit() : super(AuthInitial()) {
    // checkIsAuthenticated();
  }
  void checkIsAuthenticated() {
    if (HiveUtils.isUserAuthenticated()) {
      //setUserData();
      emit(Authenticated(true));
    } else {
      emit(Unauthenticated());
    }
  }

  Future updateFCM(BuildContext context) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log("UPDATING FCM ${token}");
      await Api.post(
        url: Api.apiUpdateProfile,
        parameter: {
          Api.userid: HiveUtils.getUserId(),
          "fcm_id": token,
        },
      );
    } catch (e) {
      log("Unable to update FCM");
    }
  }

  Future<Map<String, dynamic>> updateuserdata(
    BuildContext context, {
    String? name,
    String? email,
    String? address,
    File? fileUserimg,
    String? fcmToken,
    String? notification,
        String ?role,

  }) async {
    Map<String, dynamic> parameters = {
      Api.name: name ?? '',
      Api.email: email ?? '',
      Api.address: address ?? '',
      Api.fcmId: fcmToken ?? '',
      Api.userid: HiveUtils.getUserId(),
      Api.notification: notification,
      Api.role:role

    };
    if (fileUserimg != null) {
      parameters['profile'] = await MultipartFile.fromFile(fileUserimg.path);
    }
    var response =
        await Api.post(url: Api.apiUpdateProfile, parameter: parameters);

    print("Res[o] $response $parameters");
    if (!response[Api.error]) {
      // Constant.session.setUserData(response['data'], "");
      HiveUtils.setUserData(response['data']);
      checkIsAuthenticated();
    } else {
      throw CustomException(response[Api.message]);
    }
    return response;
  }

  enquerySend(
      BuildContext context, {
        String? message,String? id}
      ) async {
    Map<String, dynamic> parameters = {
      "message": message ?? '',
      "property_id":id

    };

    var response =
        await Api.post(url: Api.apiStoreinqury, parameter: parameters);

    HelperUtils.showSnackBarMessage(context,
             UiUtils.getTranslatedLabel(context, "${response["message"]}"));

  }
  enqueryAdd(
      BuildContext context, {
        String? name,String? schoolname,String ?subject,String ?description,String ?mobile}
      ) async {
    Map<String, dynamic> parameters = {
      "school_name": schoolname ?? '',
      "mobile":mobile,
      "name":name,
      "subject":subject,
      "description":description

    };

    var response =
    await Api.post(url: Api.apiGenerateinqury, parameter: parameters);

    HelperUtils.showSnackBarMessage(context,
        UiUtils.getTranslatedLabel(context, "${response["message"]}"));

  }
  enqueryGet(
      BuildContext context, {
       String? id}
      ) async {
    Map<String, dynamic> parameters = {

      "property_id":id

    };

    var response =
    await Api.post(url: Api.apiGetinqury, parameter: parameters);


    return response;

  }
  enqueryGetData(
      BuildContext context,

      ) async {


    var response =
    await Api.post(url: Api.apiGetdatainqury, parameter: {});


    return response;

  }

  void getUserById(
    BuildContext context,
  ) async {
    Map<String, String> body = {Api.userid: HiveUtils.getUserId().toString()};

    var response = await HelperUtils.sendApiRequest(
        Api.apigetUserbyId, body, false, context);

    Future.delayed(
      Duration.zero,
      () async {
        response = await HelperUtils.sendApiRequest(
            Api.apiUpdateProfile, body, true, context);
      },
    );

    var getdata = json.decode(response);

    if (getdata != null) {
      if (!getdata[Api.error]) {
        // Constant.session.setUserData(getdata['data'], "");
        checkIsAuthenticated();
      } else {
        throw CustomException(getdata[Api.message]);
      }
    } else {
      Future.delayed(
        Duration.zero,
        () {
          throw CustomException("nodatafound".translate(context));
        },
      );
    }
  }

  void signOut(BuildContext context) async {
    if ((state as Authenticated).isAuthenticated) {
      HiveUtils.logoutUser(context, onLogout: () {});
      emit(Unauthenticated());
    }
  }
}
