// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class TurfGroundListWidget extends StatelessWidget {
  final String images, name;
  final double rating;
  final int totalRating;
  VoidCallback turfDetail;
  VoidCallback editDetails, deleteTurf;
  TurfGroundListWidget(
      {required this.images,
      required this.name,
      required this.rating,
      required this.totalRating,
      required this.turfDetail,
      required this.editDetails,
      required this.deleteTurf,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: turfDetail,
      child: Container(
        height: 240.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        child: Column(
          children: [
            /*${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index] ""}*/
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
              child: Image.network(
                "${ApiService.baseUrl}/$images",
                fit: BoxFit.cover,
                height: 140.h,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/turf_details_image.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  editAndDeleteButton(),
                  ratingText(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding editAndDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "1.1 km away",
            style: hint_text_style,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: editDetails,
                child: SvgPicture.asset("assets/images/edit_image.svg"),
              ),
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                  onTap: deleteTurf,
                  child: SvgPicture.asset("assets/images/delete_image.svg")),
            ],
          )
        ],
      ),
    );
  }

  Padding ratingText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            name,
            style: detailsturfName_text_style,
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/star_image.svg",
                height: 23.h,
                width: 23.w,
              ),
              RichText(
                text: TextSpan(
                    text: rating.toStringAsFixed(1).toString(),
                    style: dLocationBold_text_style,
                    children: [
                      TextSpan(
                          text: "(${formatNumber(totalRating)})",
                          style: locationAway_text_style)
                    ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  String formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(2)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} k';
    } else {
      return number.toString();
    }
  }
}

class TabletTurfGroundListWidget extends StatelessWidget {
  final String images, name;
  final double rating;
  final int totalRating;
  VoidCallback turfDetail;
  VoidCallback editDetails, deleteTurf;
  TabletTurfGroundListWidget(
      {required this.images,
      required this.name,
      required this.rating,
      required this.totalRating,
      required this.turfDetail,
      required this.editDetails,
      required this.deleteTurf,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: turfDetail,
      child: Container(
        height: 250.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: whiteColor),
        child: Column(
          children: [
            /*${widget.turfListDetails.images!.isEmpty ? "" : widget.turfListDetails.images![index] ""}*/
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
              child: Image.network(
                "${ApiService.baseUrl}/$images",
                fit: BoxFit.cover,
                height: 170.h,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/turf_details_image.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  editAndDeleteButton(),
                  ratingText(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding editAndDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "1.1 km away",
            style: TabletAppstyle.hint_text_style,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: editDetails,
                child: SvgPicture.asset(
                  "assets/images/edit_image.svg",
                  height: 16.h,
                  width: 16.w,
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                onTap: deleteTurf,
                child: SvgPicture.asset(
                  "assets/images/delete_image.svg",
                  height: 16.h,
                  width: 16.w,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding ratingText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            name,
            style: TabletAppstyle.detailsturfName_text_style,
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/star_image.svg",
                height: 20.h,
                width: 20.w,
              ),
              RichText(
                text: TextSpan(
                    text: rating.toStringAsFixed(1).toString(),
                    style: TabletAppstyle.dLocationBold_text_style,
                    children: [
                      TextSpan(
                          text: "(${formatNumber(totalRating)})",
                          style: TabletAppstyle.locationAway_text_style)
                    ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  String formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(2)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)} k';
    } else {
      return number.toString();
    }
  }
}
