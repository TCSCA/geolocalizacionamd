import 'package:geolocalizacionamd/app/api/mappings/success_save_rejection_mapping.dart';

abstract class SaveRejectionService {
  Future<SaveRejectionModel> saveRejectionService(
    final String tokenUser,
    final String comment,
    final int idHomeServiceAttention,
    final int idReasonReject,
  );
}
