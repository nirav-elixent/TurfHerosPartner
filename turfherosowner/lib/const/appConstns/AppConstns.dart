// ignore_for_file: prefer_final_fields, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/repositories/api_repository.dart';

class AppConstns extends GetxController {
  final ApiRepository _repository = ApiRepository();
  Rx isLoading = false.obs;
//create textediting controller for user name
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<FocusNode> firstNameFocusNode = FocusNode().obs;
  RxBool firstNameSelected = true.obs;

  //create textedting controller last name
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<FocusNode> lastNameFocusNode = FocusNode().obs;
  RxBool lastNameSelected = true.obs;

  //create textedting controller moblie number
  Rx<TextEditingController> moblieNuController = TextEditingController().obs;
  Rx<FocusNode> moblieNuFocusNode = FocusNode().obs;
  RxBool moblieNuSelected = true.obs;

  //create textedting controller email
  Rx<TextEditingController> emailIDController = TextEditingController().obs;
  Rx<FocusNode> emailIDFocusNode = FocusNode().obs;
  RxBool emailIDSelected = true.obs;
  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;
      
  userDetailsUpdate(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.userDetailsUpdate(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Position currentPosition = Position(
      latitude: 23.0061,
      longitude: 72.5164,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speedAccuracy: 0.0,
      speed: 0.0);
}
