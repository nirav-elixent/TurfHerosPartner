// ignore_for_file: unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/customWidget/deleteAccount.dart';
import 'package:turf_heros_owner/customWidget/turfGrooundWidget.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_add_details_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_edit_details_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_ground_details_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfGorundsScreen extends StatefulWidget {
  const TurfGorundsScreen({super.key});

  @override
  State<TurfGorundsScreen> createState() => _TurfGorundsScreenState();
}

class _TurfGorundsScreenState extends State<TurfGorundsScreen> {
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
  void dispose() {
    Get.delete<TurfListDataViewModel>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    Timer(const Duration(milliseconds: 600), () {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
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
            //  Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //           builder: (co) => const TurfGorundsScreen()));
            return Future.value(false);
          },
          child: ScreenUtil().screenWidth < 600
              ? moblieView(context)
              : tabletView(context),
        ),
      ),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (con) => const TurfAddDetailsScreen()));
        },
        child: addTurf(),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          CustomToolbar(
              onTap: () {
                Get.back();
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (co) => DashBoardSreen()));
              },
              title: "Turf Grounds"),
          Obx(
            () => Expanded(
              child: variable.turfGorundList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 24.h, bottom: 16.h),
                      itemBuilder: (context, index) {
                        return TurfGroundListWidget(
                          images: variable.turfGorundList[index].images!.isEmpty
                              ? ""
                              : variable.turfGorundList[index].images![0],
                          name: variable.turfGorundList[index].name!,
                          rating: variable.turfGorundList[index].rating!,
                          totalRating:
                              variable.turfGorundList[index].totalRating!,
                          turfDetail: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (con) => TurfDetailsScreen(
                                          turfListDetails:
                                              variable.turfGorundList[index],
                                        )));
                          },
                          editDetails: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (to) => TurfEditDetailsScreen(
                                          turfGroundDetailsScreen:
                                              variable.turfGorundList[index],
                                        )));
                          },
                          deleteTurf: () {
                            showDialog(
                              context: context,
                              builder: (_) => DeleteTurf(
                                name: variable.turfGorundList[index].name!,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteTurf(index);
                                },
                              ),
                            );
                          },
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

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (con) => const TurfAddDetailsScreen()));
        },
        child: tabletAddTurf(),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          TabletCustomToolbar(
              onTap: () {
                Get.back();
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (co) => DashBoardSreen()));
              },
              title: "Turf Grounds"),
          Obx(
            () => Expanded(
              child: variable.turfGorundList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorScreen(),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 24.h, bottom: 16.h),
                      itemBuilder: (context, index) {
                        return TabletTurfGroundListWidget(
                          images: variable.turfGorundList[index].images!.isEmpty
                              ? ""
                              : variable.turfGorundList[index].images![0],
                          name: variable.turfGorundList[index].name!,
                          rating: variable.turfGorundList[index].rating!,
                          totalRating:
                              variable.turfGorundList[index].totalRating!,
                          turfDetail: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (con) => TurfDetailsScreen(
                                          turfListDetails:
                                              variable.turfGorundList[index],
                                        )));
                          },
                          editDetails: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (to) => TurfEditDetailsScreen(
                                          turfGroundDetailsScreen:
                                              variable.turfGorundList[index],
                                        )));
                          },
                          deleteTurf: () {
                            showDialog(
                              context: context,
                              builder: (_) => TabletDeleteTurf(
                                name: variable.turfGorundList[index].name!,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteTurf(index);
                                },
                              ),
                            );
                          },
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

  Container addTurf() {
    return Container(
      margin: EdgeInsets.only(bottom: 45.h, right: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: appColor,
          border: Border.all(color: whiteColor, width: 5.w)),
      height: 52.h,
      width: 52.w,
      child: Center(
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }

  Container tabletAddTurf() {
    return Container(
      margin: EdgeInsets.only(bottom: 45.h, right: 8.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: appColor,
          border: Border.all(color: whiteColor, width: 5.w)),
      height: 54.h,
      width: 40.w,
      child: Center(
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
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

  deleteTurf(int index) async {
    var body = {"turfId": "${variable.turfGorundList[index].sId}"};

    await variable.deleteTurf(authToken, body);

    if (variable.baseResponseDeleteAccount.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseDeleteAccount.value.response);

      _loadData();
      // List<dynamic> turfListJson =
      //     variable.baseResponse.value.data!["turfList"];

      // variable.turfGorundList.value =
      //     turfListJson.map((json) => TurfList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseDeleteAccount.value.response);
    }
  }
}
  // bottomSheet(String name, int position) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 150.h,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             SizedBox(
  //               height: 8.h,
  //             ),
  //             Text(
  //               name,
  //               textAlign: TextAlign.center,
  //               style: dLocationBold_text_style,
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Divider(
  //               height: 1.h,
  //               color: greyBoldColor,
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(left: 16.r),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(context);

  //                 },
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: RichText(
  //                           text: TextSpan(
  //                               text: "Book a slot",
  //                               style: bottomSheet_text_style,
  //                               children: [
  //                             TextSpan(
  //                                 text: "", style: bottotSheetLast_text_style)
  //                           ])),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Divider(
  //               height: 1.h,
  //               color: greyBoldColor,
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 // bookingType =
  //                 //     "BULKBOOKING";
  //                 Navigator.pop(context);
  //                 // showUserDetailsView(
  //                 //     context);
  //               },
  //               child: Padding(
  //                 padding: EdgeInsets.only(left: 16.r),
  //                 child: Row(
  //                   children: [
  //                     RichText(
  //                         text: TextSpan(
  //                             text: "Manage time slots",
  //                             style: bottomSheet_text_style,
  //                             children: [
  //                           TextSpan(
  //                               text: "", style: bottotSheetLast_text_style)
  //                         ])),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Divider(
  //               height: 1.h,
  //               color: greyBoldColor,
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 // bookingType =
  //                 //     "BULKBOOKING";
  //                 Navigator.pop(context);
  //                 // showUserDetailsView(
  //                 //     context);
  //               },
  //               child: Padding(
  //                 padding: EdgeInsets.only(left: 16.r),
  //                 child: Row(
  //                   children: [
  //                     RichText(
  //                         text: TextSpan(
  //                             text: "Block slots",
  //                             style: bottomSheet_text_style,
  //                             children: [
  //                           TextSpan(
  //                               text: "", style: bottotSheetLast_text_style)
  //                         ])),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Divider(
  //               height: 1.h,
  //               color: greyBoldColor,
  //             ),
  //             SizedBox(
  //               height: 4.h,
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(left: 16.r),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         "Cancel",
  //                         style: bottomSheetCancel_text_style,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


      // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/turf-list",
    //     body: {
    //       "pageNumber": "1",
    //       "perPage": "10",
    //       "searchString": "",
    //     },
    //     headers: {
    //       'Content-type': 'application/json',
    //       "Authorization": "Bearer $authToken",
    //       "app-version": "1.0",
    //       "app-platform": Platform.isIOS ? "ios" : "android"
    //     },
    //   );
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     List<dynamic> turfListJson = responseData.data!["turfList"];

    //     variable.turfGorundList.value =
    //         turfListJson.map((json) => TurfList.fromJson(json)).toList();

    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }