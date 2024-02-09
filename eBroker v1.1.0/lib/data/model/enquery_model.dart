class EnqueryModel {
  bool? error;
  String? message;
  List<Data>? data;

  EnqueryModel({this.error, this.message, this.data});

  EnqueryModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? schoolName;
  String? name;
  int? mobile;
  String? subject;
  String? description;
  int? pdfStatus;
  dynamic? pdf;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.schoolName,
        this.name,
        this.mobile,
        this.subject,
        this.description,
        this.pdfStatus,
        this.pdf,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    schoolName = json['school_name'];
    name = json['name'];
    mobile = json['mobile'];
    subject = json['subject'];
    description = json['description'];
    pdfStatus = json['pdf_status'];
    pdf = json['pdf'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['school_name'] = this.schoolName;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['pdf_status'] = this.pdfStatus;
    data['pdf'] = this.pdf;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
