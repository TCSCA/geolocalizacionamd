class ReasonRejectionMap {
  int idReasonRejection;
  String reasonForRejection;
  int typeReasonRejection;

  ReasonRejectionMap(
      {required this.idReasonRejection,
      required this.reasonForRejection,
      required this.typeReasonRejection});

  factory ReasonRejectionMap.fromJson(Map<String, dynamic> json) =>
      ReasonRejectionMap(
          idReasonRejection: json['idReasonRejection'] ?? 0,
          reasonForRejection: json['reasonForRejection'] ?? '',
          typeReasonRejection: json['typeReasonRejection'] ?? 0);
}
