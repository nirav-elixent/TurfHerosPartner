// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../appColor/AppColor.dart';

String fontFamily = "poppins";

TextStyle title_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    overflow: TextOverflow.ellipsis,
    color: appColor);

TextStyle title_white_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    overflow: TextOverflow.ellipsis,
    color: whiteColor);

TextStyle login_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w300,
    color: greyColor);

TextStyle hint_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: greyColor);

TextStyle customeButton_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: whiteColor);

TextStyle terms_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle condition_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: appColor,
    decoration: TextDecoration.underline);

TextStyle otp_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle dLocation_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w300,
    color: appColor);

TextStyle dLocationBold_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle detailcri_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle duserLocationBold_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle hintSearch_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w300,
    color: greyColor);

TextStyle dashCricket_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle locationAway_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: greyColor);

TextStyle turfName_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: appColor);
TextStyle drawerScond_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: greyBoldColor);

TextStyle error_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: appColor);

TextStyle turfGorund_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: whiteColor);

TextStyle detailsturfName_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle unselectedTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: appColor);

TextStyle selectedTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: whiteColor);

TextStyle addImage_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle addImageBig_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle bottomsheet_title_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle offerTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: greyBColor);
TextStyle offerPer_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle offerDes_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: appColor);

TextStyle offerStart_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: greyBColor);

TextStyle offerStartTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: greyBColor);

TextStyle label_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    color: greyColor.withOpacity(0.75),
    fontWeight: FontWeight.w400);

TextStyle labelDate_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: appColor);

TextStyle calendar_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: whiteColor);

TextStyle paymentStatus_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: black_color);

TextStyle success_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: greenColor);

TextStyle pending_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: redColor);

TextStyle currentWallet_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: whiteColor);

TextStyle currentAmount_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    color: whiteColor);

TextStyle transitions_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle walletTransitions_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: greyBColor);

TextStyle walletTransitions_amount_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: greenColor);

TextStyle detailDesp_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: greyBColor);

TextStyle detailsAbout_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle mapButton_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle detailsturfprice_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle images_incremec_text_style = TextStyle(
  fontFamily: fontFamily,
  color: Colors.white,
  fontSize: 17.sp,
  fontWeight: FontWeight.w600,
);

TextStyle selectdetailcri_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: whiteColor);

TextStyle unDetailcri_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: appColor);

TextStyle total_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: appColor);

TextStyle totalPrice_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23.sp,
    fontWeight: FontWeight.w700,
    color: appColor);

TextStyle bottomSheet_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: black_color);

TextStyle bottotSheetLast_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: greyColor);

TextStyle bottomSheetCancel_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: redColor);

TextStyle unselectedManageTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle selectedManageTime_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: whiteColor);

TextStyle slotDelete_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: greyColor);

TextStyle deteleButton_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: black_color);

TextStyle deteleAccountButton_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: redColor);

TextStyle walletReward_amount_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: greyBoldColor);

TextStyle bookingFuture_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

TextStyle bookingFutureUn_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: whiteColor);

TextStyle bookingType_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: greenColor);

TextStyle bookingTypeOffline_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9.sp,
    fontWeight: FontWeight.w600,
    color: redColor);
TextStyle accountDetailsName_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

    TextStyle deteleAccountMain_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
    color: black_color);
TextStyle deteleAccountSecond_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: black_color);
TextStyle deteleAccountthird_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: black_color);
    TextStyle deleteAccount_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: redColor);
// TextStyle deteleButton_text_style = TextStyle(
//     fontFamily: fontFamily,
//     fontSize: 12.sp,
//     fontWeight: FontWeight.w600,
//     color: appColor);

// TextStyle deteleAccountButton_text_style = TextStyle(
//     fontFamily: fontFamily,
//     fontSize: 12.sp,
//     fontWeight: FontWeight.w600,
//     color: whiteColor);
TextStyle mobilwNumber_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

    TextStyle logoutTitle_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: appColor);

    
    TextStyle logoutSubTitle_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: bordergreyColor);

    TextStyle deteleAccountButtonDailog_text_style = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: whiteColor);