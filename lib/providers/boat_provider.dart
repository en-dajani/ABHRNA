import 'package:abhrna/models/boat_model.dart';
import 'package:abhrna/providers/firestore_pagination_provider.dart';
import 'package:abhrna/services/boat_service.dart';

class BoatProvider extends FirestorePaginationProvider<BoatModel> {
  BoatProvider() : super(service: BoatService());
}
