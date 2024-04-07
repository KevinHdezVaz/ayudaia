import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/statistics_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class StatisticsController extends GetxController {
  Rx<StatisticsData> statisticsData = StatisticsData().obs;

  @override
  void onInit() {
    getStatistics();
    super.onInit();
  }

  getStatistics() async {
    await getStatisticsData();
  }

  RxBool isLoading = true.obs;

  Future<dynamic> getStatisticsData() async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_type':
            Preferences.getBoolean(Preferences.isLogin) ? "app" : "guest",
        'user_id': Preferences.getBoolean(Preferences.isLogin)
            ? Preferences.getString(Preferences.userId)
            : "",
        'device_id': Preferences.getBoolean(Preferences.isLogin) == false
            ? Preferences.getString(Preferences.deviceId)
            : "",
      };

      log(bodyParams.toString());
      final response = await http.post(Uri.parse(ApiServices.getAllstatistics),
          headers: ApiServices.authHeader, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        StatisticsModel model = StatisticsModel.fromJson(responseBody);
        statisticsData.value = model.data!;
        print('======>');
        print('======>${statisticsData.value.chatRequest}');
        isLoading.value = false;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        isLoading.value = false;
      } else if (response.statusCode == 401 &&
          responseBody['response_time'] != "") {
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
