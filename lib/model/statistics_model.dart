class StatisticsModel {
  String? success;
  String? error;
  StatisticsData? data;

  StatisticsModel({this.success, this.error, this.data});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? StatisticsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StatisticsData {
  String? chatRequest;
  String? chatWordCount;
  String? promsRequest;
  String? promsWordCount;
  String? imageRequest;

  StatisticsData(
      {this.chatRequest,
      this.chatWordCount,
      this.promsRequest,
      this.promsWordCount,
      this.imageRequest});

  StatisticsData.fromJson(Map<String, dynamic> json) {
    chatRequest = json['chat_request'] ?? '';
    chatWordCount = json['chat_word_count'] ?? '';
    promsRequest = json['proms_request'] ?? '';
    promsWordCount = json['proms_word_count'] ?? '';
    imageRequest = json['image_request'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_request'] = chatRequest ?? '';
    data['chat_word_count'] = chatWordCount ?? '';
    data['proms_request'] = promsRequest ?? '';
    data['proms_word_count'] = promsWordCount ?? '';
    data['image_request'] = imageRequest ?? '';
    return data;
  }
}
