import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appColor/AppColor.dart';
import 'package:turf_heros_owner/const/appTextstyle/AppStyle.dart';
import 'package:turf_heros_owner/const/appTextstyle/tablet_appStyle.dart';
import 'package:turf_heros_owner/customWidget/cutomError_screen.dart';
import 'package:turf_heros_owner/customWidget/walletBalanceuser.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class TurfWalletScreen extends StatefulWidget {
  const TurfWalletScreen({super.key});

  @override
  State<TurfWalletScreen> createState() => _TurfWalletScreenState();
}

class _TurfWalletScreenState extends State<TurfWalletScreen> {
  final variable = Get.put(MyDetailsDataViewModel());
  late SharedPreferences prefs;
  String authToken = "";
  final ScrollController _scrollController = ScrollController();

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        variable.hasMoreData.value) {
      _loadMoreData();
    } else {}
  }

  Future<void> _loadMoreData() async {
    if (!variable.isLoading.value) {
      variable.isLoading.value = true;
      variable.pageNumber.value++;
      await _loadMyBookingTransactionData();

      variable.isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    // loadTurfList();
    // _scrollController.addListener(_onScroll);
    // variable.currentPosition.latitude == 0.0 ? _getCurrentLocation() : null;
    // checkInternet(context);
    Timer(const Duration(milliseconds: 500), () {
      _loadMyData();
      _scrollController.addListener(_onScroll);
      _loadMyBookingTransactionData(isInitialLoad: true);
    });
  }

  @override
  void dispose() {
    Get.delete<MyDetailsDataViewModel>();
    _scrollController.dispose();
    super.dispose();
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
        child: ScreenUtil().screenWidth < 600 ? moblieView() : tabletView(),
      ),
    );
  }

  Scaffold moblieView() {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: const Color(0xff2254B2),
        child: Stack(
          children: [
            const ToolBar(),
            walletBalance(),
            Padding(
              padding: EdgeInsets.only(top: 290.h),
              child: Container(
                padding: EdgeInsets.only(top: 16.h),
                height: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                    color: whiteColor),
                child: Column(
                  children: [
                    balanceListTitle(),
                    Expanded(
                        child: Obx(
                      () => ListView.separated(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          itemBuilder: (context, index) {
                            return UserDetailsWidget(
                              userName:
                                  "${variable.turfWalletBookingList[index].documents![0].userDetail![0].firstName} ${variable.turfWalletBookingList[index].documents![0].userDetail![0].lastName}",
                              date: variable.turfWalletBookingList[index]
                                  .documents![0].date
                                  .toString(),
                              turfName: variable.turfWalletBookingList[index]
                                  .documents![0].turfDetail![0].name
                                  .toString(),
                              payAmount: variable.turfWalletBookingList[index]
                                  .documents![0].payAmount!,
                              ownerPoint: variable.turfWalletBookingList[index]
                                  .documents![0].ownerRewardPoint!,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 16.h,
                            );
                          },
                          itemCount: variable.turfWalletBookingList.length),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Scaffold tabletView() {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: const Color(0xff2254B2),
        child: Stack(
          children: [
            const TabletToolBar(),
            tabletWalletBalance(),
            Padding(
              padding: EdgeInsets.only(top: 290.h),
              child: Container(
                padding: EdgeInsets.only(top: 16.h),
                height: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                    color: whiteColor),
                child: Column(
                  children: [
                    tabletBalanceListTitle(),
                    Expanded(
                        child: variable.turfWalletBookingList.isEmpty
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ErrorScreen(),
                              ],
                            )
                            : Obx(
                                () => ListView.separated(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 8.h),
                                    itemBuilder: (context, index) {
                                      return TabletUserDetailsWidget(
                                        userName:
                                            "${variable.turfWalletBookingList[index].documents![0].userDetail![0].firstName} ${variable.turfWalletBookingList[index].documents![0].userDetail![0].lastName}",
                                        date: variable
                                            .turfWalletBookingList[index]
                                            .documents![0]
                                            .date
                                            .toString(),
                                        turfName: variable
                                            .turfWalletBookingList[index]
                                            .documents![0]
                                            .turfDetail![0]
                                            .name
                                            .toString(),
                                        payAmount: variable
                                            .turfWalletBookingList[index]
                                            .documents![0]
                                            .payAmount!,
                                        ownerPoint: variable
                                            .turfWalletBookingList[index]
                                            .documents![0]
                                            .ownerRewardPoint!,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 16.h,
                                      );
                                    },
                                    itemCount:
                                        variable.turfWalletBookingList.length),
                              ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Padding balanceListTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transitions",
            style: transitions_text_style,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "LAST 3 MONTHS",
                    style: detailcri_text_style,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  SvgPicture.asset("assets/images/down_image.svg")
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "View All",
                style: offerPer_text_style,
              )
            ],
          )
        ],
      ),
    );
  }

  Padding tabletBalanceListTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transitions",
            style: TabletAppstyle.transitions_text_style,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "LAST 3 MONTHS",
                    style: TabletAppstyle.detailcri_text_style,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  SvgPicture.asset("assets/images/down_image.svg")
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "View All",
                style: TabletAppstyle.offerPer_text_style,
              )
            ],
          )
        ],
      ),
    );
  }

  Padding walletBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 111.h),
      child: Container(
        height: 130.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: 350.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Account Balance",
                          style: currentWallet_text_style,
                        ),
                        Obx(
                          () => Text(
                            '₹ ${variable.walletBalance.value}',
                            style: currentAmount_text_style,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reward Point Balance",
                          style: currentWallet_text_style,
                        ),
                        Obx(
                          () => Text(
                            '₹ ${variable.rewardBalance.value}',
                            style: currentAmount_text_style,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //   "₹ ${/*variable.walletBalance.value*/}"
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 45.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xff2254B2)),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 45.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xff2254B2)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding tabletWalletBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Container(
        height: 150.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: 350.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Account Balance",
                          style: currentWallet_text_style,
                        ),
                        Obx(
                          () => Text(
                            '₹ ${variable.walletBalance.value}',
                            style: currentAmount_text_style,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reward Point Balance",
                          style: currentWallet_text_style,
                        ),
                        Obx(
                          () => Text(
                            '₹ ${variable.rewardBalance.value}',
                            style: currentAmount_text_style,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //   "₹ ${/*variable.walletBalance.value*/}"
            Positioned(
              bottom: 0.h,
              left: 0.w,
              child: Container(
                height: 54.h,
                width: 40.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xff2254B2)),
              ),
            ),
            Positioned(
              bottom: 0.h,
              right: 0.w,
              child: Container(
                height: 54.h,
                width: 40.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: const Color(0xff2254B2)),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loadMyData() async {
    await variable.myDetails(authToken);

    if (variable.baseResponse.value.responseCode == 200) {
      variable.walletBalance.value =
          variable.baseResponse.value.data["userDetail"]["walletBalance"].toString();

      variable.rewardBalance.value = variable
          .baseResponse.value.data["userDetail"]["ownerRewardPointBalance"]
          .toString();

      // List<dynamic> turfListJson = variable.baseResponse.value.data!["turfBookingList"];

      // variable.turfWalletBookingList.value =
      //     turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "my-detail",
    //     body: {
    //       // "pageNumber": "1",
    //       // "perPage": "10",
    //       // "searchString": "",
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

    //     UserData response = UserData.fromJson(responseData.data!["userDetail"]);
    //     variable.walletBalance.value =
    //         responseData.data["userDetail"]["walletBalance"];
    //     // response.walletBalance.toString();
    //     // List<dynamic> turfListJson = responseData.data!["turfBookingList"];

    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }
  }

  _loadMyBookingTransactionData({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      variable.pageNumber.value = 1; // Reset to the first page on initial load
      variable.turfWalletBookingList
          .clear(); // Clear the current list for initial load
    }

    var body = {"pageNumber": variable.pageNumber.value, "perPage": 10};

    await variable.bookingTransactionList(authToken, body);

    if (variable.baseResponse.value.responseCode == 200) {
      List<dynamic> turfListJson = variable
          .baseResponseBookingTransaction.value.data!["turfBookingList"];
      if (isInitialLoad) {
        variable.hasMoreData.value = true;
        if (turfListJson.isEmpty) {
          variable.hasMoreData.value = false;
          // appVariable.turfList.value =
          //     turfListJson.map((json) => TurfList.fromJson(json)).toList();
        } else {
          variable.turfWalletBookingList.value = turfListJson
              .map((json) => TurfBookingList.fromJson(json))
              .toList();
          /*  appVariable.turfList.value =
                turfListJson.map((json) => TurfList.fromJson(json)).toList();*/
        }
      } else {
        if (turfListJson.isEmpty) {
          variable.hasMoreData.value = false;
          // appVariable.turfList.value =
          //     turfListJson.map((json) => TurfList.fromJson(json)).toList();
        } else {
          /*  appVariable.searchController.value.text.isEmpty
                ? */
          variable.turfWalletBookingList.addAll(turfListJson
                  .map((json) => TurfBookingList.fromJson(json))
                  .toList())
              /*  : appVariable.turfList.value = turfListJson
                    .map((json) => TurfList.fromJson(json))
                    .toList()*/
              ;
        }
      }
    } else {
      Fluttertoast.showToast(msg: variable.baseResponse.value.response);
    }
    // try {
    //   final response = await api.apiPostCall(
    //     context,
    //     "owner/booking-transaction-list",
    //     body: {
    //       "searchString": "", // optional
    //       "bookingStartDate": "2024-05-26", // optional
    //       "bookingEndDate": "2025-05-26", // optional
    //       "pageNumber": 1,
    //       "perPage": 10
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

    //     List<dynamic> turfListJson = responseData.data!["turfBookingList"];
    //     variable.turfWalletBookingList.value =
    //         turfListJson.map((json) => TurfBookingList.fromJson(json)).toList();

    //     loading.value = false;
    //   } else if (responseData.responseCode == 400) {
    //     loading.value = false;

    //   } else {
    //     loading.value = false;
    //   }
    // } catch (e) {

    //   loading.value = false;
    // }
  }
}

class ToolBar extends StatelessWidget {
  const ToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.r),
      child: SizedBox(
        width: double.infinity,
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
                      child: SvgPicture.asset("assets/images/back_image.svg")),
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
                    "Wallet",
                    style: title_white_style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TabletToolBar extends StatelessWidget {
  const TabletToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.r),
      child: SizedBox(
        width: double.infinity,
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
                      child: SvgPicture.asset("assets/images/back_image.svg")),
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
                    "Wallet",
                    style: TabletAppstyle.title_white_style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
