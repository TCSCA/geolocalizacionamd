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
      required this.linkAmd});

  factory HomeServiceMap.fromJson(Map<String, dynamic> json) => HomeServiceMap(
        idHomeService: json["idHomeService"],
        idMedicalOrder: json["idMedicalOrder"],
        orderNumber: json["orderNumber"],
        registerDate: RegisterDate.fromJson(json["registerDate"]),
        fullNamePatient: json["fullNamePatient"],
        documentType: json["documentType"],
        identificationDocument: json["identificationDocument"],
        phoneNumberPatient: json["phoneNumberPatient"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        applicantDoctor: json["applicantDoctor"],
        phoneNumberDoctor: json["phoneNumberDoctor"],
        typeService: json["typeService"],
        linkAmd: json["linkAmd"] ?? '',
      );
}
