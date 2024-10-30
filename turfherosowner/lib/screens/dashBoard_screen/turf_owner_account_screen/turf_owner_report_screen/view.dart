// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';
import 'package:turf_heros_owner/repositories/api_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class TurfOwnerReportScreen extends StatefulWidget {
  const TurfOwnerReportScreen({super.key});

  @override
  State<TurfOwnerReportScreen> createState() => TurfOwnerReportScreenState();
}

class TurfOwnerReportScreenState extends State<TurfOwnerReportScreen> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "Booking", child: Text("Booking")),
    ];
    return menuItems;
  }

  RxString selectedValue = "Booking".obs;
  DateTime? selectedDate;
  RxString startDate = "".obs;
  RxString endDate = "".obs;
  RxString startDateTime = "".obs;
  RxString endDateTime = "".obs;

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;
  late SharedPreferences prefs;
  String authToken = "";

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    selectedValue = "Booking".obs;
    startDate = "".obs;
    endDate = "".obs;
    startDateTime = "".obs;
    endDateTime = "".obs;
    baseResponse = ApiResponse(responseCode: 0, status: "", response: "").obs;
    authToken = "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtil().screenWidth < 600
        ? moblieView(context)
        : tabletView(context);
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
    backgroundColor: whiteColor,
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          CustomToolbar(
              onTap: () {
                Get.back();
              },
              title: "Account Report"),
          SizedBox(
            height: 32.h,
          ),
          discountTypeTextField(),
          SizedBox(
            height: 16.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectDate(context);
                    startDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectDate(context);
                    endDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          CustomeButton(
              title: "Submit",
              onTap: () {
                if (startDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Please Select start date");
                } else if (endDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Please Select end date");
                } else {
                  reportLink();
                }
              })
        ],
      ),
    ),
  );
  }


  Scaffold tabletView(BuildContext context) {
    return Scaffold(
    backgroundColor: whiteColor,
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          TabletCustomToolbar(
              onTap: () {
                Get.back();
              },
              title: "Account Report"),
          SizedBox(
            height: 32.h,
          ),
          tabletDiscountTypeTextField(),
          SizedBox(
            height: 16.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectDate(context);
                    startDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: textFiledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Date",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectDate(context);
                    endDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
                )
              ],
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          TabletCustomeButton(
              title: "Submit",
              onTap: () {
                if (startDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Please Select start date");
                } else if (endDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Please Select end date");
                } else {
                  reportLink();
                }
              })
        ],
      ),
    ),
  );
  }

  Stack discountTypeTextField() {
    return Stack(
      children: [
        DropdownButtonFormField(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: appColor,
                letterSpacing: 0,
                wordSpacing: 0,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              filled: true,
              fillColor: textFiledColor,
              constraints: BoxConstraints(minHeight: 65.h),
              contentPadding: EdgeInsets.only(
                left: 16.w,
                top: 16.h,
              ),
            ),
            validator: (value) => value == null ? "Select a country" : null,
            dropdownColor: textFiledColor,
            value: selectedValue.value,
            onChanged: (String? newValue) {
              selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Select Report",
              style: label_text_style,
            )),
      ],
    );
  }

    Stack tabletDiscountTypeTextField() {
    return Stack(
      children: [
        DropdownButtonFormField(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
                     iconSize: 24.h,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: appColor,
                letterSpacing: 0,
                wordSpacing: 0,
                fontFamily: fontFamily),
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              filled: true,
              fillColor: textFiledColor,
              constraints: BoxConstraints(minHeight: 65.h,maxHeight: 65.h),
                  contentPadding:
                  EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h,right: 16.w),
            ),
            validator: (value) => value == null ? "Select a country" : null,
            dropdownColor: textFiledColor,
            value: selectedValue.value,
            onChanged: (String? newValue) {
              selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Select Report",
              style: label_text_style,
            )),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return picked;
  }

  reportLink() async {
    final ApiRepository _repository = ApiRepository();

    var body = {"startDate": "$startDate", "endDate": "$endDate"};
    baseResponse.value = await _repository.reportLink(authToken, body);

    if (baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: baseResponse.value.response);
      downloadFile(
          baseResponse.value.data["filePath"].toString(), "BOX CRICKET REPORT");
    } else {
      Fluttertoast.showToast(msg: baseResponse.value.response);
    }
  }

  Future<void> downloadFile(String fileUrl, String filename) async {
    final response =
        await http.get(Uri.parse("${ApiService.baseUrl}/$fileUrl"));
   
    if (response.statusCode == 200) {
      Directory downloadsDir =
          Directory('/storage/emulated/0/Download'); // For Android
      String filePath = path.join(downloadsDir.path, filename);

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
   
    }
  }
}
