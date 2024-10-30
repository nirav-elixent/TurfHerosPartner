// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/repositories/api_repository.dart';

class LoginWithNumberViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  RxString mobileNumber = "".obs;
  RxString phoneCode = "".obs;
  Rx isLoading = false.obs;

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;

  loginWithNumber(Map<String, dynamic> body) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.loginWithNumber(body);
      baseResponse.value = fetchedItems;
      print("Fetched response: ${baseResponse.value.responseCode}");
      print("Fetched response:123 ${fetchedItems.response}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class OtpVerifyViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  RxInt seconds = 0.obs;

  RxInt secondText = 0.obs;

  RxInt minutes = 0.obs;

  RxString otpCode = "".obs;

  Rx isLoading = false.obs;

  Rx<FocusNode> focusNode = FocusNode().obs;

  Rx<TextEditingController> controller = TextEditingController().obs;

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  otpVerify(Map<String, dynamic> body) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.otpVerify(body);
      baseResponse.value = fetchedItems;
      print("Fetched response: ${baseResponse.value.responseCode}");
      print("Fetched response:123 ${fetchedItems.response}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class SportDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  sportData() async {
    try {
      var fetchedItems = await _repository.sportData();
      baseResponse.value = fetchedItems;
      print("Fetched response: ${baseResponse.value.responseCode}");
      print("Fetched response:123 ${fetchedItems.response}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {}
  }
}

class FacilityDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  facilityData() async {
    try {
      var fetchedItems = await _repository.facilityData();
      baseResponse.value = fetchedItems;
      print("Fetched response: ${baseResponse.value.responseCode}");
      print("Fetched response:123 ${fetchedItems.response}");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {}
  }
}

class TurfListDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseDeleteAccount =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  RxList<TurfList> turfGorundList = <TurfList>[].obs;

  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString phoneNumber = "".obs;
  RxString customerId = "".obs;
  RxString email = "".obs;
  RxString walletBalance = "".obs;
  Rx isLoading = false.obs;

  turfListData(String authToken, String searchString) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.turfListData(authToken, searchString);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  deleteTurf(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.deleteTurf(authToken, requestBody);
      baseResponseDeleteAccount.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}

class TurfBookingListDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  RxList<TurfBookingList> turfBookingList = <TurfBookingList>[].obs;

  RxString formattedDate = "".obs;

  RxString startDate = "".obs;

  RxString endDate = "".obs;

  RxString formatDays = "".obs;

  Rx isLoading = false.obs;

  RxBool hasMoreData = true.obs;

  RxInt pageNumber = 1.obs;

  RxInt tabNumber = 0.obs;

  turfBookingListData(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.turfBookingList(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class TurfCouponListDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  RxList<CouponList> turfCouponList = <CouponList>[].obs;

  Rx isLoading = false.obs;

  RxList<Map<String, dynamic>> apiSelectedSlotList =
      <Map<String, dynamic>>[].obs;

  Map<String, dynamic>? item;

  turfCouponListData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.turfCouponist(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class TurfCreateCouponDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  DateTime? selectedDate;

  RxString startDate = "".obs;
  RxString endDate = "".obs;
  RxString startDateTime = "".obs;
  RxString endDateTime = "".obs;
  RxString selectedValue = "percentage".obs;

  Rx<TextEditingController> offerCodeController = TextEditingController().obs;
  Rx<FocusNode> offerCodeFocusNode = FocusNode().obs;
  RxBool offerCodeSelected = true.obs;

  Rx<TextEditingController> discountValueController =
      TextEditingController().obs;
  Rx<FocusNode> discountValueFocusNode = FocusNode().obs;
  RxBool discountValueSelected = true.obs;

  Rx<TextEditingController> discountAmountController =
      TextEditingController().obs;
  Rx<FocusNode> discountAmountFocusNode = FocusNode().obs;
  RxBool discountAmountSelected = true.obs;

  Rx<TextEditingController> userlimitController = TextEditingController().obs;
  Rx<FocusNode> userlimitFocusNode = FocusNode().obs;
  RxBool userlimitSelected = true.obs;

  Rx<TextEditingController> descriptionsController =
      TextEditingController().obs;
  Rx<FocusNode> descriptionsFocusNode = FocusNode().obs;
  RxBool descriptionsSelected = true.obs;

  Rx<TextEditingController> turf_AboutController = TextEditingController().obs;
  Rx<FocusNode> turf_AboutFocusNode = FocusNode().obs;
  RxBool turf_AboutSelected = true.obs;

  turfCreateCouponData(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.turfCreateCoupon(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class DeleteCouponDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  deleteCouponData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.deleteCoupon(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class UserDetailsDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  RxInt galleryIndex = 0.obs;

  RxString userPhoneCode = "".obs;

  //create textedting controller moblie number
  Rx<TextEditingController> userMoblieNuController =
      TextEditingController().obs;
  Rx<FocusNode> userMoblieNuFocusNode = FocusNode().obs;
  RxBool userMoblieNuSelected = true.obs;
  RxString userMobileNumber = "".obs;
  RxString userId = "".obs;

  userDetailsData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.userDetails(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class LoadBookingAvailableSlotDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseBooking =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  RxList<Map<String, String>> selectedSlotList = <Map<String, String>>[].obs;

  RxInt selectedPitch = 0.obs;

  RxInt selectedSlotPrice = 0.obs;

  RxInt selectSport = 0.obs;

  RxString selectedTurfPitch = "".obs;

  RxString formattedDate = "".obs;

  RxString phoneCode = "".obs;

  RxString mobileNumber = "".obs;

  Rx<ApiResponse> baseResponseUpdateDetails =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseUserDetails =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  RxList<List<TurfAvailableSlotList>> availableSlotList =
      <List<TurfAvailableSlotList>>[].obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<FocusNode> firstNameFocusNode = FocusNode().obs;
  RxBool firstNameSelected = true.obs;

  //create textedting controller last name
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<FocusNode> lastNameFocusNode = FocusNode().obs;
  RxBool lastNameSelected = true.obs;

  //create textedting controller moblie number
  Rx<TextEditingController> moblieNuController = TextEditingController().obs;
  Rx<FocusNode> moblieNuFocusNode = FocusNode().obs;
  RxBool moblieNuSelected = true.obs;

  //create textedting controller email
  Rx<TextEditingController> emailIDController = TextEditingController().obs;
  Rx<FocusNode> emailIDFocusNode = FocusNode().obs;
  RxBool emailIDSelected = true.obs;

  Rx<TextEditingController> advancePaymentController =
      TextEditingController().obs;
  Rx<FocusNode> advancePaymentFocusNode = FocusNode().obs;
  RxBool advancePaymentSelected = true.obs;

  Rx<TextEditingController> offerAmountController = TextEditingController().obs;
  Rx<FocusNode> offerAmountFocusNode = FocusNode().obs;
  RxBool offerAmountSelected = true.obs;

  Rx<TextEditingController> upiIdController = TextEditingController().obs;
  Rx<FocusNode> upiIdFocusNode = FocusNode().obs;
  RxBool upiIdSelected = true.obs;

  loadBookingAvailableSlotData(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.loadBookingAvailableSlot(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("print error ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  bookSlotData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.bookSlot(authToken, requestBody);
      baseResponseBooking.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("print error ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  updateDetailsData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.userDetailsUpdate(authToken, requestBody);
      baseResponseUpdateDetails.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("print error ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  myDetails(String authToken) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.myDetails(authToken);
      baseResponseUserDetails.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class LoadBulkBookingAvailableSlotDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseBooking =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  RxList<Map<String, String>> selectedSlotList = <Map<String, String>>[].obs;

  RxInt selectedPitch = 0.obs;

  RxInt selectedSlotPrice = 0.obs;

  RxInt selectSport = 0.obs;

  RxInt selectDay = 0.obs;

  RxString selectedTurfPitch = "".obs;

  RxString formattedDate = "".obs;

  RxString phoneCode = "".obs;

  RxString mobileNumber = "".obs;

  DateTime? selectedDate;

  RxString startDate = "".obs;

  RxString endDate = "".obs;

  RxString startDateTime = "".obs;

  RxString endDateTime = "".obs;

  RxList<List<TurfAvailableSlotList>> availableSlotList =
      <List<TurfAvailableSlotList>>[].obs;

  Rx<TextEditingController> advancePaymentController =
      TextEditingController().obs;
  Rx<FocusNode> advancePaymentFocusNode = FocusNode().obs;
  RxBool advancePaymentSelected = true.obs;

  Rx<TextEditingController> offerAmountController = TextEditingController().obs;
  Rx<FocusNode> offerAmountFocusNode = FocusNode().obs;
  RxBool offerAmountSelected = true.obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<FocusNode> firstNameFocusNode = FocusNode().obs;
  RxBool firstNameSelected = true.obs;

  //create textedting controller last name
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<FocusNode> lastNameFocusNode = FocusNode().obs;
  RxBool lastNameSelected = true.obs;

  //create textedting controller moblie number
  Rx<TextEditingController> moblieNuController = TextEditingController().obs;
  Rx<FocusNode> moblieNuFocusNode = FocusNode().obs;
  RxBool moblieNuSelected = true.obs;

  //create textedting controller email
  Rx<TextEditingController> emailIDController = TextEditingController().obs;
  Rx<FocusNode> emailIDFocusNode = FocusNode().obs;
  RxBool emailIDSelected = true.obs;

  allBookingSlotData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.allBookingSlot(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("print error ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  bulkBookSlotData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.bulkBookSlot(authToken, requestBody);
      baseResponseBooking.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("print error ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}

class MyDetailsDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseBookingTransaction =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  RxString walletBalance = "".obs;

  RxString rewardBalance = "".obs;

  RxBool hasMoreData = true.obs;

  RxInt pageNumber = 1.obs;

  RxList<TurfBookingList> turfWalletBookingList = <TurfBookingList>[].obs;

  // //create textedting controller moblie number
  // Rx<TextEditingController> userMoblieNuController =
  //     TextEditingController().obs;
  // Rx<FocusNode> userMoblieNuFocusNode = FocusNode().obs;
  // RxBool userMoblieNuSelected = true.obs;
  // RxString userMobileNumber = "".obs;
  // RxString userId = "".obs;

  bookingTransactionList(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.bookingTransactionList(authToken, requestBody);
      baseResponseBookingTransaction.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  myDetails(String authToken) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.myDetails(authToken);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class ManageTimeSlotDateDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseUpdatePrice =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseDeleteTimeSlot =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<TextEditingController> priceController = TextEditingController().obs;
  Rx<FocusNode> priceFocusNode = FocusNode().obs;
  RxBool priceSelected = true.obs;

  Rx isLoading = false.obs;

  RxInt galleryIndex = 0.obs;

  RxString userPhoneCode = "".obs;

  RxString formattedDate = "".obs;

  RxInt selectPitch = 0.obs;

  RxInt selectDay = 0.obs;

  var textControllers = <TextEditingController>[].obs;

  managetimeSlotDaate(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.manageTimeSlotList(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  updatePrice(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems = await _repository.updatePrice(authToken, requestBody);
      baseResponseUpdatePrice.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  deleteTimeSlot(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.deleteTimeSlot(authToken, requestBody);
      baseResponseDeleteTimeSlot.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class BlockTimeSlotDataViewModel extends GetxController {
  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseBlockTime =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx isLoading = false.obs;

  RxInt galleryIndex = 0.obs;

  DateTime? selectedDate;

  RxString startDateTime = "".obs;

  RxString endDateTime = "".obs;

  RxString startDate = "".obs;

  RxString endDate = "".obs;

  RxString userPhoneCode = "".obs;

  RxString formattedDate = "".obs;

  RxInt selectPitch = 0.obs;

  RxInt selectDay = 0.obs;

  managetimeSlotDaate(
      String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.manageTimeSlotList(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  blockTimeSlotData(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.blockTimeSlot(authToken, requestBody);
      baseResponseBlockTime.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
  //   updatePrice(String authToken, Map<String, dynamic> requestBody) async {
  //   try {
  //     isLoading(true);
  //     var fetchedItems = await _repository.updatePrice(authToken, requestBody);
  //     baseResponseUpdatePrice.value = fetchedItems;
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  //   deleteTimeSlot(String authToken, Map<String, dynamic> requestBody) async {
  //   try {
  //     isLoading(true);
  //     var fetchedItems = await _repository.deleteTimeSlot(authToken, requestBody);
  //     baseResponseDeleteTimeSlot.value = fetchedItems;
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}

class EditTurfGroundDataViewModel extends GetxController {
  Rx isLoading = false.obs;

  Rx<TextEditingController> turf_NameController = TextEditingController().obs;
  Rx<FocusNode> turf_NameFocusNode = FocusNode().obs;
  RxBool turf_NameSelected = true.obs;

  Rx<TextEditingController> turf_LocationController =
      TextEditingController().obs;
  Rx<FocusNode> turf_LocationFocusNode = FocusNode().obs;
  RxBool turf_LocationSelected = true.obs;

  Rx<TextEditingController> turf_AreaSqController = TextEditingController().obs;
  Rx<FocusNode> turf_AreaSqFocusNode = FocusNode().obs;
  RxBool turf_AreaSqSelected = true.obs;

  Rx<TextEditingController> turf_HourController = TextEditingController().obs;
  Rx<FocusNode> turf_HourFocusNode = FocusNode().obs;
  RxBool turf_HourSelected = true.obs;

  Rx<TextEditingController> turf_PerHourController =
      TextEditingController().obs;
  Rx<FocusNode> turf_PerHourFocusNode = FocusNode().obs;
  RxBool turf_PerHourSelected = true.obs;

  Rx<TextEditingController> turf_AboutController = TextEditingController().obs;
  Rx<FocusNode> turf_AboutFocusNode = FocusNode().obs;
  RxBool turf_AboutSelected = true.obs;

  DateTime? selectedDate;

  RxString startDate = "".obs;
  RxString endDate = "".obs;

  Rx<XFile?> image = Rx<XFile?>(null);
  RxList<XFile?> imageList = <XFile?>[].obs;
  RxList<String> uploadImageData = <String>[].obs;
  RxString street = "".obs;
  RxString subLocality = "".obs;
  RxString locality = "".obs;
  RxString postalCode = "".obs;
  RxString country = "".obs;
  RxString state = "".obs;
  RxString lat = "".obs;
  RxString lng = "".obs;

  RxList<TurfPitchDetail> turfPitchSelectList = <TurfPitchDetail>[].obs;
  Rx<TextEditingController> streetController = TextEditingController().obs;
  Rx<FocusNode> streetFocusNode = FocusNode().obs;
  RxBool streetSelected = true.obs;
  Rx<TextEditingController> subLocalityController = TextEditingController().obs;
  Rx<FocusNode> subLocalityFocusNode = FocusNode().obs;
  RxBool subLocalitySelected = true.obs;

  Rx<TextEditingController> localityController = TextEditingController().obs;
  Rx<FocusNode> localityFocusNode = FocusNode().obs;
  RxBool localitySelected = true.obs;

  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<FocusNode> stateFocusNode = FocusNode().obs;
  RxBool stateSelected = true.obs;

  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<FocusNode> countryFocusNode = FocusNode().obs;
  RxBool countrySelected = true.obs;

  Rx<TextEditingController> postalCodeController = TextEditingController().obs;
  Rx<FocusNode> postalCodeFocusNode = FocusNode().obs;
  RxBool postalCodeSelected = true.obs;

  Rx<TextEditingController> pitchController = TextEditingController().obs;
  Rx<FocusNode> pitchFocusNode = FocusNode().obs;
  RxBool pitchSelected = true.obs;

  Rx<TextEditingController> mondayController = TextEditingController().obs;
  Rx<FocusNode> mondayFocusNode = FocusNode().obs;
  RxBool mondaySelected = true.obs;

  Rx<TextEditingController> tuesdayController = TextEditingController().obs;
  Rx<FocusNode> tuesdayFocusNode = FocusNode().obs;
  RxBool tuesdaySelected = true.obs;

  Rx<TextEditingController> wednesdayController = TextEditingController().obs;
  Rx<FocusNode> wednesdayFocusNode = FocusNode().obs;
  RxBool wednesdaySelected = true.obs;

  Rx<TextEditingController> thursdayController = TextEditingController().obs;
  Rx<FocusNode> thursdayFocusNode = FocusNode().obs;
  RxBool thursdaySelected = true.obs;

  Rx<TextEditingController> fridayController = TextEditingController().obs;
  Rx<FocusNode> fridayFocusNode = FocusNode().obs;
  RxBool fridaySelected = true.obs;

  Rx<TextEditingController> saturdayController = TextEditingController().obs;
  Rx<FocusNode> saturdayFocusNode = FocusNode().obs;
  RxBool saturdaySelected = true.obs;

  Rx<TextEditingController> sundayController = TextEditingController().obs;
  Rx<FocusNode> sundayFocusNode = FocusNode().obs;
  RxBool sundaySelected = true.obs;

  var currentSelectedValue = ''.obs;

  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseForDeletePitch =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  editTurfDetails(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.editTurfDetails(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  deletePitchDetails(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.deletePitchDetails(authToken, requestBody);
      baseResponseForDeletePitch.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class AddTurfGroundDataViewModel extends GetxController {
  Rx isLoading = false.obs;

  Rx<TextEditingController> turf_NameController = TextEditingController().obs;
  Rx<FocusNode> turf_NameFocusNode = FocusNode().obs;
  RxBool turf_NameSelected = true.obs;

  Rx<TextEditingController> turf_LocationController =
      TextEditingController().obs;
  Rx<FocusNode> turf_LocationFocusNode = FocusNode().obs;
  RxBool turf_LocationSelected = true.obs;

  Rx<TextEditingController> turf_AreaSqController = TextEditingController().obs;
  Rx<FocusNode> turf_AreaSqFocusNode = FocusNode().obs;
  RxBool turf_AreaSqSelected = true.obs;

  Rx<TextEditingController> turf_HourController = TextEditingController().obs;
  Rx<FocusNode> turf_HourFocusNode = FocusNode().obs;
  RxBool turf_HourSelected = true.obs;

  Rx<TextEditingController> turf_PerHourController =
      TextEditingController().obs;
  Rx<FocusNode> turf_PerHourFocusNode = FocusNode().obs;
  RxBool turf_PerHourSelected = true.obs;

  Rx<TextEditingController> turf_AboutController = TextEditingController().obs;
  Rx<FocusNode> turf_AboutFocusNode = FocusNode().obs;
  RxBool turf_AboutSelected = true.obs;

  DateTime? selectedDate;

  RxString startDate = "".obs;
  RxString endDate = "".obs;

  Rx<XFile?> image = Rx<XFile?>(null);
  RxList<XFile?> imageList = <XFile?>[].obs;
  RxList<String> uploadImageData = <String>[].obs;
  RxString street = "".obs;
  RxString subLocality = "".obs;
  RxString locality = "".obs;
  RxString postalCode = "".obs;
  RxString country = "".obs;
  RxString state = "".obs;
  RxString lat = "".obs;
  RxString lng = "".obs;

  RxList<TurfPitchDetail> turfPitchSelectList = <TurfPitchDetail>[].obs;
  Rx<TextEditingController> streetController = TextEditingController().obs;
  Rx<FocusNode> streetFocusNode = FocusNode().obs;
  RxBool streetSelected = true.obs;
  Rx<TextEditingController> subLocalityController = TextEditingController().obs;
  Rx<FocusNode> subLocalityFocusNode = FocusNode().obs;
  RxBool subLocalitySelected = true.obs;

  Rx<TextEditingController> localityController = TextEditingController().obs;
  Rx<FocusNode> localityFocusNode = FocusNode().obs;
  RxBool localitySelected = true.obs;

  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<FocusNode> stateFocusNode = FocusNode().obs;
  RxBool stateSelected = true.obs;

  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<FocusNode> countryFocusNode = FocusNode().obs;
  RxBool countrySelected = true.obs;

  Rx<TextEditingController> postalCodeController = TextEditingController().obs;
  Rx<FocusNode> postalCodeFocusNode = FocusNode().obs;
  RxBool postalCodeSelected = true.obs;

  Rx<TextEditingController> pitchController = TextEditingController().obs;
  Rx<FocusNode> pitchFocusNode = FocusNode().obs;
  RxBool pitchSelected = true.obs;

  Rx<TextEditingController> mondayController = TextEditingController().obs;
  Rx<FocusNode> mondayFocusNode = FocusNode().obs;
  RxBool mondaySelected = true.obs;

  Rx<TextEditingController> tuesdayController = TextEditingController().obs;
  Rx<FocusNode> tuesdayFocusNode = FocusNode().obs;
  RxBool tuesdaySelected = true.obs;

  Rx<TextEditingController> wednesdayController = TextEditingController().obs;
  Rx<FocusNode> wednesdayFocusNode = FocusNode().obs;
  RxBool wednesdaySelected = true.obs;

  Rx<TextEditingController> thursdayController = TextEditingController().obs;
  Rx<FocusNode> thursdayFocusNode = FocusNode().obs;
  RxBool thursdaySelected = true.obs;

  Rx<TextEditingController> fridayController = TextEditingController().obs;
  Rx<FocusNode> fridayFocusNode = FocusNode().obs;
  RxBool fridaySelected = true.obs;

  Rx<TextEditingController> saturdayController = TextEditingController().obs;
  Rx<FocusNode> saturdayFocusNode = FocusNode().obs;
  RxBool saturdaySelected = true.obs;

  Rx<TextEditingController> sundayController = TextEditingController().obs;
  Rx<FocusNode> sundayFocusNode = FocusNode().obs;
  RxBool sundaySelected = true.obs;

  var currentSelectedValue = ''.obs;

  final ApiRepository _repository = ApiRepository();

  Rx<ApiResponse> baseResponse =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  Rx<ApiResponse> baseResponseForDeletePitch =
      ApiResponse(responseCode: 0, status: "", response: "").obs;

  editTurfDetails(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.editTurfDetails(authToken, requestBody);
      baseResponse.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  deletePitchDetails(String authToken, Map<String, dynamic> requestBody) async {
    try {
      isLoading(true);
      var fetchedItems =
          await _repository.deletePitchDetails(authToken, requestBody);
      baseResponseForDeletePitch.value = fetchedItems;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
