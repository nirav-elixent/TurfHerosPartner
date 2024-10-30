import 'package:turf_heros_owner/model/baseResponse.dart';
import 'package:turf_heros_owner/network%20common/api_service.dart';

class ApiRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> loginWithNumber(Map<String, dynamic> requestBody) {
    return _apiService.loginWithWhatsappNumber(requestBody);
  }

  Future<ApiResponse> otpVerify(Map<String, dynamic> requestBody) {
    return _apiService.otpVerification(requestBody);
  }
Future<ApiResponse> sportData() {
    return _apiService.sportListData();
  }

Future<ApiResponse> facilityData() {
    return _apiService.facilitiesListData();
  }

Future<ApiResponse> turfListData(String authToken,String searchString) {
    return _apiService.turfListData(authToken,searchString);
  }

 Future<ApiResponse> turfBookingList(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.turfBookingListData(authToken,requestBody);
  }
Future<ApiResponse> turfCouponist(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.turfCouponListData(authToken,requestBody);
  }
Future<ApiResponse> turfCreateCoupon(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.turfCreateCouponData(authToken,requestBody);
  }

Future<ApiResponse> deleteCoupon(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.deleteCouponData(authToken,requestBody);
  }

  Future<ApiResponse> userDetails(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.userDetailsData(authToken,requestBody);
  }

  Future<ApiResponse> loadBookingAvailableSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.loadBookingAvailableSlotData(authToken,requestBody);
  }

    Future<ApiResponse> bookSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.bookSlotData(authToken,requestBody);
  }

      Future<ApiResponse> bulkBookSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.bulkBookSlotData(authToken,requestBody);
  }

    Future<ApiResponse> allBookingSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.allBookingSlotData(authToken,requestBody);
  }

      Future<ApiResponse> myDetails(String authToken) {
    return _apiService.myDetailsData(authToken);
  }

      Future<ApiResponse> bookingTransactionList(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.bookingTransactionListData(authToken,requestBody);
  }

        Future<ApiResponse> manageTimeSlotList(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.manageTimeSlotDateListData(authToken,requestBody);
  }


        Future<ApiResponse> updatePrice(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.updatePriceData(authToken,requestBody);
  }

        Future<ApiResponse> deleteTimeSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.deleteTimeSlotData(authToken,requestBody);
  }

        Future<ApiResponse> editTurfDetails(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.editTurfDetailsData(authToken,requestBody);
  }

      Future<ApiResponse> deletePitchDetails(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.deletePitchDetailsData(authToken,requestBody);
  }
  Future<ApiResponse> userDetailsUpdate(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.userDetailsUpdateData(authToken,requestBody);
  }


   Future<ApiResponse> reportLink(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.reportData(authToken,requestBody);
  }


     Future<ApiResponse> blockTimeSlot(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.blockTimeSlotData(authToken,requestBody);
  }


     Future<ApiResponse> deleteTurf(String authToken,Map<String, dynamic> requestBody) {
    return _apiService.deleteTurfData(authToken,requestBody);
  }

}