class ReasonRejectionModel {
  final String status;
  List<Datum> data;

  ReasonRejectionModel({
    required this.status,
    required this.data,
  });
}

class Datum {
  final int idReasonRejection;
  final String reasonForRejection;
  final int typeReasonRejection;

  Datum({
    required this.idReasonRejection,
    required this.reasonForRejection,
    required this.typeReasonRejection,
  });
}
