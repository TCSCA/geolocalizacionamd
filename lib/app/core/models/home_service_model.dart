class HomeServiceModel {
  int idHomeService;
  int idMedicalOerder;
  String orderNumber;
  DateTime registerDate;
  String fullNamePatient;
  String documentType;
  String identificationDocument;
  String phoneNumberPatient;
  String address;
  String applicantDoctor;
  String phoneNumberDoctor;
  String typeService;
  String linkAmd;
  int idStatusHomeService;
  String statusHomeService;
  String statusLinkAmd;

  HomeServiceModel(
      this.idHomeService,
      this.idMedicalOerder,
      this.orderNumber,
      this.registerDate,
      this.fullNamePatient,
      this.documentType,
      this.identificationDocument,
      this.phoneNumberPatient,
      this.address,
      this.applicantDoctor,
      this.phoneNumberDoctor,
      this.typeService,
      this.linkAmd,
      this.idStatusHomeService,
      this.statusHomeService,
      this.statusLinkAmd);
}
