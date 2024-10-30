// ignore_for_file: must_be_immutable, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';

class TurfHomeWidget extends StatelessWidget {
  String title, image;
  VoidCallback onTap;

  TurfHomeWidget({
    required this.image,
    required this.onTap,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: appColor, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //"assets/images/turfGround_1.svg"
            SvgPicture.asset(image),
            SizedBox(
              height: 8.h,
            ),
            Text(
              title,
              style: turfGorund_text_style,
            )
          ],
        ),
      ),
    );
  }
}

class TabletTurfHomeWidget extends StatelessWidget {
  String title, image;
  VoidCallback onTap;

  TabletTurfHomeWidget({
    required this.image,
    required this.onTap,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: appColor, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //"assets/images/turfGround_1.svg"
            SvgPicture.asset(
              image,
              height: 50.h,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              title,
              style: TabletAppstyle.turfGorund_text_style,
            )
          ],
        ),
      ),
    );
  }
}
