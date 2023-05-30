class AmdPendingModel {
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

  AmdPendingModel(
      {
        required this.orderTime,
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
}
