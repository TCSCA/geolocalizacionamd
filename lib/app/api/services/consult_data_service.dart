
import '../mappings/amd_pending_mapping.dart';

abstract class ConsultDataService {
  Future<AmdPendingMap?> doGetAmdPending();
}

