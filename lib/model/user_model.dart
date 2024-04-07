class UserModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  UserModel({this.success, this.error, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? customerId;
  String? name;
  String? email;
  String? phone;
  String? photo;
  String? status;
  String? writerLimit;
  String? chatLimit;
  String? imageLimit;
  String? createdAt;
  String? updatedAt;
  String? accesstoken;
  String? referralCode;
  String? refferedLimit;

  Data(
      {this.id,
      this.customerId,
      this.name,
      this.email,
      this.phone,
      this.photo,
      this.status,
      this.writerLimit,
      this.chatLimit,
      this.imageLimit,
      this.createdAt,
      this.updatedAt,
      this.accesstoken,
      this.referralCode,
      this.refferedLimit});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photo = json['photo'];
    status = json['status'];
    writerLimit = json['writer_limit'];
    chatLimit = json['chat_limit'];
    imageLimit = json['image_limit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accesstoken = json['accesstoken'];
    referralCode = json['referral_code'];
    refferedLimit = json['reffered_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['photo'] = photo;
    data['status'] = status;
    data['writer_limit'] = writerLimit;
    data['chat_limit'] = chatLimit;
    data['image_limit'] = imageLimit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accesstoken'] = accesstoken;
    data['referral_code'] = referralCode;
    data['reffered_limit'] = refferedLimit;
    return data;
  }
}
