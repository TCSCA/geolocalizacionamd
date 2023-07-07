import 'package:geolocalizacionamd/app/api/mappings/reason_rejection_mapping.dart';

abstract class ReasonRejectionService {
  Future<ReasonRejectionMapping> getReasonRejection(final String tokenUser);
}
