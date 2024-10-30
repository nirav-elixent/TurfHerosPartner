// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings,deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/customWidget/turfManageWidget.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_timeSlot_screen/blockTimeSlot/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_timeSlot_screen/manageTimeSlotDateWise/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfTimeSlotData extends StatefulWidget {
  const TurfTimeSlotData({super.key});

  @override
  State<TurfTimeSlotData> createState() => _TurfTimeSlotDataState();
}

class _TurfTimeSlotDataState extends State<TurfTimeSlotData> {
  final variable = Get.put(TurfListDataViewModel());
  late SharedPreferences prefs;
  String authToken = "";

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
    variable.firstName.value = prefs.getString("firstName") ?? "";
    variable.lastName.value = prefs.getString("lastName") ?? "";
    variable.phoneNumber.value = prefs.getString("phoneNumber") ?? "";
    // variable.phoneCode.value = prefs.getString("phoneCode") ?? "";
    variable.email.value = prefs.getString("email") ?? "";
    variable.customerId.value = prefs.getString("customer_id") ?? "";
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    Timer(const Duration(milliseconds: 500), () {
      _loadData();
    });
  }

  @override
  void dispose() {
    Get.delete<TurfListDataViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => OverlayLoaderWithAppIcon(
        isLoading: variable.isLoading.value,
        circularProgressColor: appColor,
        appIcon: Padding(
          padding: EdgeInsets.all(8.r),
          child: Image.asset(
            "assets/images/loader_image.png",
            fit: BoxFit.fill,
          ),
        ),
        child: WillPopScope(
            onWillPop: () {
              Get.back();
              return Future.value(false);
            },
            child:
                ScreenUtil().screenWidth < 600 ? moblieView() : tabletView())));
  }

  Scaffold moblieView() {
    return Scaffold(
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
              title: "Turf Grounds"),
          Obx(
            () => Expanded(
              child: variable.turfGorundList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ErrorScreen(),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                          left: 16.r, right: 16.r, top: 24.r, bottom: 16.r),
                      itemBuilder: (context, index) {
                        return TurfManagerWidget(
                          onTap: () {
                            bottomSheet(
                                variable.turfGorundList[index].name!, index);
                            // manageTimeSlotbottomSheet(
                            //     variable.turfGorundList[index].name!, index);
                          },
                          images: variable.turfGorundList[index].images!.isEmpty
                              ? ""
                              : variable.turfGorundList[index].images![0],
                          turfName: variable.turfGorundList[index].name!,
                          rating: variable.turfGorundList[index].rating!,
                          totalRating:
                              variable.turfGorundList[index].totalRating!,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 16.h,
                        );
                      },
                      itemCount: variable.turfGorundList.length),
            ),
          )
        ],
      )),
    );
  }

  Scaffold tabletView() {
    return Scaffold(
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
              title: "Turf Grounds"),
          Obx(
            () => Expanded(
              child: variable.turfGorundList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ErrorScreen(),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 24.h, bottom: 16.h),
                      itemBuilder: (context, index) {
                        return TabletTurfManagerWidget(
                          onTap: () {
                            tabletBottomSheet(
                                variable.turfGorundList[index].name!, index);
                            // tabletManageTimeSlotbottomSheet(
                            //     variable.turfGorundList[index].name!, index);
                          },
                          images: variable.turfGorundList[index].images!.isEmpty
                              ? ""
                              : variable.turfGorundList[index].images![0],
                          turfName: variable.turfGorundList[index].name!,
                          rating: variable.turfGorundList[index].rating!,
                          totalRating:
                              variable.turfGorundList[index].totalRating!,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 16.h,
                        );
                      },
                      itemCount: variable.turfGorundList.length),
            ),
          )
        ],
      )),
    );
  }

  bottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  manageTimeSlotbottomSheet(name, position);
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "", style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  blockTimeSlotbottomSheet(name, position);
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "", style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  tabletBottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 170.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  // manageTimeSlotbottomSheet(name, position);
                  // showUserDetailsView(
                  //     context);
                  tabletManageTimeSlotbottomSheet(
                      variable.turfGorundList[position].name!, position);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  tabletBlockTimeSlotbottomSheet(name, position);
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  manageTimeSlotbottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 170.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 8.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => ManageTimeSlotDateWiseScreen(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DATE",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots ",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Date wise)",
                                style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => ManageTimeSlotDateWiseScreen(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DAY",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots ",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Day wise)",
                                style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
        );
      },
    );
  }

  tabletManageTimeSlotbottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 8.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => ManageTimeSlotDateWiseScreen(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DATE",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots ",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Date wise)",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => ManageTimeSlotDateWiseScreen(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DAY",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Manage time slots ",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Day wise)",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
        );
      },
    );
  }

  blockTimeSlotbottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 180.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => BlockTimeSlot(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DATE",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots ",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Date wise)",
                                style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => BlockTimeSlot(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DAY",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots ",
                              style: bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Day wise)",
                                style: bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  tabletBlockTimeSlotbottomSheet(String name, int position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: dLocationBold_text_style,
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => BlockTimeSlot(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DATE",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots ",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Date wise)",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: () {
                  // bookingType =
                  //     "BULKBOOKING";
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (co) => BlockTimeSlot(
                                turfListDetails:
                                    variable.turfGorundList[position],
                                slotType: "DAY",
                              )));
                  // showUserDetailsView(
                  //     context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Block a slots ",
                              style: TabletAppstyle.bottomSheet_text_style,
                              children: [
                            TextSpan(
                                text: "(Day wise)",
                                style:
                                    TabletAppstyle.bottotSheetLast_text_style)
                          ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Divider(
                height: 1.h,
                color: greyBoldColor,
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r, top: 4.h, bottom: 4.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Cancel",
                          style: bottomSheetCancel_text_style,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _loadData() async {
    await variable.turfListData(authToken, "");

    if (variable.baseResponse.value.responseCode == 200) {
      // Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      List<dynamic> turfListJson =
          variable.baseResponse.value.data!["turfList"];

      variable.turfGorundList.value =
          turfListJson.map((json) => TurfList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }
}

          // Row(
                                                      //   children: [
                                                      //     GestureDetector(
                                                      //       onTap: () {
                                                      //         Navigator.push(
                                                      //             context,
                                                      //             MaterialPageRoute(
                                                      //                 builder:
                                                      //                     (to) =>
                                                      //                         TurfEditDetailsScreen(
                                                      //                           turfGroundDetailsScreen: variable.turfGorundList[index],
                                                      //                         )));
                                                      //       },
                                                      //       child: SvgPicture.asset(
                                                      //           "assets/images/edit_image.svg"),
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 16.w,
                                                      //     ),
                                                      //     SvgPicture.asset(
                                                      //         "assets/images/delete_image.svg"),
                                                      //   ],
                                                      // )
    // Padding(
              //   padding: EdgeInsets.only(left: 16.r),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
               
              //     },
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: RichText(
              //               text: TextSpan(
              //                   text: "Book a slot",
              //                   style: bottomSheet_text_style,
              //                   children: [
              //                 TextSpan(
              //                     text: "", style: bottotSheetLast_text_style)
              //               ])),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 4.h,
              // ),
              // Divider(
              //   height: 1.h,
              //   color: greyBoldColor,
              // ),
              // SizedBox(
              //   height: 4.h,
              // ),

                   // Padding(
                                                //   padding: EdgeInsets.symmetric(
                                                //       horizontal: 16.r,
                                                //       vertical: 8.h),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment
                                                //             .spaceBetween,
                                                //     children: [
                                                //       Text(
                                                //         "1.1 km away",
                                                //         style: hint_text_style,
                                                //         overflow: TextOverflow
                                                //             .ellipsis,
                                                //       ),

                                                //     ],
                                                //   ),
                                                // ),