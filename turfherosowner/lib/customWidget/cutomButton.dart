// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class CustomeButton extends StatelessWidget {
  String title;
  VoidCallback onTap;
  CustomeButton({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
      
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColor,
        ),
        child: Center(
          child: Text(
            title,
            style: customeButton_text_style,
          ),
        ),
      ),
    );
  }
}

class TabletCustomeButton extends StatelessWidget {
  String title;
  VoidCallback onTap;
  TabletCustomeButton({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
      
        margin: EdgeInsets.symmetric(horizontal: 36.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColor,
        ),
        child: Center(
          child: Text(
            title,
            style: TabletAppstyle.customeButton_text_style,
          ),
        ),
      ),
    );
  }
}
