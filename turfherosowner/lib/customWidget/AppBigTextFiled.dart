// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';

class AppBigTextFiled extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?) validator;

  FocusNode focusNode;
  bool selected = true;
  Function(String) onSubmitt;
  TextInputType keyboardType;
  String lebel;
  bool enable;
  int maxline;

  AppBigTextFiled(
      {required this.focusNode,
      this.enable = true,
      required this.selected,
      required this.onSubmitt,
      this.keyboardType = TextInputType.name,
      this.lebel = "",
      this.maxline = 1,
      required this.validator,
      required this.controller,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.zero,
            controller: controller,
            onFieldSubmitted: onSubmitt,
            enabled: enable,
            style: TextStyle(
                fontSize: 15.sp, fontWeight: FontWeight.w500, color: appColor),
            keyboardType: keyboardType,
            focusNode: focusNode,
            validator: validator,
            maxLines: 5,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 16.w, top: 20.h, right: 16.w),
              filled: true,
              fillColor: textFiledColor,
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              constraints:
                  BoxConstraints(maxHeight: selected == true ? 75.h : 75.h),
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
            ),
          ),
        ),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              lebel,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 11.sp,
                  color: greyColor.withOpacity(0.75),
                  fontWeight: FontWeight.w400),
            )),
      ],
    );
  }
}

class TabletAppBigTextFiled extends StatelessWidget {
  TextEditingController controller;
  String? Function(String?) validator;

  FocusNode focusNode;
  bool selected = true;
  Function(String) onSubmitt;
  TextInputType keyboardType;
  String lebel;
  bool enable;
  int maxline;
    VoidCallback? onTap;

  TabletAppBigTextFiled(
      {required this.focusNode,
      this.enable = true,
      required this.selected,
      required this.onSubmitt,
      this.keyboardType = TextInputType.name,
      this.lebel = "",
      this.maxline = 1,
      this.onTap,
      required this.validator,
      required this.controller,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextFormField(
            scrollPadding: EdgeInsets.zero,
            controller: controller,
            onFieldSubmitted: onSubmitt,
            onTap: onTap,
            enabled: enable,
            style: TextStyle(
                fontSize: 13.sp, fontWeight: FontWeight.w500, color: appColor),
            keyboardType: keyboardType,
            focusNode: focusNode,
            validator: validator,
            maxLines: maxline,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 16.w, top: 24.h, right: 16.w,bottom: 16.h),
              filled: true,
              fillColor: textFiledColor,
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent)),
              constraints:
                  BoxConstraints(minHeight:  65.h),
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
            ),
          ),
        ),
        Positioned(
            left: 32.w,
            top: 3.h,
            child: Text(
              lebel,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 11.sp,
                  color: greyColor.withOpacity(0.75),
                  fontWeight: FontWeight.w400),
            )),
      ],
    );
  }
}