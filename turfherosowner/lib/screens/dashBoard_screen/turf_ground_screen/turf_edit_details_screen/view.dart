// ignore_for_file: prefer_final_fields, use_build_context_synchronously, must_be_immutable, prefer_const_constructors, deprecated_member_use, empty_catches
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:http/http.dart' as http;
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

class TurfEditDetailsScreen extends StatefulWidget {
  TurfList turfGroundDetailsScreen;
  TurfEditDetailsScreen({required this.turfGroundDetailsScreen, super.key});

  @override
  State<TurfEditDetailsScreen> createState() => _TurfEditDetailsScreenState();
}

class _TurfEditDetailsScreenState extends State<TurfEditDetailsScreen> {
  final variable = Get.put(EditTurfGroundDataViewModel());

  late SharedPreferences prefs;
  final api = ApiService();
  var _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String authToken = "";

  TimeOfDay _selectedTime = TimeOfDay.now();

  RxList<SportList> sportsList = <SportList>[].obs;
  RxList<SportList> facilityList = <SportList>[].obs;

  RxList<SportList> turfSportsList = <SportList>[].obs;
  RxList<SportList> turfFacilityList = <SportList>[].obs;

  RxList<String> turfSportsSelectList = <String>[].obs;
  RxList<String> turfFacilitySelectList = <String>[].obs;

  List<Map<String, dynamic>> pitchMaps = [];

  final List<String> currencies = [
    'Food',
    'Transport',
    'Utilities',
    'Entertainment'
  ];
  @override
  void dispose() {
    Get.delete<EditTurfGroundDataViewModel>();

    sportsList.clear();
    facilityList.clear();

    turfSportsList.clear();
    turfFacilityList.clear();

    turfSportsSelectList.clear();
    turfFacilitySelectList.clear();
    pitchMaps.clear();
    super.dispose();
  }

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

  void fetchSportsList() async {
    List<SportList> loadedList = await loadModelList();
    sportsList.addAll(loadedList);

    turfSportsList.value = sportsList.map((sport) {
      sport.isSelected.value =
          widget.turfGroundDetailsScreen.sportIds!.contains(sport.sId);
      if (sport.isSelected.value) {
        turfSportsSelectList.add(sport.sId.toString());
      }
      return sport;
    }).toList(); // Assign the loaded list to the RxList
  }

  void fetchFacilityList() async {
    List<SportList> loadedList = await loadFacilityModelList();
    facilityList.addAll(loadedList);
    turfFacilityList.value = facilityList.map((facility) {
      facility.isSelected.value =
          widget.turfGroundDetailsScreen.facilityIds!.contains(facility.sId);
      if (facility.isSelected.value) {
        turfFacilitySelectList.add(facility.sId.toString());
      }
      return facility;
    }).toList(); // Assign the loaded list to the RxList
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getTextField();
    getAdress();
    getImage();
    getPitch();
    fetchSportsList();
    fetchFacilityList();
    getTime();
    getDayWisePrice();
  }

  getDayWisePrice() {
    variable.mondayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.monday.toString();
    variable.tuesdayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.tuesday.toString();
    variable.wednesdayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.wednesday.toString();
    variable.thursdayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.thursday.toString();
    variable.fridayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.friday.toString();
    variable.saturdayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.saturday.toString();
    variable.sundayController.value.text =
        widget.turfGroundDetailsScreen.rateDayWise!.sunday.toString();
  }

  getTime() {
    variable.startDate.value = widget.turfGroundDetailsScreen.openingTime!;
    variable.endDate.value = widget.turfGroundDetailsScreen.closingTime!;
  }

  getImage() {
    variable.uploadImageData.addAll(widget.turfGroundDetailsScreen.images!);
  }

  getTextField() {
    variable.turf_NameController.value.text =
        widget.turfGroundDetailsScreen.name!;
    variable.turf_AreaSqController.value.text =
        widget.turfGroundDetailsScreen.area.toString();
    variable.turf_PerHourController.value.text =
        widget.turfGroundDetailsScreen.advanceBookingAllowedWeeks.toString();
    variable.turf_AboutController.value.text =
        widget.turfGroundDetailsScreen.about!;
  }

  getAdress() {
    variable.turf_LocationController.value.text =
        "${widget.turfGroundDetailsScreen.address!.line1},${widget.turfGroundDetailsScreen.address!.line2},${widget.turfGroundDetailsScreen.address!.city},${widget.turfGroundDetailsScreen.address!.state},${widget.turfGroundDetailsScreen.address!.country},${widget.turfGroundDetailsScreen.address!.pinCode}";
    variable.street.value = widget.turfGroundDetailsScreen.address!.line1!;
    variable.locality.value = widget.turfGroundDetailsScreen.address!.line2!;
    variable.country.value = widget.turfGroundDetailsScreen.address!.country!;
    variable.state.value = widget.turfGroundDetailsScreen.address!.state!;
    variable.subLocality.value = widget.turfGroundDetailsScreen.address!.city!;
    variable.postalCode.value =
        widget.turfGroundDetailsScreen.address!.pinCode!;
    variable.lat.value =
        widget.turfGroundDetailsScreen.coordinates!.coordinates![0].toString();
    variable.lng.value =
        widget.turfGroundDetailsScreen.coordinates!.coordinates![1].toString();

    variable.streetController.value.text =
        widget.turfGroundDetailsScreen.address!.line1!;
    variable.countryController.value.text =
        widget.turfGroundDetailsScreen.address!.country!;
    variable.subLocalityController.value.text =
        widget.turfGroundDetailsScreen.address!.city!;
    variable.localityController.value.text =
        widget.turfGroundDetailsScreen.address!.line2!;
    variable.postalCodeController.value.text =
        widget.turfGroundDetailsScreen.address!.pinCode!;
    variable.stateController.value.text =
        widget.turfGroundDetailsScreen.address!.state!;
  }

  getPitch() {
    addTurfPitchDetails(widget.turfGroundDetailsScreen.turfPitchDetail);
    getPitchList();
    pitchMaps = variable.turfPitchSelectList.map((item) {
      return {
        'id': "${item.sId}",
        'name': "${item.name}",
        'sportIds': item.sportIds,
      };
    }).toList();
  }

  void addTurfPitchDetails(List<TurfPitchDetail>? turfPitchDetails) {
    variable.turfPitchSelectList
        .addAll(widget.turfGroundDetailsScreen.turfPitchDetail!);
  }

  getPitchList() {
    for (int i = 0; i < variable.turfPitchSelectList.length; i++) {
      variable.turfPitchSelectList[i] = TurfPitchDetail(
          sId: variable.turfPitchSelectList[i].sId,
          name: variable.turfPitchSelectList[i].name,
          sportIds: variable.turfPitchSelectList[i].sportIds); //{
      //   "id": variable.turfPitchSelectList[i]["id"].toString(),
      //   "name": variable.turfPitchSelectList[i]["name"].toString(),
      //   "sportIds": variable.turfPitchSelectList[i]["sportIds"]
      // };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayLoaderWithAppIcon(
          isLoading: variable.isLoading.value,
          circularProgressColor: appColor,
          appIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/loader_image.png",
              fit: BoxFit.fill,
            ),
          ),
          child: WillPopScope(
            onWillPop: () {
              Get.delete<EditTurfGroundDataViewModel>();
              sportsList.clear();
              facilityList.clear();

              turfSportsList.clear();
              turfFacilityList.clear();

              turfSportsSelectList.clear();
              turfFacilitySelectList.clear();
              pitchMaps.clear();
              Navigator.pop(context);
              return Future.value(false);
            },
            child: ScreenUtil().screenWidth < 600
                ? moblieView(context)
                : tabletView(context),
          )),
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
                                ? Image.network(
                                    "${ApiService.baseUrl}/${widget.turfGroundDetailsScreen.images!.isEmpty ? "" : widget.turfGroundDetailsScreen.images![0]}",
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(variable.image.value!.path),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 175.h,
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
                          onTap: () async {
                            _showModalBottomListSheet(context);
                            // var getImges = await uploadPhotoData(
                            //     variable.image.value!.path);
                            // var parsedResponse = json.decode(getImges);
                            // variable.uploadImageData.add(
                            //     parsedResponse["data"]["imageDetail"]
                            //             ["name"]
                            //         .toString());
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
                                          child: Image.network(
                                            "${ApiService.baseUrl}/${variable.uploadImageData[index].toString()}",
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
                                            Timer(Duration(seconds: 1), () {
                                              deletUploadData(variable
                                                  .uploadImageData[index]);
                                              variable.uploadImageData
                                                  .removeAt(index);
                                            });
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
                                itemCount: variable.uploadImageData.length),
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
                        left: 16.w,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            sportsList.clear();
                            facilityList.clear();

                            turfSportsList.clear();
                            turfFacilityList.clear();

                            turfSportsSelectList.clear();
                            turfFacilitySelectList.clear();
                            pitchMaps.clear();
                            Get.delete<EditTurfGroundDataViewModel>();
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
                              "Edit Detail",
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
                                    horizontal: 16.r,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => CustomSelcetSport(
                                        image: turfSportsList[index].images!,
                                        title: turfSportsList[index].name!,
                                        onTap: () {
                                          turfSportsList[index]
                                                  .isSelected
                                                  .value =
                                              !turfSportsList[index]
                                                  .isSelected
                                                  .value;

                                          turfSportsList[index].isSelected.value
                                              ? turfSportsSelectList.add(
                                                  sportsList[index]
                                                      .sId!
                                                      .toString())
                                              : turfSportsSelectList.remove(
                                                  sportsList[index]
                                                      .sId!
                                                      .toString());
                                        },
                                        selected: turfSportsList[index]
                                            .isSelected
                                            .value,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 8.w,
                                    );
                                  },
                                  itemCount: turfSportsList.length),
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
                                  // Obx(
                                  //   () => AppTextFiled(
                                  //     controller: variable
                                  //         .turf_HourController.value,
                                  //     focusNode: variable
                                  //         .turf_HourFocusNode.value,
                                  //     selected: variable
                                  //         .turf_HourSelected.value,
                                  //     lebel: "Open Hour",
                                  //     keyboardType: TextInputType.number,
                                  //     onSubmitt: (value) {
                                  //       FocusScope.of(context).requestFocus(
                                  //           variable
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
                                  //               4 &&
                                  //           value.length < 4) {
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
                                  //     height: variable.turf_HourSelected
                                  //                 .value ==
                                  //             true
                                  //         ? 16.h
                                  //         : 0.h,
                                  //   ),
                                  // ),
                                  advamceBookingTextField(context),
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
                                  timeTextField(context),
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
                                      mondayTextField(context),
                                      tuesdayTextField(context),
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
                                      wednesdayTextField(context),
                                      thursdayTextField(context),
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
                                      fridayTextField(context),
                                      saturdayTextField(context),
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
                                  Row(
                                    children: [
                                      sundayTextField(),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.sundaySelected.value == true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
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
                                      padding: EdgeInsets.only(left: 36.w),
                                      child: SizedBox(
                                        height: 170.h,
                                        child: Obx(
                                          () => ListView.separated(
                                              padding:
                                                  EdgeInsets.only(top: 5.h),
                                              itemBuilder: (context, index) {
                                                return Obx(
                                                  () => CustomRadioButton(
                                                      title: turfFacilityList[
                                                              index]
                                                          .name!,
                                                      onChanged: () {
                                                        turfFacilityList[index]
                                                                .isSelected
                                                                .value =
                                                            !turfFacilityList[
                                                                    index]
                                                                .isSelected
                                                                .value;

                                                        turfFacilityList[index]
                                                                .isSelected
                                                                .value
                                                            ? turfFacilitySelectList
                                                                .add(facilityList[
                                                                        index]
                                                                    .sId!
                                                                    .toString())
                                                            : turfFacilitySelectList
                                                                .remove(facilityList[
                                                                        index]
                                                                    .sId!
                                                                    .toString());
                                                      },
                                                      selected:
                                                          turfFacilityList[
                                                                  index]
                                                              .isSelected
                                                              .value),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: 8.h,
                                                );
                                              },
                                              itemCount:
                                                  turfFacilityList.length),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h),
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
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                                        margin: EdgeInsets.only(
                                                            top: 5.h,
                                                            bottom: 5.h,
                                                            right: 5.w),
                                                        height: 40.h,
                                                        child:
                                                            SelectPitchDetails(
                                                          name:
                                                              "${variable.turfPitchSelectList[index].name}",
                                                          onTap: () {
                                                            selectedPitchDetails(
                                                                context,
                                                                index,
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sId
                                                                    .toString(),
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sportIds);
                                                          },
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: -0,
                                                        right: -1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            deletePitchDetails(
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sId!);
                                                            variable.turfPitchSelectList.removeWhere((pitch) =>
                                                                pitch.name ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .name &&
                                                                pitch.sId ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .sId &&
                                                                pitch.sportIds ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .sportIds);
                                                            // pitchMaps.removeWhere((pitch)=>pitch["name"] == variable.turfPitchSelectList[index].name &&
                                                            // pitch["id"] ==
                                                            //     variable.turfPitchSelectList[index].sId &&
                                                            // pitch["sportIds"] == variable.turfPitchSelectList[index].sportIds);
                                                          },
                                                          child: Container(
                                                            height: 15.h,
                                                            width: 15.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(10
                                                                            .r),
                                                                color:
                                                                    redSColor,
                                                                border: Border.all(
                                                                    color:
                                                                        whiteColor,
                                                                    width: 1)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    whiteColor,
                                                                size: 10.h,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(
                                                    width: 8.w,
                                                  );
                                                },
                                                itemCount: variable
                                                    .turfPitchSelectList
                                                    .length),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() => aboutTextField()),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_AboutSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  CustomeButton(
                                      title: "Update",
                                      onTap: () {
                                        pitchMaps.clear();

                                        pitchMaps = variable.turfPitchSelectList
                                            .map((item) {
                                          return {
                                            'id': item.sId,
                                            'name': item.name,
                                            'sportIds': item.sportIds,
                                          };
                                        }).toList();

                                        if (_formKey.currentState!.validate()) {
                                          if (variable
                                              .uploadImageData.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select image");
                                          } else if (turfFacilityList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select facility");
                                          } else if (turfSportsList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select sport");
                                          } else if (variable
                                              .turfPitchSelectList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select Pitch");
                                          } else {
                                            updateData();
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Please fillup Details");
                                        }
                                      }
                                      //  Get.toNamed(turfBooking_screen);
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (ci) => TurfBookingScreen(
                                      //             turfListDetails:
                                      //                 widget.turfListDetails)));
                                      ),
                                  SizedBox(
                                    height: 80.h,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  )
                                ],
                              )),
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
                                ? Image.network(
                                    "${ApiService.baseUrl}/${widget.turfGroundDetailsScreen.images!.isEmpty ? "" : widget.turfGroundDetailsScreen.images![0]}",
                                    fit: BoxFit.cover,
                                  )
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
                          onTap: () async {
                            _showModalBottomListSheet(context);
                            // var getImges = await uploadPhotoData(
                            //     variable.image.value!.path);
                            // var parsedResponse = json.decode(getImges);
                            // variable.uploadImageData.add(
                            //     parsedResponse["data"]["imageDetail"]
                            //             ["name"]
                            //         .toString());
                          },
                          child: Container(
                            width: 50.w,
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
                                        width: 50.w,
                                        height: 60.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.network(
                                            "${ApiService.baseUrl}/${variable.uploadImageData[index].toString()}",
                                            fit: BoxFit.cover,
                                            height: 55.h,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -0.h,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Timer(Duration(seconds: 1), () {
                                              deletUploadData(variable
                                                  .uploadImageData[index]);
                                              variable.uploadImageData
                                                  .removeAt(index);
                                            });
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
                                itemCount: variable.uploadImageData.length),
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
                        left: 16.w,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            sportsList.clear();
                            facilityList.clear();

                            turfSportsList.clear();
                            turfFacilityList.clear();

                            turfSportsSelectList.clear();
                            turfFacilitySelectList.clear();
                            pitchMaps.clear();
                            Get.delete<EditTurfGroundDataViewModel>();
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
                              "Edit Detail",
                              style: TabletAppstyle.title_style,
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
                              style: TabletAppstyle.dLocationBold_text_style,
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                            width: double.maxFinite,
                            child: Obx(
                              () => ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => TabletCustomSelcetSport(
                                        image: turfSportsList[index].images!,
                                        title: turfSportsList[index].name!,
                                        onTap: () {
                                          turfSportsList[index]
                                                  .isSelected
                                                  .value =
                                              !turfSportsList[index]
                                                  .isSelected
                                                  .value;

                                          turfSportsList[index].isSelected.value
                                              ? turfSportsSelectList.add(
                                                  sportsList[index]
                                                      .sId!
                                                      .toString())
                                              : turfSportsSelectList.remove(
                                                  sportsList[index]
                                                      .sId!
                                                      .toString());
                                        },
                                        selected: turfSportsList[index]
                                            .isSelected
                                            .value,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 8.w,
                                    );
                                  },
                                  itemCount: turfSportsList.length),
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
                                  tabletTurfAreaTextField(context),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_AreaSqSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  // Obx(
                                  //   () => AppTextFiled(
                                  //     controller: variable
                                  //         .turf_HourController.value,
                                  //     focusNode: variable
                                  //         .turf_HourFocusNode.value,
                                  //     selected: variable
                                  //         .turf_HourSelected.value,
                                  //     lebel: "Open Hour",
                                  //     keyboardType: TextInputType.number,
                                  //     onSubmitt: (value) {
                                  //       FocusScope.of(context).requestFocus(
                                  //           variable
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
                                  //               4 &&
                                  //           value.length < 4) {
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
                                  //     height: variable.turf_HourSelected
                                  //                 .value ==
                                  //             true
                                  //         ? 16.h
                                  //         : 0.h,
                                  //   ),
                                  // ),
                                  tabletAdvamceBookingTextField(context),
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
                                  tabletTimeTextField(context),
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
                                      tabletMondayTextField(context),
                                      tabletTuesdayTextField(context),
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
                                      tabletWednesdayTextField(context),
                                      tabletThursdayTextField(context),
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
                                      tabletFridayTextField(context),
                                      tabletSaturdayTextField(context),
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
                                  Row(
                                    children: [
                                      tabletSundayTextField(),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.sundaySelected.value == true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
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
                                      padding: EdgeInsets.only(left: 36.w),
                                      child: SizedBox(
                                        height: 190.h,
                                        child: Obx(
                                          () => ListView.separated(
                                              padding: EdgeInsets.only(
                                                  top: 6.h, bottom: 6.h),
                                              itemBuilder: (context, index) {
                                                return Obx(
                                                  () => TabletCustomRadioButton(
                                                      title: turfFacilityList[
                                                              index]
                                                          .name!,
                                                      onChanged: () {
                                                        turfFacilityList[index]
                                                                .isSelected
                                                                .value =
                                                            !turfFacilityList[
                                                                    index]
                                                                .isSelected
                                                                .value;

                                                        turfFacilityList[index]
                                                                .isSelected
                                                                .value
                                                            ? turfFacilitySelectList
                                                                .add(facilityList[
                                                                        index]
                                                                    .sId!
                                                                    .toString())
                                                            : turfFacilitySelectList
                                                                .remove(facilityList[
                                                                        index]
                                                                    .sId!
                                                                    .toString());
                                                      },
                                                      selected:
                                                          turfFacilityList[
                                                                  index]
                                                              .isSelected
                                                              .value),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: 2.h,
                                                );
                                              },
                                              itemCount:
                                                  turfFacilityList.length),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.w, bottom: 8.h),
                                    child: Text(
                                      "Select Pitch",
                                      style: TabletAppstyle
                                          .dLocationBold_text_style,
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
                                              bottom: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: Color(0xffEFEFEF)),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                                        margin: EdgeInsets.only(
                                                            top: 5.h,
                                                            bottom: 5.h,
                                                            right: 5.w),
                                                        height: 40.h,
                                                        child:
                                                            SelectPitchDetails(
                                                          name:
                                                              "${variable.turfPitchSelectList[index].name}",
                                                          onTap: () {
                                                            tabletSelectedPitchDetails(
                                                                context,
                                                                index,
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sId
                                                                    .toString(),
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sportIds);
                                                          },
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: -0,
                                                        right: -1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            deletePitchDetails(
                                                                variable
                                                                    .turfPitchSelectList[
                                                                        index]
                                                                    .sId!);
                                                            variable.turfPitchSelectList.removeWhere((pitch) =>
                                                                pitch.name ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .name &&
                                                                pitch.sId ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .sId &&
                                                                pitch.sportIds ==
                                                                    variable
                                                                        .turfPitchSelectList[
                                                                            index]
                                                                        .sportIds);
                                                            // pitchMaps.removeWhere((pitch)=>pitch["name"] == variable.turfPitchSelectList[index].name &&
                                                            // pitch["id"] ==
                                                            //     variable.turfPitchSelectList[index].sId &&
                                                            // pitch["sportIds"] == variable.turfPitchSelectList[index].sportIds);
                                                          },
                                                          child: Container(
                                                            height: 16.h,
                                                            width: 12.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(10
                                                                            .r),
                                                                color:
                                                                    redSColor,
                                                                border: Border.all(
                                                                    color:
                                                                        whiteColor,
                                                                    width: 1)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    whiteColor,
                                                                size: 10.h,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(
                                                    width: 8.w,
                                                  );
                                                },
                                                itemCount: variable
                                                    .turfPitchSelectList
                                                    .length),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() => tabletAboutTextField()),
                                  Obx(
                                    () => SizedBox(
                                      height:
                                          variable.turf_AboutSelected.value ==
                                                  true
                                              ? 16.h
                                              : 0.h,
                                    ),
                                  ),
                                  TabletCustomeButton(
                                      title: "Update",
                                      onTap: () {
                                        pitchMaps.clear();

                                        pitchMaps = variable.turfPitchSelectList
                                            .map((item) {
                                          return {
                                            'id': item.sId,
                                            'name': item.name,
                                            'sportIds': item.sportIds,
                                          };
                                        }).toList();

                                        if (_formKey.currentState!.validate()) {
                                          if (variable
                                              .uploadImageData.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select image");
                                          } else if (turfFacilityList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select facility");
                                          } else if (turfSportsList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select sport");
                                          } else if (variable
                                              .turfPitchSelectList.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Please select Pitch");
                                          } else {
                                            updateData();
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Please fillup Details");
                                        }
                                      }
                                      //  Get.toNamed(turfBooking_screen);
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (ci) => TurfBookingScreen(
                                      //             turfListDetails:
                                      //                 widget.turfListDetails)));
                                      ),
                                  SizedBox(
                                    height: 80.h,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  AppBigTextFiled aboutTextField() {
    return AppBigTextFiled(
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
    );
  }

  TabletAppBigTextFiled tabletAboutTextField() {
    return TabletAppBigTextFiled(
      lebel: "About",
      controller: variable.turf_AboutController.value,
      focusNode: variable.turf_AboutFocusNode.value,
      selected: variable.turf_AboutSelected.value,
      maxline: 6,
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
    );
  }

  Expanded mondayTextField(BuildContext context) {
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

  Expanded tabletMondayTextField(BuildContext context) {
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

  Expanded tuesdayTextField(BuildContext context) {
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

  Expanded tabletTuesdayTextField(BuildContext context) {
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

  Expanded wednesdayTextField(BuildContext context) {
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

  Expanded tabletWednesdayTextField(BuildContext context) {
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

  Expanded thursdayTextField(BuildContext context) {
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

  Expanded tabletThursdayTextField(BuildContext context) {
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

  Expanded fridayTextField(BuildContext context) {
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

  Expanded tabletFridayTextField(BuildContext context) {
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

  Expanded saturdayTextField(BuildContext context) {
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

  Expanded tabletSaturdayTextField(BuildContext context) {
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

  Expanded sundayTextField() {
    return Expanded(
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
    );
  }

  Expanded tabletSundayTextField() {
    return Expanded(
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
    );
  }

  Padding timeTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
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
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
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

  Padding tabletTimeTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
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
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
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

  Obx advamceBookingTextField(BuildContext context) {
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
            // } else if (variable
            //             .turf_PerHourController
            //             .value
            //             .text
            //             .length <
            //         1 &&
            //     value.length < 1) {
            //   variable
            //       .turf_PerHourSelected
            //       .value = false;
            //   return "Please enter 1 digit";
          } else {
            variable.turf_PerHourSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx tabletAdvamceBookingTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
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
            // } else if (variable
            //             .turf_PerHourController
            //             .value
            //             .text
            //             .length <
            //         1 &&
            //     value.length < 1) {
            //   variable
            //       .turf_PerHourSelected
            //       .value = false;
            //   return "Please enter 1 digit";
          } else {
            variable.turf_PerHourSelected.value = true;
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

  Obx tabletTurfAreaTextField(BuildContext context) {
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

  Obx locationTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.turf_LocationController.value,
        focusNode: variable.turf_LocationFocusNode.value,
        selected: variable.turf_LocationSelected.value,
        lebel: "Location",
        maxline: 3,
        onTap: () {
          variable.turf_LocationController.value.text == ""
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (con) => MapSample()))
              : address(context);
        },
        onSubmitt: (value) {},
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
        maxline: 3,
        onTap: () {
          variable.turf_LocationController.value.text == ""
              ? Navigator.push(
                  context, MaterialPageRoute(builder: (con) => MapSample()))
              : tabletAddress(context);
        },
        onSubmitt: (value) {},
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

  updateData() async {
    var body = {
      "turfId": widget.turfGroundDetailsScreen.sId.toString(),
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
      Get.delete<EditTurfGroundDataViewModel>();
      pitchMaps.clear();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
    // try {
    //   final response =
    //       await api.apiPostCall(context, "owner/turf-add-update", body: {
    //     "turfId": widget.turfGroundDetailsScreen.sId.toString(),
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
    //     Get.delete<editTurfGround>();
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
  }

  deletePitchDetails(String turfPitchID) async {
    var body = {"turfPitchId": turfPitchID};

    await variable.deletePitchDetails(authToken, body);

    if (variable.baseResponseForDeletePitch.value.responseCode == 200) {
      Fluttertoast.showToast(
          msg: variable.baseResponseForDeletePitch.value.response);
    } else {
      Fluttertoast.showToast(
          msg: variable.baseResponseForDeletePitch.value.response);
    }
  }

  deletUploadData(String image) async {
    // try {
    //   final response =
    //       await api.apiPostCall(context, "owner/delete-image", body: {
    //     "nameOrId": image
    //   }, headers: {
    //     'Content-type': 'application/json',
    //     "Authorization": "Bearer $authToken",
    //     "app-version": "1.0",
    //     "app-platform": Platform.isIOS ? "ios" : "android"
    //   });
    //   ApiResponse responseData = ApiResponse.fromJson(response);
    //   if (responseData.responseCode == 200) {

    //     loading.value = false;
    //     Fluttertoast.showToast(msg: responseData.response);
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

  String _formatTime(TimeOfDay time) {
    return "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
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
        var getImges = await uploadPhotoData(image.path);
        var parsedResponse = json.decode(getImges);
        variable.uploadImageData.insert(
            0, parsedResponse["data"]["imageDetail"]["name"].toString());
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
        var getImges = await uploadPhotoData(image.path);
        var parsedResponse = json.decode(getImges);
        variable.uploadImageData.insert(
            0, parsedResponse["data"]["imageDetail"]["name"].toString());
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
        var getImges = await uploadPhotoData(image.path);
        var parsedResponse = json.decode(getImges);
        variable.uploadImageData
            .add(parsedResponse["data"]["imageDetail"]["name"].toString());
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
        var getImges = await uploadPhotoData(image.path);
        var parsedResponse = json.decode(getImges);
        variable.uploadImageData
            .add(parsedResponse["data"]["imageDetail"]["name"].toString());
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
    } catch (e) {}
  }

  address(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.r,
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
              horizontal: 8.r,
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
        });
  }
  // void fetchSportsList() async {
  //   List<SportList> loadedList = await loadModelList();
  //   sportsList.addAll(loadedList);

  //   turfSportsList.value = sportsList.map((sport) {
  //     sport.isSelected.value =
  //         widget.turfGroundDetailsScreen.sportIds!.contains(sport.sId);
  //     if (sport.isSelected.value) {
  //       turfSportsSelectList.add(sport.sId.toString());
  //     }
  //     return sport;
  //   }).toList(); // Assign the loaded list to the RxList
  // }

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
        });
  }
}
