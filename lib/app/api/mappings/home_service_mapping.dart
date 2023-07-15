import 'register_date_mapping.dart';

class HomeServiceMap {
  int idHomeService;
  int idMedicalOrder;
  String orderNumber;
  RegisterDate registerDate;
  String fullNamePatient;
  String documentType;
  String identificationDocument;
  String phoneNumberPatient;
  String address;
  String latitude;
  String longitude;
  String applicantDoctor;
  String phoneNumberDoctor;
  String typeService;
  String linkAmd;
  int idStatusHomeService;
  String statusHomeService;

  HomeServiceMap(
      {required this.idHomeService,
      required this.idMedicalOrder,
      required this.orderNumber,
      required this.registerDate,
      required this.fullNamePatient,
      required this.documentType,
      required this.identificationDocument,
      required this.phoneNumberPatient,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.applicantDoctor,
      required this.phoneNumberDoctor,
      required this.typeService,
      required this.linkAmd,
      required this.idStatusHomeService,
      required this.statusHomeService});

  factory HomeServiceMap.fromJson(Map<String, dynamic> json) => HomeServiceMap(
        idHomeService: json["data"]["idHomeService"] ?? 0,
        idMedicalOrder: json["data"]["idMedicalOrder"] ?? 0,
        orderNumber: json["data"]["orderNumber"] ?? '',
        registerDate: RegisterDate.fromJson(json["data"]["registerDate"]),
        fullNamePatient: json["data"]["fullNamePatient"] ?? '',
        documentType: json["data"]["documentType"] ?? '',
        identificationDocument: json["data"]["identificationDocument"] ?? '',
        phoneNumberPatient: json["data"]["phoneNumberPatient"] ?? '',
        address: json["data"]["address"] ?? '',
        latitude: json["data"]["latitude"] ?? '',
        longitude: json["data"]["longitude"] ?? '',
        applicantDoctor: json["data"]["applicantDoctor"] ?? '',
        phoneNumberDoctor: json["data"]["phoneNumberDoctor"] ?? '',
        typeService: json["data"]["typeService"] ?? '',
        linkAmd: json["data"]["linkAmd"] ?? '',
        idStatusHomeService: json["data"]["idStatusHomeService"] ?? 0,
        statusHomeService: json["data"]["statusHomeService"] ?? '',
      );
}
