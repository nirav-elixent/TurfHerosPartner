// ignore_for_file: must_be_immutable,sized_box_for_whitespace, unused_field, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_ground_details_screen/ownerTurf_ground_bulkBookingScreen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_ground_details_screen/ownerTurf_ground_screen.dart/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class TurfDetailsScreen extends StatefulWidget {
  TurfList turfListDetails;

  TurfDetailsScreen({required this.turfListDetails, super.key});
  @override
  State<TurfDetailsScreen> createState() => _TurfDetailsScreenState();
}

class _TurfDetailsScreenState extends State<TurfDetailsScreen> {
  String address = "";
  final variable = Get.put(UserDetailsDataViewModel());
  late TransformationController _transformationController;
  late PageController _pageController;
  late ScrollController _scrollController;
  late SharedPreferences prefs;
  var authToken = "";

  String bookingType = "";

  RxList<SportList> sportsList = <SportList>[].obs;
  RxList<SportList> facilityList = <SportList>[].obs;

  RxList<SportList> turfFacilityList = <SportList>[].obs;
  RxList<SportList> turfSportsList = <SportList>[].obs;

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void dispose() {
    Get.delete<UserDetailsDataViewModel>();
    _transformationController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    sportsList.clear();
    facilityList.clear();
    turfFacilityList.clear();
    turfSportsList.clear();
    super.dispose();
  }

  Future<List<SportList>> loadModelList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('modelList');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);

      // Explicitly convert each item in the list to SportList
      return decodedData.map((item) => SportList.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<SportList>> loadFacilityModelList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('facilitymodelList');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);

      // Explicitly convert each item in the list to SportList
      return decodedData.map((item) => SportList.fromJson(item)).toList();
    }
    return [];
  }

  void fetchSportsList() async {
    List<SportList> loadedList = await loadModelList();
    sportsList.addAll(loadedList);

    turfSportsList.value = sportsList.where((sport) {
      return widget.turfListDetails.sportIds!.contains(sport.sId);
    }).toList(); // Assign the loaded list to the RxList
  }

  void fetchFacilityList() async {
    List<SportList> loadedList = await loadFacilityModelList();
    facilityList.addAll(loadedList);

    turfFacilityList.value = facilityList.where((facility) {
      return widget.turfListDetails.facilityIds!.contains(facility.sId);
    }).toList(); // Assign the loaded list to the RxList
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    fetchSportsList();
    fetchFacilityList();
    _transformationController = TransformationController();
    _pageController = PageController();
    _scrollController = ScrollController();
    address =
        "${widget.turfListDetails.address!.line1} ${widget.turfListDetails.address!.line2}, ${widget.turfListDetails.address!.city}, ${widget.turfListDetails.address!.state} ${widget.turfListDetails.address!.country} ${widget.turfListDetails.address!.pinCode}";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
          isLoading: variable.isLoading.value,
          circularProgressColor: appColor,
          appIcon: SizedBox(
            height: 30.h,
            width: 30.w,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Image.asset(
                "assets/images/loader_image.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          child: ScreenUtil().screenWidth < 600
              ? moblieView(context)
              : tabletView(context)),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 275.h,
                  child: PageView.builder(
                      itemCount: widget.turfListDetails.images!.isEmpty
                          ? 0
                          : widget.turfListDetails.images!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/turf_details_image.png",
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }),
                )),
            Positioned(
              left: 16.w,
              top: 40.h,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 33.h,
                  width: 33.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff000000),
                            blurRadius: 2,
                            spreadRadius: 0.1)
                      ]),
                  child: Center(
                      child: SvgPicture.asset("assets/images/back_image.svg")),
                ),
              ),
            ),
            Positioned(
                top: 160.r,
                left: 0,
                right: 0,
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.r),
                          topRight: Radius.circular(25.r)),
                      color: Colors.black.withOpacity(0.3)),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      padding:
                          EdgeInsets.only(top: 12.h, left: 16.w, bottom: 12.h),
                      itemBuilder: (context, index) {
                        return index == 4
                            ? GestureDetector(
                                onTap: () {
                                  showGalleryView(context, 0);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 60.h,
                                      width: 55.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+${widget.turfListDetails.images!.length - 4}',
                                            style: images_incremec_text_style,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : index < 4
                                ? GestureDetector(
                                    onTap: () {
                                      showSingleGalleryView(context, index);
                                    },
                                    child: Container(
                                      height: 60.h,
                                      width: 55.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 8.w,
                        );
                      },
                      itemCount: widget.turfListDetails.images!.length),
                )),
            Positioned(
                top: 240.r,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 590.h,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.r),
                          topRight: Radius.circular(25.r))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                widget.turfListDetails.name!,
                                style: detailsturfName_text_style,
                              )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹ ${widget.turfListDetails.rate}",
                                    style: detailsturfprice_text_style,
                                  ),
                                  Text(
                                    "Per hour",
                                    style: locationAway_text_style,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/star_image.svg"),
                                        RichText(
                                          text: TextSpan(
                                              text: widget
                                                  .turfListDetails.rating!
                                                  .toStringAsFixed(1)
                                                  .toString(),
                                              style: dLocationBold_text_style,
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "(${formatNumber(widget.turfListDetails.totalRating!)})",
                                                    style:
                                                        locationAway_text_style)
                                              ]),
                                        ),
                                      ])
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/location_image.svg"),
                              SizedBox(
                                width: 9.w,
                              ),
                              Expanded(
                                  flex: 9,
                                  child: Text(
                                    address,
                                    style: hint_text_style,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/turf_sq_image.svg"),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                  child: Text(
                                "${widget.turfListDetails.area} Sq. ft.",
                                style: hint_text_style,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            openMap(
                                widget.turfListDetails.coordinates!
                                    .coordinates![1],
                                widget.turfListDetails.coordinates!
                                    .coordinates![0],
                                widget.turfListDetails.name!);
                          },
                          child: Container(
                            height: 45.h,
                            width: 323.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border:
                                    Border.all(color: appColor, width: 1.h)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    "assets/images/maps_image.svg"),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Map View",
                                  style: mapButton_text_style,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sport",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Obx(
                          () => SizedBox(
                            height: 30.h,
                            width: double.maxFinite,
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (widget.turfListDetails.sportIds!
                                      .contains(sportsList[index].sId)) {
                                  } else {}
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        "${ApiService.baseUrl}/${turfSportsList[index].images}",
                                        height: 22.h,
                                        width: 22.w,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SvgPicture.asset(
                                              "assets/images/detailsCricket_image.svg",
                                              fit: BoxFit.contain);
                                        },
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        turfSportsList[index].name!,
                                        style: detailcri_text_style,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 24.w,
                                  );
                                },
                                itemCount: turfSportsList.length),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Facilities provided",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Obx(
                          () => SizedBox(
                            height: 30.h,
                            width: double.maxFinite,
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        "${ApiService.baseUrl}/${turfFacilityList[index].images}",
                                        height: 22.h,
                                        width: 22.w,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SvgPicture.asset(
                                              "assets/images/time_image.svg",
                                              fit: BoxFit.contain);
                                        },
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        turfFacilityList[index].name!,
                                        style: detailcri_text_style,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 24.w,
                                  );
                                },
                                itemCount: turfFacilityList.length),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "About",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            widget.turfListDetails.about!,
                            style: detailsAbout_text_style,
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        CustomeButton(
                            title: "Book Now",
                            onTap: () {
                              //showUserDetailsView(context);
                              bookingTurfType();
                              //  Get.toNamed(turfBooking_screen);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (ci) => TurfBookingScreen(
                              //             turfListDetails:
                              //                 widget.turfListDetails)));
                            }),
                               SizedBox(
                          height: 40.h,
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 275.h,
                  child: PageView.builder(
                      itemCount: widget.turfListDetails.images!.isEmpty
                          ? 0
                          : widget.turfListDetails.images!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/turf_details_image.png",
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }),
                )),
            Positioned(
              left: 16.w,
              top: 40.h,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 33.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: whiteColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff000000),
                            blurRadius: 2,
                            spreadRadius: 0.1)
                      ]),
                  child: Center(
                      child: SvgPicture.asset("assets/images/back_image.svg")),
                ),
              ),
            ),
            Positioned(
                top: 180.r,
                left: 0,
                right: 0,
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.r),
                          topRight: Radius.circular(25.r)),
                      color: Colors.black.withOpacity(0.3)),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      padding:
                          EdgeInsets.only(top: 12.h, left: 16.w, bottom: 12.h),
                      itemBuilder: (context, index) {
                        return index == 5
                            ? GestureDetector(
                                onTap: () {
                                  showGalleryView(context, 0);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 55.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}"),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+${widget.turfListDetails.images!.length - 4}',
                                            style: images_incremec_text_style,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : index < 5
                                ? GestureDetector(
                                    onTap: () {
                                      showSingleGalleryView(context, index);
                                    },
                                    child: Container(
                                      height: 55.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 8.w,
                        );
                      },
                      itemCount: widget.turfListDetails.images!.length),
                )),
            Positioned(
                top: 260.r,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 590.h,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.r),
                          topRight: Radius.circular(25.r))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                widget.turfListDetails.name!,
                                style: detailsturfName_text_style,
                              )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹ ${widget.turfListDetails.rate}",
                                    style: detailsturfprice_text_style,
                                  ),
                                  Text(
                                    "Per hour",
                                    style: locationAway_text_style,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/star_image.svg"),
                                        RichText(
                                          text: TextSpan(
                                              text: widget
                                                  .turfListDetails.rating!
                                                  .toStringAsFixed(1)
                                                  .toString(),
                                              style: dLocationBold_text_style,
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "(${formatNumber(widget.turfListDetails.totalRating!)})",
                                                    style:
                                                        locationAway_text_style)
                                              ]),
                                        ),
                                      ])
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/location_image.svg"),
                              SizedBox(
                                width: 9.w,
                              ),
                              Expanded(
                                  flex: 9,
                                  child: Text(
                                    address,
                                    style: hint_text_style,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/turf_sq_image.svg"),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                  child: Text(
                                "${widget.turfListDetails.area} Sq. ft.",
                                style: hint_text_style,
                              ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            openMap(
                                widget.turfListDetails.coordinates!
                                    .coordinates![1],
                                widget.turfListDetails.coordinates!
                                    .coordinates![0],
                                widget.turfListDetails.name!);
                          },
                          child: Container(
                            height: 45.h,
                            width: 323.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border:
                                    Border.all(color: appColor, width: 1.h)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    "assets/images/maps_image.svg"),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Map View",
                                  style: mapButton_text_style,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sport",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Obx(
                          () => SizedBox(
                            height: 30.h,
                            width: double.maxFinite,
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (widget.turfListDetails.sportIds!
                                      .contains(sportsList[index].sId)) {
                                  } else {}
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        "${ApiService.baseUrl}/${turfSportsList[index].images}",
                                        height: 22.h,
                                        width: 22.w,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SvgPicture.asset(
                                              "assets/images/detailsCricket_image.svg",
                                              fit: BoxFit.contain);
                                        },
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        turfSportsList[index].name!,
                                        style: detailcri_text_style,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 24.w,
                                  );
                                },
                                itemCount: turfSportsList.length),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Facilities provided",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Obx(
                          () => SizedBox(
                            height: 30.h,
                            width: double.maxFinite,
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        "${ApiService.baseUrl}/${turfFacilityList[index].images}",
                                        height: 22.h,
                                        width: 22.w,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return SvgPicture.asset(
                                              "assets/images/time_image.svg",
                                              fit: BoxFit.contain);
                                        },
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        turfFacilityList[index].name!,
                                        style: detailcri_text_style,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 24.w,
                                  );
                                },
                                itemCount: turfFacilityList.length),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "About",
                                style: detailDesp_text_style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            widget.turfListDetails.about!,
                            style: detailsAbout_text_style,
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        TabletCustomeButton(
                            title: "Book Now",
                            onTap: () {
                              //showUserDetailsView(context);
                              tabletBookingTurfType();
                              //  Get.toNamed(turfBooking_screen);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (ci) => TurfBookingScreen(
                              //             turfListDetails:
                              //                 widget.turfListDetails)));
                            }),
                        SizedBox(
                          height: 60.h,
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> openMap(double lat, double lng, String placeName) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'geo:$lat,$lng?q=$lat,$lng($placeName)';
      // url =
      //     'https://www.google.com/maps/search/?api=1&query=$placeName'; // Include place name in the query parameter
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  String formatNumber(int number) {
    if (number >= 10000000) {
      return (number / 10000000).toStringAsFixed(2) + ' Cr';
    } else if (number >= 100000) {
      return (number / 100000).toStringAsFixed(2) + ' L';
    } else if (number >= 1000) {
      return (number / 1000).toStringAsFixed(2) + ' k';
    } else {
      return number.toString();
    }
  }

  void showGalleryView(BuildContext context, int position) {
    variable.galleryIndex.value = position;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 350.h,
            width: 330.w,
            child: Stack(
              children: [
                PageView.builder(
                  padEnds: false,
                  dragStartBehavior: DragStartBehavior.down,
                  controller: _pageController,
                  scrollBehavior: const ScrollBehavior(),
                  onPageChanged: (value) {
                    variable.galleryIndex.value = value;
                  },
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      transformationController: _transformationController,
                      trackpadScrollCausesScale: true,
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (_transformationController.value
                                  .getMaxScaleOnAxis() <
                              2.0) {
                            // Zoom in
                            _transformationController.value =
                                Matrix4.diagonal3Values(
                              _transformationController.value
                                      .getMaxScaleOnAxis() *
                                  2.0,
                              _transformationController.value
                                      .getMaxScaleOnAxis() *
                                  2.0,
                              1.0,
                            );
                          } else {
                            // Zoom out
                            _transformationController.value =
                                Matrix4.diagonal3Values(
                              _transformationController.value
                                      .getMaxScaleOnAxis() /
                                  2.0,
                              _transformationController.value
                                      .getMaxScaleOnAxis() /
                                  2.0,
                              1.0,
                            );
                          }
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: Image.network(
                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index]}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/turf_image.png",
                                    fit: BoxFit.cover);
                              },
                            )),
                      ),
                    );
                  },
                  itemCount: widget.turfListDetails.images!.length,
                ),
                Positioned(
                    right: 5.w,
                    top: 5.h,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSingleGalleryView(BuildContext context, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 350.h,
            width: 330.w,
            child: Stack(
              children: [
                PageView.builder(
                  padEnds: false,
                  dragStartBehavior: DragStartBehavior.down,
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    variable.galleryIndex.value = value;
                  },
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      transformationController: _transformationController,
                      trackpadScrollCausesScale: true,
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: GestureDetector(
                        onDoubleTap: () {
                          if (_transformationController.value
                                  .getMaxScaleOnAxis() <
                              2.0) {
                            // Zoom in
                            _transformationController.value =
                                Matrix4.diagonal3Values(
                              _transformationController.value
                                      .getMaxScaleOnAxis() *
                                  2.0,
                              _transformationController.value
                                      .getMaxScaleOnAxis() *
                                  2.0,
                              1.0,
                            );
                          } else {
                            // Zoom out
                            _transformationController.value =
                                Matrix4.diagonal3Values(
                              _transformationController.value
                                      .getMaxScaleOnAxis() /
                                  2.0,
                              _transformationController.value
                                      .getMaxScaleOnAxis() /
                                  2.0,
                              1.0,
                            );
                          }
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: Image.network(
                              "${ApiService.baseUrl}/${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![position]}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/turf_image.png",
                                    fit: BoxFit.cover);
                              },
                            )),
                      ),
                    );
                  },
                  itemCount: widget.turfListDetails.images!.length,
                ),
                Positioned(
                    right: 5.w,
                    top: 5.h,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }

  void bookingTurfType() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 140.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                widget.turfListDetails.name!,
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
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: GestureDetector(
                  onTap: () {
                    bookingType = "DATEBOOKING";
                    Navigator.pop(context);
                    showUserDetailsView(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: "Book a slot ",
                                style: bottomSheet_text_style,
                                children: [
                              TextSpan(
                                  text: "(Date wise)",
                                  style: bottotSheetLast_text_style)
                            ])),
                      ),
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
                  bookingType = "BULKBOOKING";
                  Navigator.pop(context);
                  showUserDetailsView(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Bulk Booking ",
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
                padding: EdgeInsets.only(left: 16.w),
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

  void tabletBookingTurfType() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Text(
                widget.turfListDetails.name!,
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
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: GestureDetector(
                  onTap: () {
                    bookingType = "DATEBOOKING";
                    Navigator.pop(context);
                    tabletShowUserDetailsView(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: "Book a slot ",
                                style: TabletAppstyle.bottomSheet_text_style,
                                children: [
                              TextSpan(
                                  text: "(Date wise)",
                                  style:
                                      TabletAppstyle.bottotSheetLast_text_style)
                            ])),
                      ),
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
                  bookingType = "BULKBOOKING";
                  Navigator.pop(context);
                  tabletShowUserDetailsView(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Bulk Booking ",
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
                padding: EdgeInsets.only(left: 16.w),
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

  void showUserDetailsView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            height: 175.h,
            width: 330.w,
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "User details",
                  style: dLocationBold_text_style,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Please enter User whatsapp number",
                        style: detailsAbout_text_style,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Stack(
                  children: [
                    Obx(
                      () => AppTextFiled(
                        controller: variable.userMoblieNuController.value,
                        focusNode: variable.userMoblieNuFocusNode.value,
                        selected: variable.userMoblieNuSelected.value,
                        lebel: "",
                        contentPadding: EdgeInsets.only(left: 78.r),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onSubmitt: (value) {},
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            variable.userMoblieNuSelected.value = false;
                            return "Please Enter your moblie number";
                          } else if (variable.userMoblieNuController.value.text
                                      .length <
                                  10 &&
                              value.length < 10) {
                            variable.userMoblieNuSelected.value = false;
                            return "please enter 10 digit mobile number";
                          }
                          variable.userMoblieNuSelected.value = true;
                          return null;
                        },
                      ),
                    ),
                    CountryCodePicker(
                      onInit: (value) {
                        variable.userPhoneCode.value = value!.dialCode!;
                      },
                      onChanged: (value) {
                        variable.userPhoneCode.value = value.dialCode!;
                      },
                      initialSelection: 'IN',
                      padding: EdgeInsets.only(left: 16.r),
                      favorite: const ['+91', 'IN'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      showDropDownButton: true,
                      showFlag: false,
                      alignLeft: false,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 16.h, right: 16.w, bottom: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              // style: deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (variable
                              .userMoblieNuController.value.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mobile Number",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (variable
                                  .userMoblieNuController.value.text.length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mobile Number",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Navigator.of(context).pop();
                            Timer(const Duration(seconds: 1), () {
                              userData();
                            });
                          }
                        },
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Submit",
                              //  style: deteleAccountButton_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void tabletShowUserDetailsView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          insetPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: whiteColor,
            ),
            height: 200.h,
            width: 330.w,
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "User details",
                  style: dLocationBold_text_style,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Please enter User whatsapp number",
                        style: detailsAbout_text_style,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                     padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Stack(
                    children: [
                      // Obx(
                      //   () => AppTextFiled(
                      //     controller: variable.userMoblieNuController.value,
                      //     focusNode: variable.userMoblieNuFocusNode.value,
                      //     selected: variable.userMoblieNuSelected.value,
                      //     lebel: "",
                      //     contentPadding: EdgeInsets.only(left: 78.r),
                      //     inputFormatters: [
                      //       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      //       LengthLimitingTextInputFormatter(10),
                      //     ],
                      //     onSubmitt: (value) {},
                      //     keyboardType: TextInputType.number,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         variable.userMoblieNuSelected.value = false;
                      //         return "Please Enter your moblie number";
                      //       } else if (variable.userMoblieNuController.value.text
                      //                   .length <
                      //               10 &&
                      //           value.length < 10) {
                      //         variable.userMoblieNuSelected.value = false;
                      //         return "please enter 10 digit mobile number";
                      //       }
                      //       variable.userMoblieNuSelected.value = true;
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      TextFormField(
                        controller: variable.userMoblieNuController.value,
                        onChanged: (value) {},
                        style: TabletAppstyle.mobilwNumber_text_style,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: TextInputType.number,
                       
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 58.w, top: 10.h, bottom: 10.h),
                          constraints:
                              BoxConstraints(maxHeight: 50.h, maxWidth: 340.w),
                          hintText: "Enter mobile Number",
                          hintStyle: TabletAppstyle.hint_text_style,
                          filled: true,
                          fillColor: textFiledColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: fillColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide:
                                  BorderSide(color: fillColor, width: 1.w)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: fillColor)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: fillColor)),
                        ),
                      ),
                      // CountryCodePicker(
                      //   onInit: (value) {
                      //     variable.userPhoneCode.value = value!.dialCode!;
                      //   },
                      //   onChanged: (value) {
                      //     variable.userPhoneCode.value = value.dialCode!;
                      //   },
                      //   initialSelection: 'IN',
                      //   padding: EdgeInsets.only(left: 16.r),
                      //   favorite: const ['+91', 'IN'],
                      //   showCountryOnly: false,
                      //   showOnlyCountryWhenClosed: false,
                      //   showDropDownButton: true,
                      //   showFlag: false,
                      //   alignLeft: false,
                      // ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 4.w,
                        child: CountryCodePicker(
                          onInit: (value) {
                            variable.userPhoneCode.value = value!.dialCode!;
                          },
                          onChanged: (value) {
                            variable.userPhoneCode.value = value.dialCode!;
                          },
                          initialSelection: 'IN',
                          padding: EdgeInsets.zero,
                          favorite: const ['+91', 'IN'],
                          showCountryOnly: false,
                          textStyle: TabletAppstyle.phoneCode_style,
                          showOnlyCountryWhenClosed: false,
                          showDropDownButton: true,
                          showFlag: false,
                          alignLeft: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 16.h, right: 16.w, bottom: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child:  Center(
                            child: Text(
                              "Cancel",
                               style: TabletAppstyle.deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (variable
                              .userMoblieNuController.value.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mobile Number",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (variable
                                  .userMoblieNuController.value.text.length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Please Enter Mobile Number",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Navigator.of(context).pop();
                            Timer(const Duration(seconds: 1), () {
                              userData();
                            });
                          }
                        },
                        child: Container(
                          height: 30.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: whiteColor,
                            border: Border.all(color: greyBColor, width: 1),
                          ),
                          child:  Center(
                            child: Text(
                              "Submit",
                                   style: TabletAppstyle.deteleButton_text_style,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  userData() async {
    var body = {
      "countryCode":
          "${variable.userPhoneCode.value.isEmpty ? 91 : variable.userPhoneCode.value}",
      "phoneNumber": variable.userMoblieNuController.value.text
    };

    await variable.userDetailsData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      UserData response =
          UserData.fromJson(variable.baseResponse.value.data!["userDetail"]);
      bookingType == "DATEBOOKING"
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (co) => OwnerTurfGroundScreen(
                        turfListDetails: widget.turfListDetails,
                        userId: response.id,
                      )))
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (co) => OwnerTurfBulkBookingScreen(
                        turfListDetails: widget.turfListDetails,
                        userId: response.id,
                      )));
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
    // try {
    //   final response =
    //       await api.apiPostCall(context, "owner/find-or-cerate-user", headers: {
    //     "Authorization": "Bearer $authToken",
    //     'Content-type': 'application/json',
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   }, body: {
    //     "countryCode":
    //         "${variable.userPhoneCode.value.isEmpty ? 91 : variable.userPhoneCode.value}",
    //     "phoneNumber": variable.userMoblieNuController.value.text
    //   });
    //   ApiResponse data = ApiResponse.fromJson(response);
    //   if (data.responseCode == 200) {
    //     UserData response = UserData.fromJson(data.data!["userDetail"]);
    //     loading.value = false;
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (co) => OwnerTurfGroundScreen(
    //                   turfListDetails: widget.turfListDetails,
    //                   userId: response.id,
    //                 )));
    //     Fluttertoast.showToast(msg: data.response);

    //   } else if ((data.responseCode == 401)) {
    //     loading.value = false;
    //     Fluttertoast.showToast(msg: data.response);
    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {
    //   loading.value = false;

    // }
  }
}

/*Navigator.of(context).push(new PageRouteBuilder(
                  opaque: true,
                  transitionDuration: const Duration(milliseconds: 0),
                  pageBuilder: (BuildContext context, _, __) {
                    return new FragmentChildB();
                  }));*/
