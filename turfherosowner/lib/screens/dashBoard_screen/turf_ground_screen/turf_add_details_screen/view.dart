// ignore_for_file:prefer_final_fields, use_build_context_synchronously, prefer_const_constructors, empty_catches
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/AppBigTextFiled.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/CustomRadio_button.dart';
import 'package:turf_heros_owner/customWidget/CustomSelectSport.dart';
import 'package:turf_heros_owner/customWidget/SelectPitchDetails.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/dropdownSportWidget.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_ground_screen/turf_add_details_screen/select_location_screen.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfAddDetailsScreen extends StatefulWidget {
  const TurfAddDetailsScreen({super.key});

  @override
  State<TurfAddDetailsScreen> createState() => _TurfAddDetailsScreenState();
}

class _TurfAddDetailsScreenState extends State<TurfAddDetailsScreen> {
  final variable = Get.put(AddTurfGroundDataViewModel());

  late SharedPreferences prefs;

  var _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  String authToken = "";

  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Map<String, dynamic>> pitchMaps = [];

  RxList<SportList> sportsList = <SportList>[].obs;
  RxList<SportList> facilityList = <SportList>[].obs;

  RxList<String> turfSportsSelectList = <String>[].obs;
  RxList<String> turfFacilitySelectList = <String>[].obs;

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
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

  @override
  void initState() {
    super.initState();
    fetchSportsList();
    fetchFacilityList();
    _loadPreferences();
  }

  void fetchSportsList() async {
    List<SportList> loadedList = await loadModelList();
    sportsList.addAll(loadedList); // Assign the loaded list to the RxList
  }

  void fetchFacilityList() async {
    List<SportList> loadedList = await loadFacilityModelList();
    facilityList.addAll(loadedList); // Assign the loaded list to the RxList
  }

  @override
  void dispose() {
    Get.delete<AddTurfGroundDataViewModel>();
    pitchMaps.clear();
    sportsList.clear();
    facilityList.clear();
    turfSportsSelectList.clear();
    turfFacilitySelectList.clear();
    super.dispose();
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
          child: ScreenUtil().screenWidth < 600
              ? moblieView(context)
              : tabletView(context)),
    );
  }

  Scaffold moblieView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: SizedBox(
                    height: 300.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Obx(
                          () => Container(
                            color: const Color(0xffEFEFEF),
                            child: variable.image.value == null
                                ? const Text('')
                                : Image.file(
                                    File(variable.image.value!.path),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 135,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showModalBottomSheet(context);
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/add_image.svg",
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "Add Cover Image",
                                  style: addImageBig_text_style,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 220.r,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 70.h,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showModalBottomListSheet(context);
                          },
                          child: Container(
                            width: 55.w,
                            height: 55.h,
                            margin: EdgeInsets.only(
                              left: 8.w,
                              bottom: 16.h,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: whiteColor),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/add_image.svg",
                                    height: 16.h,
                                    width: 16.w,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    "add",
                                    style: addImage_text_style,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Expanded(
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    bottom: 16.h,
                                    left: 8.w,
                                    right: 8.w,
                                    top: 4.h),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 55.h,
                                        width: 55.w,
                                        margin: EdgeInsets.all(4.r),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.file(
                                            File(variable
                                                .imageList[index]!.path),
                                            fit: BoxFit.cover,
                                            height: 55.h,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            variable.imageList.removeAt(index);
                                          },
                                          child: Container(
                                            height: 15.h,
                                            width: 15.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: redSColor,
                                                border: Border.all(
                                                    color: whiteColor,
                                                    width: 1)),
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: whiteColor,
                                                size: 10.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 8.w,
                                  );
                                },
                                itemCount: variable.imageList.length),
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                top: 46.r,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 35.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 16.r,
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
                                child: SvgPicture.asset(
                                    "assets/images/back_image.svg")),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Add Detail",
                              style: title_style,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 288.r,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                            child: Text(
                              "Select Sport",
                              style: dLocationBold_text_style,
                            ),
                          ),
                          SizedBox(
                            height: 35.h,
                            width: double.maxFinite,
                            child: Obx(
                              () => ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => CustomSelcetSport(
                                        image: sportsList[index].images!,
                                        title: sportsList[index].name!,
                                        onTap: () {
                                          sportsList[index].isSelected.value =
                                              !sportsList[index]
                                                  .isSelected
                                                  .value;
                                          turfSportsSelectList.add(
                                              sportsList[index]
                                                  .sId!
                                                  .toString());
                                        },
                                        selected:
                                            sportsList[index].isSelected.value,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 8.w,
                                    );
                                  },
                                  itemCount: sportsList.length),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  turfNameTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_NameSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  locationTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.turf_LocationSelected
                                                  .value ==
                                              true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  turfAreaTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_AreaSqSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  advanceBookingTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_PerHourSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h),
                                    child: Text(
                                      "Timing",
                                      style: dLocationBold_text_style,
                                    ),
                                  ),
                                  timePrickerView(context),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h, top: 16.h),
                                    child: Text(
                                      "Price",
                                      style: dLocationBold_text_style,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      mondayPriceView(context),
                                      tuesdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.mondaySelected.value &&
                                              variable.tuesdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      wenesdayPriceView(context),
                                      thursdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable
                                                  .wednesdaySelected.value &&
                                              variable.thursdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      fridayPriceView(context),
                                      saturdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.fridaySelected.value &&
                                              variable.saturdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  sundayPriceView(),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.sundaySelected.value == true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Text(
                              "Facilities provided",
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 11.sp,
                                  color: greyColor.withOpacity(0.75),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 36.w,
                              ),
                              child: SizedBox(
                                height: 175.h,
                                child: Obx(
                                  () => ListView.separated(
                                      padding: EdgeInsets.only(top: 5.h),
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => CustomRadioButton(
                                              title: facilityList[index].name!,
                                              onChanged: () {
                                                facilityList[index]
                                                        .isSelected
                                                        .value =
                                                    !facilityList[index]
                                                        .isSelected
                                                        .value;

                                                turfFacilitySelectList.add(
                                                    facilityList[index]
                                                        .sId!
                                                        .toString());
                                              },
                                              selected: facilityList[index]
                                                  .isSelected
                                                  .value),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 8.h,
                                        );
                                      },
                                      itemCount: facilityList.length),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                            child: Text(
                              "Select Pitch",
                              style: dLocationBold_text_style,
                            ),
                          ),
                          SizedBox(
                            height: 70.h,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectPitch(context);
                                  },
                                  child: Container(
                                    width: 50.w,
                                    height: 45.h,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      bottom: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: Color(0xffEFEFEF)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/add_image.svg",
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          "add",
                                          style: addImage_text_style,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                selectPitchDetailsView(),
                              ],
                            ),
                          ),
                          aboutTextField(),
                          Obx(
                            () => SizedBox(
                              height: variable.turf_AboutSelected.value == true
                                  ? 16.h
                                  : 0.h,
                            ),
                          ),
                          CustomeButton(
                              title: "Submit",
                              onTap: () async {
                                pitchMaps =
                                    variable.turfPitchSelectList.map((item) {
                                  return {
                                    'id': item.sId,
                                    'name': item.name,
                                    'sportIds': item.sportIds,
                                  };
                                }).toList();
                                if (_formKey.currentState!.validate()) {
                                  if (variable.imageList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select image");
                                  } else if (turfFacilitySelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select facility");
                                  } else if (turfSportsSelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select sport");
                                  } else if (variable
                                      .turfPitchSelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select Pitch");
                                  } else {
                                    for (int i = 0;
                                        i < variable.imageList.length;
                                        i++) {
                                      var getImges = await uploadPhotoData(
                                          variable.imageList[i]!.path);
                                      var parsedResponse =
                                          json.decode(getImges);

                                      variable.uploadImageData.add(
                                          parsedResponse["data"]["imageDetail"]
                                                  ["name"]
                                              .toString());
                                    }
                                    updateData();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please fillup Details");
                                }
                                //
                                //  Get.toNamed(turfBooking_screen);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (ci) => TurfBookingScreen(
                                //             turfListDetails:
                                //                 widget.turfListDetails)));
                              }),
                          SizedBox(
                            height: 90.h,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  Scaffold tabletView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: SizedBox(
                    height: 310.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Obx(
                          () => Container(
                            color: const Color(0xffEFEFEF),
                            child: variable.image.value == null
                                ? const Text('')
                                : Image.file(
                                    File(variable.image.value!.path),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 145.h,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showModalBottomSheet(context);
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/add_image.svg",
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "Add Cover Image",
                                  style: addImageBig_text_style,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 220.r,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 70.h,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showModalBottomListSheet(context);
                          },
                          child: Container(
                            width: 45.w,
                            height: 60.h,
                            margin: EdgeInsets.only(
                                left: 8.w, bottom: 8.h, right: 8.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: whiteColor),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/add_image.svg",
                                    height: 16.h,
                                    width: 16.w,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    "add",
                                    style: addImage_text_style,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Expanded(
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      SizedBox(
                                        width: 45.w,
                                        height: 60.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.file(
                                            File(variable
                                                .imageList[index]!.path),
                                            fit: BoxFit.cover,
                                            height: 55.h,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -0.h,
                                        right: 0.w,
                                        child: GestureDetector(
                                          onTap: () {
                                            variable.imageList.removeAt(index);
                                          },
                                          child: Container(
                                            height: 16.h,
                                            width: 12.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: redSColor,
                                                border: Border.all(
                                                    color: whiteColor,
                                                    width: 1)),
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: whiteColor,
                                                size: 10.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 8.w,
                                  );
                                },
                                itemCount: variable.imageList.length),
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                top: 46.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 35.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 16.w,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 33.h,
                            width: 24.w,
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
                                child: SvgPicture.asset(
                                    "assets/images/back_image.svg")),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Add Detail",
                              style: title_style,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 288.h,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                            child: Text(
                              "Select Sport",
                              style: TabletAppstyle.dLocationBold_text_style,
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                            width: double.maxFinite,
                            child: Obx(
                              () => ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => TabletCustomSelcetSport(
                                        image: sportsList[index].images!,
                                        title: sportsList[index].name!,
                                        onTap: () {
                                          sportsList[index].isSelected.value =
                                              !sportsList[index]
                                                  .isSelected
                                                  .value;
                                          turfSportsSelectList.add(
                                              sportsList[index]
                                                  .sId!
                                                  .toString());
                                        },
                                        selected:
                                            sportsList[index].isSelected.value,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 8.w,
                                    );
                                  },
                                  itemCount: sportsList.length),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  tabletTurfNameTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_NameSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  tabletLocationTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.turf_LocationSelected
                                                  .value ==
                                              true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  talbetTurfAreaTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_AreaSqSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  tabletAdvanceBookingTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_PerHourSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h),
                                    child: Text(
                                      "Timing",
                                      style: TabletAppstyle
                                          .dLocationBold_text_style,
                                    ),
                                  ),
                                  tabletTimePrickerView(context),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h, top: 16.h),
                                    child: Text(
                                      "Price",
                                      style: TabletAppstyle
                                          .dLocationBold_text_style,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      tabletMondayPriceView(context),
                                      tabletTuesdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.mondaySelected.value &&
                                              variable.tuesdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      tabletWenesdayPriceView(context),
                                      tabletThursdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable
                                                  .wednesdaySelected.value &&
                                              variable.thursdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      tabletFridayPriceView(context),
                                      tabletSaturdayPriceView(context),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height: variable.fridaySelected.value &&
                                              variable.saturdaySelected.value ==
                                                  true
                                          ? 16.h
                                          : 0.h,
                                    ),
                                  ),
                                  tabletSundayPriceView(),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.sundaySelected.value == true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Text(
                              "Facilities provided",
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 11.sp,
                                  color: greyColor.withOpacity(0.75),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 36.w,
                              ),
                              child: SizedBox(
                                height: 210.h,
                                child: Obx(
                                  () => ListView.separated(
                                      padding: EdgeInsets.only(top: 5.h),
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => TabletCustomRadioButton(
                                              title: facilityList[index].name!,
                                              onChanged: () {
                                                facilityList[index]
                                                        .isSelected
                                                        .value =
                                                    !facilityList[index]
                                                        .isSelected
                                                        .value;

                                                turfFacilitySelectList.add(
                                                    facilityList[index]
                                                        .sId!
                                                        .toString());
                                              },
                                              selected: facilityList[index]
                                                  .isSelected
                                                  .value),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 4.h,
                                        );
                                      },
                                      itemCount: facilityList.length),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                            child: Text(
                              "Select Pitch",
                              style: TabletAppstyle.dLocationBold_text_style,
                            ),
                          ),
                          SizedBox(
                            height: 70.h,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    tabletSelectPitch(context);
                                  },
                                  child: Container(
                                    width: 45.w,
                                    height: 55.h,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      bottom: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: Color(0xffEFEFEF)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/add_image.svg",
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          "add",
                                          style: addImage_text_style,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                tabletSelectPitchDetailsView(),
                              ],
                            ),
                          ),
                          tabletAboutTextField(),
                          Obx(
                            () => SizedBox(
                              height: variable.turf_AboutSelected.value == true
                                  ? 16.h
                                  : 0.h,
                            ),
                          ),
                          TabletCustomeButton(
                              title: "Submit",
                              onTap: () async {
                                pitchMaps =
                                    variable.turfPitchSelectList.map((item) {
                                  return {
                                    'id': item.sId,
                                    'name': item.name,
                                    'sportIds': item.sportIds,
                                  };
                                }).toList();
                                if (_formKey.currentState!.validate()) {
                                  if (variable.imageList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select image");
                                  } else if (turfFacilitySelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select facility");
                                  } else if (turfSportsSelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select sport");
                                  } else if (variable
                                      .turfPitchSelectList.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please select Pitch");
                                  } else {
                                    for (int i = 0;
                                        i < variable.imageList.length;
                                        i++) {
                                      var getImges = await uploadPhotoData(
                                          variable.imageList[i]!.path);
                                      var parsedResponse =
                                          json.decode(getImges);

                                      variable.uploadImageData.add(
                                          parsedResponse["data"]["imageDetail"]
                                                  ["name"]
                                              .toString());
                                    }
                                    updateData();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please fillup Details");
                                }
                                //
                                //  Get.toNamed(turfBooking_screen);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (ci) => TurfBookingScreen(
                                //             turfListDetails:
                                //                 widget.turfListDetails)));
                              }),
                          SizedBox(
                            height: 90.h,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  Obx turfNameTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_NameController.value,
        focusNode: variable.turf_NameFocusNode.value,
        selected: variable.turf_NameSelected.value,
        lebel: "Turf Name",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_LocationFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_NameSelected.value = false;
            return "Please Enter your Turf name";
          } else if (variable.turf_NameController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_NameSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_NameSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx tabletTurfNameTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.turf_NameController.value,
        focusNode: variable.turf_NameFocusNode.value,
        selected: variable.turf_NameSelected.value,
        lebel: "Turf Name",
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_LocationFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_NameSelected.value = false;
            return "Please Enter your Turf name";
          } else if (variable.turf_NameController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_NameSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_NameSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx locationTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_LocationController.value,
        focusNode: variable.turf_LocationFocusNode.value,
        selected: variable.turf_LocationSelected.value,
        lebel: "Location",
        onTap: () {
          variable.turf_LocationController.value.text == ""
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (con) => MapSample()))
              : address(context);
        },
        maxline: 3,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_AreaSqFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_LocationSelected.value = false;
            return "Please Enter your address";
          } else if (variable.turf_LocationController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_LocationSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_LocationSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx tabletLocationTextField(BuildContext context) {
    return Obx(
      () => TabletAppBigTextFiled(
        controller: variable.turf_LocationController.value,
        focusNode: variable.turf_LocationFocusNode.value,
        selected: variable.turf_LocationSelected.value,
        lebel: "Location",
        onTap: () {
          variable.turf_LocationController.value.text == ""
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (con) => MapSample()))
              : tabletAddress(context);
        },
        maxline: 3,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_AreaSqFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_LocationSelected.value = false;
            return "Please Enter your address";
          } else if (variable.turf_LocationController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_LocationSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_LocationSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx turfAreaTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_AreaSqController.value,
        focusNode: variable.turf_AreaSqFocusNode.value,
        selected: variable.turf_AreaSqSelected.value,
        lebel: "Turf area  sq. ft.",
        keyboardType: TextInputType.number,
        maxline: 3,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_HourFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_AreaSqSelected.value = false;
            return "Please Enter your address";
          } else if (variable.turf_AreaSqController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_AreaSqSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_AreaSqSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx talbetTurfAreaTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.turf_AreaSqController.value,
        focusNode: variable.turf_AreaSqFocusNode.value,
        selected: variable.turf_AreaSqSelected.value,
        lebel: "Turf area  sq. ft.",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_HourFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_AreaSqSelected.value = false;
            return "Please Enter your address";
          } else if (variable.turf_AreaSqController.value.text.length < 4 &&
              value.length < 4) {
            variable.turf_AreaSqSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.turf_AreaSqSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx advanceBookingTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_PerHourController.value,
        focusNode: variable.turf_PerHourFocusNode.value,
        selected: variable.turf_PerHourSelected.value,
        lebel: "Advance Booking Allowed Weeks",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_AreaSqFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_PerHourSelected.value = false;
            return "Please Enter advance booking weeks";
          } else {
            variable.turf_PerHourSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx tabletAdvanceBookingTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_PerHourController.value,
        focusNode: variable.turf_PerHourFocusNode.value,
        selected: variable.turf_PerHourSelected.value,
        lebel: "Advance Booking Allowed Weeks",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.turf_AreaSqFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.turf_PerHourSelected.value = false;
            return "Please Enter advance booking weeks";
          } else {
            variable.turf_PerHourSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Padding timePrickerView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      "Start Time",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectTime(context);
                    variable.startDate.value = _formatTime(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          )),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      "Expired Time",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectTime(context);
                    variable.endDate.value = _formatTime(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg"),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Padding tabletTimePrickerView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      "Start Time",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.startDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectTime(context);
                    variable.startDate.value = _formatTime(expiresAt);
                  },
                  child: SvgPicture.asset(
                    "assets/images/calender_image.svg",
                    height: 16.h,
                    width: 16.w,
                  ),
                )
              ],
            ),
          )),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      "Expired Time",
                      style: label_text_style,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Obx(
                      () => Text(
                        variable.endDate.value,
                        style: labelDate_text_style,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var expiresAt = await _selectTime(context);
                    variable.endDate.value = _formatTime(expiresAt);
                  },
                  child: SvgPicture.asset(
                    "assets/images/calender_image.svg",
                    height: 16.h,
                    width: 16.w,
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Expanded mondayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.mondayController.value,
          focusNode: variable.mondayFocusNode.value,
          selected: variable.mondaySelected.value,
          lebel: "Monday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.tuesdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.mondaySelected.value = false;
              return "Please Enter price";
            } else if (variable.mondayController.value.text.length < 2 &&
                value.length < 2) {
              variable.mondaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.mondaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletMondayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.mondayController.value,
          focusNode: variable.mondayFocusNode.value,
          selected: variable.mondaySelected.value,
          lebel: "Monday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.tuesdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.mondaySelected.value = false;
              return "Please Enter price";
            } else if (variable.mondayController.value.text.length < 2 &&
                value.length < 2) {
              variable.mondaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.mondaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tuesdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.tuesdayController.value,
          focusNode: variable.tuesdayFocusNode.value,
          selected: variable.tuesdaySelected.value,
          lebel: "Tuesday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.wednesdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.tuesdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.tuesdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.tuesdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.tuesdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletTuesdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.tuesdayController.value,
          focusNode: variable.tuesdayFocusNode.value,
          selected: variable.tuesdaySelected.value,
          lebel: "Tuesday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.wednesdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.tuesdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.tuesdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.tuesdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.tuesdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded wenesdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.wednesdayController.value,
          focusNode: variable.wednesdayFocusNode.value,
          selected: variable.wednesdaySelected.value,
          lebel: "Wednesday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.thursdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.wednesdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.wednesdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.wednesdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.wednesdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletWenesdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.wednesdayController.value,
          focusNode: variable.wednesdayFocusNode.value,
          selected: variable.wednesdaySelected.value,
          lebel: "Wednesday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.thursdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.wednesdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.wednesdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.wednesdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.wednesdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded thursdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.thursdayController.value,
          focusNode: variable.thursdayFocusNode.value,
          selected: variable.thursdaySelected.value,
          lebel: "Thursday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context).requestFocus(variable.fridayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.thursdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.thursdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.thursdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.thursdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletThursdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.thursdayController.value,
          focusNode: variable.thursdayFocusNode.value,
          selected: variable.thursdaySelected.value,
          lebel: "Thursday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context).requestFocus(variable.fridayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.thursdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.thursdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.thursdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.thursdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded saturdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.saturdayController.value,
          focusNode: variable.saturdayFocusNode.value,
          selected: variable.saturdaySelected.value,
          lebel: "Saturday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context).requestFocus(variable.sundayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.saturdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.saturdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.saturdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.saturdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletSaturdayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.saturdayController.value,
          focusNode: variable.saturdayFocusNode.value,
          selected: variable.saturdaySelected.value,
          lebel: "Saturday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context).requestFocus(variable.sundayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.saturdaySelected.value = false;
              return "Please Enter price";
            } else if (variable.saturdayController.value.text.length < 2 &&
                value.length < 2) {
              variable.saturdaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.saturdaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded fridayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => AppTextFiled(
          controller: variable.fridayController.value,
          focusNode: variable.fridayFocusNode.value,
          selected: variable.fridaySelected.value,
          lebel: "Friday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.saturdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.fridaySelected.value = false;
              return "Please Enter price";
            } else if (variable.fridayController.value.text.length < 2 &&
                value.length < 2) {
              variable.fridaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.fridaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Expanded tabletFridayPriceView(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TabletAppTextFiled(
          controller: variable.fridayController.value,
          focusNode: variable.fridayFocusNode.value,
          selected: variable.fridaySelected.value,
          lebel: "Friday",
          keyboardType: TextInputType.number,
          onSubmitt: (value) {
            FocusScope.of(context)
                .requestFocus(variable.saturdayFocusNode.value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              variable.fridaySelected.value = false;
              return "Please Enter price";
            } else if (variable.fridayController.value.text.length < 2 &&
                value.length < 2) {
              variable.fridaySelected.value = false;
              return "Please enter 2 digit";
            } else {
              variable.fridaySelected.value = true;
              return null;
            }
          },
        ),
      ),
    );
  }

  Row sundayPriceView() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => AppTextFiled(
              controller: variable.sundayController.value,
              focusNode: variable.sundayFocusNode.value,
              selected: variable.sundaySelected.value,
              lebel: "Sunday",
              keyboardType: TextInputType.number,
              onSubmitt: (value) {
                // FocusScope.of(context)
                //     .requestFocus(variable
                //         .turf_AreaSqFocusNode
                //         .value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  variable.sundaySelected.value = false;
                  return "Please Enter price";
                } else if (variable.sundayController.value.text.length < 2 &&
                    value.length < 2) {
                  variable.sundaySelected.value = false;
                  return "Please enter 2 digit";
                } else {
                  variable.sundaySelected.value = true;
                  return null;
                }
              },
            ),
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }

  Row tabletSundayPriceView() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => TabletAppTextFiled(
              controller: variable.sundayController.value,
              focusNode: variable.sundayFocusNode.value,
              selected: variable.sundaySelected.value,
              lebel: "Sunday",
              keyboardType: TextInputType.number,
              onSubmitt: (value) {
                // FocusScope.of(context)
                //     .requestFocus(variable
                //         .turf_AreaSqFocusNode
                //         .value);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  variable.sundaySelected.value = false;
                  return "Please Enter price";
                } else if (variable.sundayController.value.text.length < 2 &&
                    value.length < 2) {
                  variable.sundaySelected.value = false;
                  return "Please enter 2 digit";
                } else {
                  variable.sundaySelected.value = true;
                  return null;
                }
              },
            ),
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }

  Obx selectPitchDetailsView() {
    return Obx(
      () => Expanded(
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(bottom: 16.h, left: 8.w, right: 8.w, top: 4.h),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5.h, bottom: 5.h, right: 5.w),
                    height: 40.h,
                    child: SelectPitchDetails(
                      name: "${variable.turfPitchSelectList[index].name}",
                      onTap: () {
                        selectedPitchDetails(
                            context,
                            index,
                            variable.turfPitchSelectList[index].turfId!,
                            variable.turfPitchSelectList[index].name!,
                            variable.turfPitchSelectList[index].sportIds!);
                      },
                    ),
                  ),
                  Positioned(
                    top: -0,
                    right: -1,
                    child: GestureDetector(
                      onTap: () {
                        variable.turfPitchSelectList.removeAt(index);
                      },
                      child: Container(
                        height: 15.h,
                        width: 15.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: redSColor,
                            border: Border.all(color: whiteColor, width: 1)),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 8.w,
              );
            },
            itemCount: variable.turfPitchSelectList.length),
      ),
    );
  }

  Obx tabletSelectPitchDetailsView() {
    return Obx(
      () => Expanded(
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(bottom: 16.h, left: 8.w, right: 8.w, top: 4.h),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5.h, bottom: 5.h, right: 5.w),
                    height: 40.h,
                    child: SelectPitchDetails(
                      name: "${variable.turfPitchSelectList[index].name}",
                      onTap: () {
                        // tabletSelectedPitchDetails(
                        //     context,
                        //     index,
                        //     variable.turfPitchSelectList[index].turfId!
                        //         .toString(),
                        //     variable.turfPitchSelectList[index].name!,
                        //     variable.turfPitchSelectList[index].sportIds!);
                      },
                    ),
                  ),
                  Positioned(
                    top: -0,
                    right: -1,
                    child: GestureDetector(
                      onTap: () {
                        variable.turfPitchSelectList.removeAt(index);
                      },
                      child: Container(
                        height: 16.h,
                        width: 12.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: redSColor,
                            border: Border.all(color: whiteColor, width: 1)),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 8.w,
              );
            },
            itemCount: variable.turfPitchSelectList.length),
      ),
    );
  }

  Obx aboutTextField() {
    return Obx(() => AppBigTextFiled(
          lebel: "About",
          controller: variable.turf_AboutController.value,
          focusNode: variable.turf_AboutFocusNode.value,
          selected: variable.turf_AboutSelected.value,
          onSubmitt: (value) {},
          validator: (value) {
            if (value!.isEmpty) {
              variable.turf_AboutSelected.value = false;
              return "Please Enter your Turf name";
            } else if (variable.turf_AboutController.value.text.length < 4 &&
                value.length < 4) {
              variable.turf_AboutSelected.value = false;
              return "Please enter 4 charter";
            } else {
              variable.turf_AboutSelected.value = true;
              return null;
            }
          },
        ));
  }

  Obx tabletAboutTextField() {
    return Obx(() => TabletAppBigTextFiled(
          lebel: "About",
          controller: variable.turf_AboutController.value,
          focusNode: variable.turf_AboutFocusNode.value,
          selected: variable.turf_AboutSelected.value,
          onSubmitt: (value) {},
          maxline: 6,
          validator: (value) {
            if (value!.isEmpty) {
              variable.turf_AboutSelected.value = false;
              return "Please Enter your Turf name";
            } else if (variable.turf_AboutController.value.text.length < 4 &&
                value.length < 4) {
              variable.turf_AboutSelected.value = false;
              return "Please enter 4 charter";
            } else {
              variable.turf_AboutSelected.value = true;
              return null;
            }
          },
        ));
  }

  uploadPhotoData(String path) async {
    try {
      var headers = {
        "Authorization": "Bearer $authToken",
        'Content-type': 'application/json',
        "app-version": "1.0",
        "app-platform": Platform.isIOS ? "ios" : "android"
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiService.baseUrl}/api/owner/upload-image"),
      );
      request.files.add(await http.MultipartFile.fromPath('image', path));
      request.headers.addAll(headers);
      var res = await request.send();
      var responseString = await res.stream.bytesToString();

      return responseString;
    } catch (e) {}
  }

  updateData() async {
    var body = {
      "turfId": "",
      "name": variable.turf_NameController.value.text.toString(),
      "area": variable.turf_AreaSqController.value.text.toString(),
      "advanceBookingAllowedWeeks": variable.turf_PerHourController.value.text,
      "address": {
        "line1": variable.street.toString(),
        "line2": variable.locality.toString(),
        "country": variable.country.toString(),
        "state": variable.state.toString(),
        "city": variable.subLocality.toString(),
        "pin_code": variable.postalCode.toString()
      },
      "latitude": variable.lat.toString(),
      "longitude": variable.lng.toString(),
      "openingTime": variable.startDate.value,
      "closingTime": variable.endDate.value,
      "rateDayWise": {
        "monday": variable.mondayController.value.text,
        "tuesday": variable.tuesdayController.value.text,
        "wednesday": variable.wednesdayController.value.text,
        "thursday": variable.thursdayController.value.text,
        "friday": variable.fridayController.value.text,
        "saturday": variable.saturdayController.value.text,
        "sunday": variable.sundayController.value.text
      },
      "sportIds": turfSportsSelectList,
      "facilityIds": turfFacilitySelectList,
      "about": variable.turf_AboutController.value.text.toString(),
      "rate": variable.saturdayController.value.text.toString(),
      "images": variable.uploadImageData,
      "turfPitchList": pitchMaps,
    };

    await variable.editTurfDetails(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      Navigator.push(
          context, MaterialPageRoute(builder: (ci) => DashBoardSreen()));
      Get.delete<AddTurfGroundDataViewModel>();
      pitchMaps.clear();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                contentPadding: EdgeInsets.only(left: 5.w),
                title: Text(
                  'Gallery',
                  style: bottomsheet_title_text_style,
                ),
                onTap: () {
                  getImageFromGallery();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                contentPadding: EdgeInsets.only(left: 5.w),
                title: Text('Camera', style: bottomsheet_title_text_style),
                onTap: () {
                  getImageFromCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImageFromGallery() async {
    if (await checkAndRequestCameraPermissions()) {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxWidth: 1080,
          maxHeight: 1080);

      if (image != null) {
        variable.image.value = image;
        variable.imageList.add(image);
      } else {
        // Handle the case when the user cancels the picker
        Fluttertoast.showToast(
          msg: 'No image selected.',
        );
      }
    } else {
      _showPermissionDeniedDialog(context, "Gallery");
    }
  }

  Future getImageFromCamera() async {
    if (await checkAndRequestCameraPermissions()) {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
          maxWidth: 1080,
          maxHeight: 1080);
      if (image != null) {
        variable.image.value = image;
        variable.imageList.add(image);
      } else {
        Fluttertoast.showToast(
          msg: 'No image selected.',
        );
      }
    } else {
      _showPermissionDeniedDialog(context, "Camera");
    }
  }

  void _showModalBottomListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                contentPadding: EdgeInsets.only(left: 5.w),
                title: Text(
                  'Gallery',
                  style: bottomsheet_title_text_style,
                ),
                onTap: () {
                  getImageFromGalleryList();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                contentPadding: EdgeInsets.only(left: 5.w),
                title: Text('Camera', style: bottomsheet_title_text_style),
                onTap: () {
                  getImageFromCameraList();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImageFromGalleryList() async {
    if (await checkAndRequestCameraPermissions()) {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxWidth: 1080,
          maxHeight: 1080);
      if (image != null) {
        variable.imageList.add(image);
      } else {
        Fluttertoast.showToast(
          msg: 'No image selected.',
        );
      }
    } else {
      _showPermissionDeniedDialog(context, "Gallery");
    }
  }

  Future getImageFromCameraList() async {
    if (await checkAndRequestCameraPermissions()) {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
          maxWidth: 1080,
          maxHeight: 1080);

      if (image != null) {
        variable.imageList.add(image);
      } else {
        Fluttertoast.showToast(
          msg: 'No image selected.',
        );
      }
    } else {
      _showPermissionDeniedDialog(context, "Camera");
    }
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      PermissionStatus newPermissionStatus = await Permission.camera.request();
      return newPermissionStatus == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  void _showPermissionDeniedDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title Permission Denied'),
          content: Text(
              'This app needs $title access to take pictures. Please grant $title permission.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  selectPitch(BuildContext parentContent) {
    RxList<String> selectedValues = <String>[].obs;
    RxList<String> extraSelectedValues = <String>[].obs;
    showDialog(
        context: parentContent,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 235.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.h, left: 16.w, bottom: 8.h),
                    child: Text(
                      "Pitch name",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 11.sp,
                          color: greyColor.withOpacity(0.75),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => AppTextFiled(
                                    controller: variable.pitchController.value,
                                    focusNode: variable.pitchFocusNode.value,
                                    selected: variable.pitchSelected.value,
                                    lebel: "name",
                                    onSubmitt: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        variable.pitchSelected.value = false;
                                        return "this is required";
                                      } else if (variable.pitchController.value
                                                  .text.length <
                                              4 &&
                                          value.length < 4) {
                                        variable.pitchSelected.value = false;
                                        return 'Please enter a valid street';
                                      }
                                      variable.pitchSelected.value = true;
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, bottom: 8.h),
                                  child: Text(
                                    "Pitch sport",
                                    style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 11.sp,
                                        color: greyColor.withOpacity(0.75),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16.w, left: 16.w),
                                  child: SportListFormField(
                                    sportList: sportsList,
                                    selectedValues: selectedValues,
                                    extraSelectedValues: extraSelectedValues,
                                    onChanged: (List<String> values,
                                        List<String> extraValues) {
                                      selectedValues.value = values;
                                      extraSelectedValues.value = extraValues;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
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
                            variable.turfPitchSelectList.add(TurfPitchDetail(
                                sId: "",
                                name: variable.pitchController.value.text,
                                sportIds: extraSelectedValues));

                            Navigator.of(context).pop();
                            variable.pitchController.value.text = "";
                            // extraSelectedValues.clear();
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
        });
  }

  tabletSelectPitch(BuildContext parentContent) {
    RxList<String> selectedValues = <String>[].obs;
    RxList<String> extraSelectedValues = <String>[].obs;
    showDialog(
        context: parentContent,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 235.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.h, left: 16.w, bottom: 8.h),
                    child: Text(
                      "Pitch name",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 11.sp,
                          color: greyColor.withOpacity(0.75),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => TabletAppTextFiled(
                                    controller: variable.pitchController.value,
                                    focusNode: variable.pitchFocusNode.value,
                                    selected: variable.pitchSelected.value,
                                    lebel: "name",
                                    onSubmitt: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        variable.pitchSelected.value = false;
                                        return "this is required";
                                      } else if (variable.pitchController.value
                                                  .text.length <
                                              4 &&
                                          value.length < 4) {
                                        variable.pitchSelected.value = false;
                                        return 'Please enter a valid street';
                                      }
                                      variable.pitchSelected.value = true;
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, bottom: 8.h),
                                  child: Text(
                                    "Pitch sport",
                                    style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 11.sp,
                                        color: greyColor.withOpacity(0.75),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16.w, left: 16.w),
                                  child: SportListFormField(
                                    sportList: sportsList,
                                    selectedValues: selectedValues,
                                    extraSelectedValues: extraSelectedValues,
                                    onChanged: (List<String> values,
                                        List<String> extraValues) {
                                      selectedValues.value = values;
                                      extraSelectedValues.value = extraValues;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
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
                            child: Center(
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
                            variable.turfPitchSelectList.add(TurfPitchDetail(
                                sId: "",
                                name: variable.pitchController.value.text,
                                sportIds: extraSelectedValues));

                            Navigator.of(context).pop();
                            variable.pitchController.value.text = "";
                            // extraSelectedValues.clear();
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: Center(
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
        });
  }

  selectedPitchDetails(BuildContext parentContent, int index,
      String turfPitchId, String name, List<String>? sportIds) {
    RxList<String> selectedValues = <String>[].obs;
    RxList<String> extraSelectedValues = <String>[].obs;

    variable.pitchController.value.text = name;

    extraSelectedValues.addAll(sportIds!);

    // ignore: unused_local_variable
    var turfSportsList = sportsList.map((sport) {
      sport.isSelected.value = sportIds!.contains(sport.sId);
      if (sport.isSelected.value) {
        selectedValues.add(sport.name.toString());
      }
      return sport.name!;
    }).toList();

    showDialog(
        context: parentContent,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.r,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 235.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.h, left: 16.w, bottom: 8.h),
                    child: Text(
                      "Pitch name",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 11.sp,
                          color: greyColor.withOpacity(0.75),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => AppTextFiled(
                                    controller: variable.pitchController.value,
                                    focusNode: variable.pitchFocusNode.value,
                                    selected: variable.pitchSelected.value,
                                    lebel: "name",
                                    onSubmitt: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        variable.pitchSelected.value = false;
                                        return "this is required";
                                      } else if (variable.pitchController.value
                                                  .text.length <
                                              4 &&
                                          value.length < 4) {
                                        variable.pitchSelected.value = false;
                                        return 'Please enter a valid street';
                                      }
                                      variable.pitchSelected.value = true;
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, bottom: 8.h),
                                  child: Text(
                                    "Pitch sport",
                                    style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 11.sp,
                                        color: greyColor.withOpacity(0.75),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16.w, left: 16.w),
                                  child: SportListFormField(
                                    sportList: sportsList,
                                    selectedValues: selectedValues,
                                    extraSelectedValues: sportIds!,
                                    onChanged: (List<String> values,
                                        List<String> extraValues) {
                                      selectedValues.value = values;
                                      sportIds = extraValues;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
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
                            variable.turfPitchSelectList[index] =
                                TurfPitchDetail(
                                    sId: turfPitchId.toString(),
                                    name: variable.pitchController.value.text,
                                    sportIds: sportIds); //{
                            //   "id": turfPitchId,
                            //   "name": variable.pitchController.value.text
                            //       .toString(),
                            //   "sportIds": sportIds
                            // };
                            Navigator.of(context).pop();
                            variable.pitchController.value.text = "";
                            //  extraSelectedValues.clear();
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
        });
  }

  tabletSelectedPitchDetails(BuildContext parentContent, int index,
      String turfPitchId, String name, List<String>? sportIds) {
    RxList<String> selectedValues = <String>[].obs;
    RxList<String> extraSelectedValues = <String>[].obs;

    variable.pitchController.value.text = name;

    extraSelectedValues.addAll(sportIds!);

    // ignore: unused_local_variable
    var turfSportsList = sportsList.map((sport) {
      sport.isSelected.value = sportIds!.contains(sport.sId);
      if (sport.isSelected.value) {
        selectedValues.add(sport.name.toString());
      }
      return sport.name!;
    }).toList();

    showDialog(
        context: parentContent,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.r,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 235.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.h, left: 16.w, bottom: 8.h),
                    child: Text(
                      "Pitch name",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 11.sp,
                          color: greyColor.withOpacity(0.75),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => TabletAppTextFiled(
                                    controller: variable.pitchController.value,
                                    focusNode: variable.pitchFocusNode.value,
                                    selected: variable.pitchSelected.value,
                                    lebel: "name",
                                    onSubmitt: (value) {},
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        variable.pitchSelected.value = false;
                                        return "this is required";
                                      } else if (variable.pitchController.value
                                                  .text.length <
                                              4 &&
                                          value.length < 4) {
                                        variable.pitchSelected.value = false;
                                        return 'Please enter a valid street';
                                      }
                                      variable.pitchSelected.value = true;
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, bottom: 8.h),
                                  child: Text(
                                    "Pitch sport",
                                    style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 11.sp,
                                        color: greyColor.withOpacity(0.75),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 16.w, left: 16.w),
                                  child: SportListFormField(
                                    sportList: sportsList,
                                    selectedValues: selectedValues,
                                    extraSelectedValues: sportIds!,
                                    onChanged: (List<String> values,
                                        List<String> extraValues) {
                                      selectedValues.value = values;
                                      sportIds = extraValues;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
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
                            child: Center(
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
                            variable.turfPitchSelectList[index] =
                                TurfPitchDetail(
                                    sId: turfPitchId,
                                    name: variable.pitchController.value.text,
                                    sportIds: sportIds); //{
                            //   "id": turfPitchId,
                            //   "name": variable.pitchController.value.text
                            //       .toString(),
                            //   "sportIds": sportIds
                            // };
                            Navigator.of(context).pop();
                            variable.pitchController.value.text = "";
                            //  extraSelectedValues.clear();
                          },
                          child: Container(
                            height: 30.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: whiteColor,
                              border: Border.all(color: greyBColor, width: 1),
                            ),
                            child: Center(
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
        });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
    }
    return _selectedTime;
  }

  // String _formatTime(TimeOfDay time) {
  //   return "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  // }

  String _formatTime(TimeOfDay time) {
  String hourString = (time.hour % 12 == 0) ? '12' : (time.hour % 12).toString().padLeft(2, '0');
  String minuteString = time.minute.toString().padLeft(2, '0');
  String period = (time.hour >= 12) ? 'PM' : 'AM';

  return "$hourString:$minuteString $period";
}


  address(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 323.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller: variable.streetController.value,
                                focusNode: variable.streetFocusNode.value,
                                selected: variable.streetSelected.value,
                                lebel: "line1",
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.subLocalityFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.streetSelected.value = false;
                                    return "this is required";
                                  } else if (variable.streetController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.streetSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.streetSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.streetSelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller:
                                    variable.subLocalityController.value,
                                focusNode: variable.subLocalityFocusNode.value,
                                selected: variable.subLocalitySelected.value,
                                lebel: "line2",
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.localityFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.subLocalitySelected.value = false;
                                    return "this is required";
                                  } else if (variable.subLocalityController
                                              .value.text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.subLocalitySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.subLocalitySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height:
                                    variable.subLocalitySelected.value == true
                                        ? 20.h
                                        : 0.h,
                              ),
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller: variable.localityController.value,
                                focusNode: variable.localityFocusNode.value,
                                selected: variable.localitySelected.value,
                                lebel: "city",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.stateFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.localitySelected.value = false;
                                    return "this is required";
                                  } else if (variable.localityController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.localitySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.localitySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.localitySelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller: variable.stateController.value,
                                focusNode: variable.stateFocusNode.value,
                                selected: variable.stateSelected.value,
                                lebel: "state",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.countryFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.stateSelected.value = false;
                                    return "this is required";
                                  } else if (variable.stateController.value.text
                                              .length <
                                          4 &&
                                      value.length < 4) {
                                    variable.stateSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.stateSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.stateSelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller: variable.countryController.value,
                                focusNode: variable.countryFocusNode.value,
                                selected: variable.countrySelected.value,
                                lebel: "country",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.postalCodeFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.countrySelected.value = false;
                                    return "this is required";
                                  } else if (variable.countryController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.countrySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.countrySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.countrySelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => AppTextFiled(
                                controller: variable.postalCodeController.value,
                                focusNode: variable.postalCodeFocusNode.value,
                                selected: variable.postalCodeSelected.value,
                                lebel: "postalCode",
                                onSubmitt: (value) {
                                  // FocusScope.of(context).requestFocus(
                                  //     variable.stateFocusNode.value);
                                },
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.postalCodeSelected.value = false;
                                    return "this is required";
                                  } else if (variable.postalCodeController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.postalCodeSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.postalCodeSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height:
                                    variable.postalCodeSelected.value == true
                                        ? 20.h
                                        : 0.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
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
                            variable.streetController.value.text =
                                variable.street.value;
                            variable.countryController.value.text =
                                variable.country.value;
                            variable.subLocalityController.value.text =
                                variable.subLocality.value;
                            variable.localityController.value.text =
                                variable.locality.value;
                            variable.postalCodeController.value.text =
                                variable.postalCode.value;
                            variable.stateController.value.text =
                                variable.state.value;
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
                                "Update",
                                //  style: deteleAccountButton_text_style,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  )
                ],
              ),
            ),
          );
        });
  }

  tabletAddress(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 450.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r), color: whiteColor),
              width: 330.w,
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller: variable.streetController.value,
                                focusNode: variable.streetFocusNode.value,
                                selected: variable.streetSelected.value,
                                lebel: "line1",
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.subLocalityFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.streetSelected.value = false;
                                    return "this is required";
                                  } else if (variable.streetController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.streetSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.streetSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.streetSelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller:
                                    variable.subLocalityController.value,
                                focusNode: variable.subLocalityFocusNode.value,
                                selected: variable.subLocalitySelected.value,
                                lebel: "line2",
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.localityFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.subLocalitySelected.value = false;
                                    return "this is required";
                                  } else if (variable.subLocalityController
                                              .value.text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.subLocalitySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.subLocalitySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height:
                                    variable.subLocalitySelected.value == true
                                        ? 20.h
                                        : 0.h,
                              ),
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller: variable.localityController.value,
                                focusNode: variable.localityFocusNode.value,
                                selected: variable.localitySelected.value,
                                lebel: "city",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.stateFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.localitySelected.value = false;
                                    return "this is required";
                                  } else if (variable.localityController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.localitySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.localitySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.localitySelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller: variable.stateController.value,
                                focusNode: variable.stateFocusNode.value,
                                selected: variable.stateSelected.value,
                                lebel: "state",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.countryFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.stateSelected.value = false;
                                    return "this is required";
                                  } else if (variable.stateController.value.text
                                              .length <
                                          4 &&
                                      value.length < 4) {
                                    variable.stateSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.stateSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.stateSelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller: variable.countryController.value,
                                focusNode: variable.countryFocusNode.value,
                                selected: variable.countrySelected.value,
                                lebel: "country",
                                enable: false,
                                onSubmitt: (value) {
                                  FocusScope.of(context).requestFocus(
                                      variable.postalCodeFocusNode.value);
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.countrySelected.value = false;
                                    return "this is required";
                                  } else if (variable.countryController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.countrySelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.countrySelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: variable.countrySelected.value == true
                                    ? 20.h
                                    : 0.h,
                              ),
                            ),
                            Obx(
                              () => TabletAppTextFiled(
                                controller: variable.postalCodeController.value,
                                focusNode: variable.postalCodeFocusNode.value,
                                selected: variable.postalCodeSelected.value,
                                lebel: "postalCode",
                                onSubmitt: (value) {
                                  // FocusScope.of(context).requestFocus(
                                  //     variable.stateFocusNode.value);
                                },
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    variable.postalCodeSelected.value = false;
                                    return "this is required";
                                  } else if (variable.postalCodeController.value
                                              .text.length <
                                          4 &&
                                      value.length < 4) {
                                    variable.postalCodeSelected.value = false;
                                    return 'Please enter a valid street';
                                  }
                                  variable.postalCodeSelected.value = true;
                                  return null;
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height:
                                    variable.postalCodeSelected.value == true
                                        ? 20.h
                                        : 0.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
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
                            child: Center(
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
                            variable.streetController.value.text =
                                variable.street.value;
                            variable.countryController.value.text =
                                variable.country.value;
                            variable.subLocalityController.value.text =
                                variable.subLocality.value;
                            variable.localityController.value.text =
                                variable.locality.value;
                            variable.postalCodeController.value.text =
                                variable.postalCode.value;
                            variable.stateController.value.text =
                                variable.state.value;
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
                            child: Center(
                              child: Text(
                                "Update",
                                style: TabletAppstyle.deteleButton_text_style,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  )
                ],
              ),
            ),
          );
        });
  }
}

    // Obx(
                                          //   () => AppTextFiled(
                                          //     controller: variable
                                          //         .turf_HourController.value,
                                          //     focusNode: variable
                                          //         .turf_HourFocusNode.value,
                                          //     selected: variable
                                          //         .turf_HourSelected.value,
                                          //     lebel: "Open Hour",
                                          //     keyboardType:
                                          //         TextInputType.number,
                                          //     onSubmitt: (value) {
                                          //       FocusScope.of(context)
                                          //           .requestFocus(variable
                                          //               .turf_PerHourFocusNode
                                          //               .value);
                                          //     },
                                          //     validator: (value) {
                                          //       if (value!.isEmpty) {
                                          //         variable.turf_HourSelected
                                          //             .value = false;
                                          //         return "Please Enter your address";
                                          //       } else if (variable
                                          //                   .turf_HourController
                                          //                   .value
                                          //                   .text
                                          //                   .length <
                                          //               2 &&
                                          //           value.length < 2) {
                                          //         variable.turf_HourSelected
                                          //             .value = false;
                                          //         return "Please enter 4 charter";
                                          //       } else {
                                          //         variable.turf_HourSelected
                                          //             .value = true;
                                          //         return null;
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                          // Obx(
                                          //   () => SizedBox(
                                          //     height: variable
                                          //                 .turf_HourSelected
                                          //                 .value ==
                                          //             true
                                          //         ? 16.h
                                          //         : 0.h,
                                          //   ),
                                          // ),


     // final response = await api
      //     .apiPostCall(context, "owner/upload-image", body: {}, headers: {
      //   "Authorization": "Bearer $authToken",
      //   'Content-type': 'application/json',
      //   "app-version": "1.0",
      //   "app-platform": Platform.isIOS ? "ios" : "android"
      // });
      // ApiResponse responseData =
      //     ApiResponse.fromJson(res as Map<String, dynamic>);
      // if (responseData.responseCode == 200) {

      //   // List<dynamic> sportListJson = responseData.data!["sportList"];
      //   // //  SportList
      //   // variable.turfSportsList.value =
      //   //     sportListJson.map((json) => SportList.fromJson(json)).toList();

      // } else if (responseData.responseCode == 401) {

      // } else {}

    // try {
    //   final response =
    //       await api.apiPostCall(context, "owner/turf-add-update", body: {
    //     "name": variable.turf_NameController.value.text.toString(),
    //     "rate": variable.turf_PerHourController.value.text.toString(),
    //     "address": {
    //       "line1": variable.street.toString(),
    //       "line2": variable.locality.toString(),
    //       "country": variable.country.toString(),
    //       "state": variable.state.toString(),
    //       "city": variable.subLocality.toString(),
    //       "pin_code": variable.postalCode.toString()
    //     },
    //     "area": variable.turf_AreaSqController.value.text.toString(),
    //     "latitude": variable.lat.toString(),
    //     "longitude": variable.lng.toString(),
    //     "sportIds": variable.turfSportsSelectList,
    //     "facilityIds": variable.turfFacilitySelectList,
    //     "about": variable.turf_AboutController.value.text.toString(),
    //     "openingTime": "12:00 AM",
    //     "closingTime": "11:59 PM",
    //     "turfPitchList": variable.turfPitchSelectList,
    //     "images": variable.uploadImageData
    //   }, headers: {
    //     'Content-type': 'application/json',
    //     "Authorization": "Bearer $authToken",
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   });
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     loading.value = false;
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (con) => const TurfGorundsScreen()));
    //     // List<dynamic> sportListJson = responseData.data!["facilityList"];
    //     // //  SportList
    //     // variable.facilityList.value =
    //     //     sportListJson.map((json) => SportList.fromJson(json)).toList();

    //   } else if (responseData.responseCode == 401) {

    //     loading.value = false;

    //   } else {

    //     loading.value = false;
    //   }
    // } catch (e) {
    //   loading.value = false;

    // }