// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, use_build_context_synchronously, use_build_context_synchronously, use_build_context_synchronously, duplicate_ignore
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/customWidget/AppBigTextFiled.dart';
import 'package:turf_heros_owner/customWidget/AppTextFiled.dart';
import 'package:turf_heros_owner/customWidget/cutomButton.dart';
import 'package:turf_heros_owner/customWidget/cutome_toolbar.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/turf_offer_details_screen/view.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final variable = Get.put(TurfCreateCouponDataViewModel());

  late SharedPreferences prefs;
  String authToken = "";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "percentage", child: Text("percentage")),
      DropdownMenuItem(value: "Flat", child: Text("Flat")),
    ];
    return menuItems;
  }

  @override
  void dispose() {
    Get.delete<TurfCreateCouponDataViewModel>();

    super.dispose();
  }

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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
            : tabletView(context),
      ),
    );
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
              title: "Create Offer"),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  couponCodeTextField(context),
                  Obx(
                    () => SizedBox(
                      height:
                          variable.offerCodeSelected.value == true ? 12.h : 0.h,
                    ),
                  ),
                  discountTypeTextField(),
                  dicountValueTextField(context),
                  Obx(
                    () => SizedBox(
                      height: variable.discountValueSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  maxDicountAmountTextField(context),
                  Obx(
                    () => SizedBox(
                      height: variable.discountAmountSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  userLimitTextField(),
                  Obx(
                    () => SizedBox(
                      height:
                          variable.userlimitSelected.value == true ? 12.h : 0.h,
                    ),
                  ),
                  timePickerView(context),
                  SizedBox(
                    height: 12.h,
                  ),
                  descriptionsTextField(),
                  Obx(
                    () => SizedBox(
                      height: variable.descriptionsSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  termsAndConditionsTextFiled(),
                  Obx(
                    () => SizedBox(
                      height: variable.turf_AboutSelected.value == true
                          ? 44.h
                          : 28.h,
                    ),
                  ),
                  CustomeButton(
                      title: "Add Offer",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (variable.startDate.isEmpty &&
                              variable.endDate.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select duration");
                          } else {
                            _loadBookingListData();
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Please filup details");
                        }
                      })
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
              title: "Create Offer"),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  tabletCouponCodeTextField(context),
                  Obx(
                    () => SizedBox(
                      height:
                          variable.offerCodeSelected.value == true ? 12.h : 0.h,
                    ),
                  ),
                  tabletDiscountTypeTextField(),
                  tabletDicountValueTextField(context),
                  Obx(
                    () => SizedBox(
                      height: variable.discountValueSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  tabletMaxDicountAmountTextField(context),
                  Obx(
                    () => SizedBox(
                      height: variable.discountAmountSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  tabletUserLimitTextField(),
                  Obx(
                    () => SizedBox(
                      height:
                          variable.userlimitSelected.value == true ? 12.h : 0.h,
                    ),
                  ),
                  tabletTimePickerView(context),
                  SizedBox(
                    height: 12.h,
                  ),
                  tabletDescriptionsTextField(),
                  Obx(
                    () => SizedBox(
                      height: variable.descriptionsSelected.value == true
                          ? 12.h
                          : 0.h,
                    ),
                  ),
                  tabletTermsAndConditionsTextFiled(),
                  Obx(
                    () => SizedBox(
                      height: variable.turf_AboutSelected.value == true
                          ? 44.h
                          : 28.h,
                    ),
                  ),
                 TabletCustomeButton(
                      title: "Add Offer",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (variable.startDate.isEmpty &&
                              variable.endDate.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select duration");
                          } else {
                            _loadBookingListData();
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Please filup details");
                        }
                      })
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }

  Obx couponCodeTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.offerCodeController.value,
        focusNode: variable.offerCodeFocusNode.value,
        selected: variable.offerCodeSelected.value,
        lebel: "Code",
        inputFormatters: [UpperCaseTextFormatter()],
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountValueFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.offerCodeSelected.value = false;
            return "Please Enter your Code";
          } else if (variable.offerCodeController.value.text.length < 4 &&
              value.length < 4) {
            variable.offerCodeSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.offerCodeSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletCouponCodeTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.offerCodeController.value,
        focusNode: variable.offerCodeFocusNode.value,
        selected: variable.offerCodeSelected.value,
        lebel: "Code",
        inputFormatters: [UpperCaseTextFormatter()],
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountValueFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.offerCodeSelected.value = false;
            return "Please Enter your Code";
          } else if (variable.offerCodeController.value.text.length < 4 &&
              value.length < 4) {
            variable.offerCodeSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.offerCodeSelected.value = true;
            return null;
          }
        },
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
            value: variable.selectedValue.value,
            onChanged: (String? newValue) {
              variable.selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Discount Type",
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
              constraints: BoxConstraints(minHeight: 65.h),
              contentPadding:
                  EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h,right: 16.w),
            ),
            validator: (value) => value == null ? "Select a country" : null,
            dropdownColor: textFiledColor,
            value: variable.selectedValue.value,
            onChanged: (String? newValue) {
              variable.selectedValue.value = newValue!;
            },
            items: dropdownItems),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              "Discount Type",
              style: label_text_style,
            )),
      ],
    );
  }

  Obx dicountValueTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.discountValueController.value,
        focusNode: variable.discountValueFocusNode.value,
        selected: variable.discountValueSelected.value,
        lebel: "Discount Value",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountAmountFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountValueSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountValueController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountValueSelected.value = false;
            return "Please enter 2 charter";
          } else {
            variable.discountValueSelected.value = true;
            return null;
          }
        },
      ),
    );
  }
  Obx tabletDicountValueTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.discountValueController.value,
        focusNode: variable.discountValueFocusNode.value,
        selected: variable.discountValueSelected.value,
        lebel: "Discount Value",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.discountAmountFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountValueSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountValueController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountValueSelected.value = false;
            return "Please enter 2 charter";
          } else {
            variable.discountValueSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx maxDicountAmountTextField(BuildContext context) {
    return Obx(
      () => AppTextFiled(
        controller: variable.discountAmountController.value,
        focusNode: variable.discountAmountFocusNode.value,
        selected: variable.discountAmountSelected.value,
        lebel: "Max Discount Amount ",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.userlimitFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountAmountSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountAmountController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountAmountSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountAmountSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletMaxDicountAmountTextField(BuildContext context) {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.discountAmountController.value,
        focusNode: variable.discountAmountFocusNode.value,
        selected: variable.discountAmountSelected.value,
        lebel: "Max Discount Amount ",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {
          FocusScope.of(context)
              .requestFocus(variable.userlimitFocusNode.value);
        },
        validator: (value) {
          if (value!.isEmpty) {
            variable.discountAmountSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.discountAmountController.value.text.length < 2 &&
              value.length < 2) {
            variable.discountAmountSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.discountAmountSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx userLimitTextField() {
    return Obx(
      () => AppTextFiled(
        controller: variable.userlimitController.value,
        focusNode: variable.userlimitFocusNode.value,
        selected: variable.userlimitSelected.value,
        lebel: "User limit",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.userlimitSelected.value = false;
            return "Please Enter your Discount Value";
          } /* else if (variable.userlimitController.value
                                          .text.length <
                                      1 &&
                                  value.length < 1) {
                                variable.userlimitSelected.value = false;
                                return "Please enter 4 charter";
                              }*/
          else {
            variable.userlimitSelected.value = true;
            return null;
          }
        },
      ),
    );
  }
  Obx tabletUserLimitTextField() {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.userlimitController.value,
        focusNode: variable.userlimitFocusNode.value,
        selected: variable.userlimitSelected.value,
        lebel: "User limit",
        keyboardType: TextInputType.number,
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.userlimitSelected.value = false;
            return "Please Enter your Discount Value";
          } /* else if (variable.userlimitController.value
                                          .text.length <
                                      1 &&
                                  value.length < 1) {
                                variable.userlimitSelected.value = false;
                                return "Please enter 4 charter";
                              }*/
          else {
            variable.userlimitSelected.value = true;
            return null;
          }
        },
      ),
    );
  }
 
  Padding timePickerView(BuildContext context) {
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
                      "Start Date",
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
                    var expiresAt = await _selectDate(context);
                    variable.startDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    variable.startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
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
                      "Expired Date",
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
                    var expiresAt = await _selectDate(context);
                    variable.endDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    variable.endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
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

  Padding tabletTimePickerView(BuildContext context) {
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
                      "Start Date",
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
                    var expiresAt = await _selectDate(context);
                    variable.startDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    variable.startDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
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
                      "Expired Date",
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
                    var expiresAt = await _selectDate(context);
                    variable.endDate.value =
                        DateFormat('yyyy-MM-dd').format(expiresAt!);
                    variable.endDateTime.value =
                        DateFormat('yyyy-MM-dd hh:mm a').format(expiresAt);
                  },
                  child: SvgPicture.asset("assets/images/calender_image.svg",height: 16.h,width: 16.w,),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Obx descriptionsTextField() {
    return Obx(
      () => AppTextFiled(
        controller: variable.descriptionsController.value,
        focusNode: variable.descriptionsFocusNode.value,
        selected: variable.descriptionsSelected.value,
        lebel: "Descriptions",
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.descriptionsSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.descriptionsController.value.text.length < 4 &&
              value.length < 4) {
            variable.descriptionsSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.descriptionsSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

    Obx tabletDescriptionsTextField() {
    return Obx(
      () => TabletAppTextFiled(
        controller: variable.descriptionsController.value,
        focusNode: variable.descriptionsFocusNode.value,
        selected: variable.descriptionsSelected.value,
        lebel: "Descriptions",
        onSubmitt: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            variable.descriptionsSelected.value = false;
            return "Please Enter your Discount Value";
          } else if (variable.descriptionsController.value.text.length < 4 &&
              value.length < 4) {
            variable.descriptionsSelected.value = false;
            return "Please enter 4 charter";
          } else {
            variable.descriptionsSelected.value = true;
            return null;
          }
        },
      ),
    );
  }

  Obx termsAndConditionsTextFiled() {
    return Obx(() => AppBigTextFiled(
          lebel: "Terms & Conditions ",
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

    Obx tabletTermsAndConditionsTextFiled() {
    return Obx(() => TabletAppBigTextFiled(
          lebel: "Terms & Conditions ",
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

  _loadBookingListData() async {
    var body = {
      "couponId": "",
      "code": variable.offerCodeController.value.text.toString(),
      "discountType":
          variable.selectedValue.value.toString(), // percentage, flat
      "discountValue": variable.discountValueController.value.text.toString(),
      "maxDiscountAmount":
          variable.discountAmountController.value.text.toString(),
      "userLimit": variable.userlimitController.value.text.toString(),
      "startAt": "${variable.startDateTime.value}",
      "expiresAt": "${variable.endDateTime.value}",
      "description": variable.descriptionsController.value.text.toString()
    };

    await variable.turfCreateCouponData(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);

      // List<dynamic> turfListJson =
      //     variable.baseResponse.value.data!["couponList"];
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (co) => TurfOfferScreen()));

      // variable.turfCouponList.value =
      //     turfListJson.map((json) => CouponList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: variable.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != variable.selectedDate) {
      variable.selectedDate = picked;
    }
    return picked;
  }
}

    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/coupon-add-update",
    //     body: {
    //       "code": variable.offerCodeController.value.text.toString(),
    //       "discountType":
    //           variable.selectedValue.value.toString(), // percentage, flat
    //       "discountValue":
    //           variable.discountValueController.value.text.toString(),
    //       "maxDiscountAmount":
    //           variable.discountAmountController.value.text.toString(),
    //       "userLimit": variable.userlimitController.value.text.toString(),
    //       "startAt": variable.startDateTime.value.toString(),
    //       "expiresAt": variable.endDateTime.value.toString(),
    //       "description":
    //           variable.descriptionsController.value.text.toString()
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

    //     Fluttertoast.showToast(msg: "${responseData.response}");
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (co) => TurfOfferScreen()));
    //     // List<dynamic> turfListJson = responseData.data!["turfBookingList"];

    //     // variable.turfBookingList.value =
    //     //     turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();
  
    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {
  
    //   loading.value = false;
    // }