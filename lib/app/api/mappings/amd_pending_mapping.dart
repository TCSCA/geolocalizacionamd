class AmdPendingMap {
  String orderTime;
  int orderId;
  String patientName;
  String idDocumentationPatient;
  String phonePatient;
  String state;
  String city;
  String direction;
  String doctorName;
  String phoneDoctor;
  String serviceType;

  AmdPendingMap(
      {required this.orderTime,
      required this.orderId,
      required this.patientName,
      required this.idDocumentationPatient,
      required this.phonePatient,
      required this.state,
      required this.city,
      required this.direction,
      required this.doctorName,
      required this.phoneDoctor,
      required this.serviceType});

  factory AmdPendingMap.fromJson(Map<String, dynamic> json) => AmdPendingMap(
      orderTime: json['orderTime'] ?? '',
      orderId: json['orderId'] ?? 0,
      patientName: json['patientName'] ?? '',
      idDocumentationPatient: json['idDocumentationPatient'] ?? '',
      phonePatient: json['phonePatient'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      direction: json['direction'] ?? '',
      doctorName: json['doctorName'] ?? '',
      phoneDoctor: json['phoneDoctor'] ?? '',
      serviceType: json['serviceType'] ?? '');
}
