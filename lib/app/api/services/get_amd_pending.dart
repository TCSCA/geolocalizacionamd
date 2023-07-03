
import '/app/api/mappings/amd_pending_mapping.dart';

abstract class GetAmdPendingService {
  Future<AmdPendingMap?> doGetAmdPending();
}
