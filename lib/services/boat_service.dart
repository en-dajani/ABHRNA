import 'package:abhrna/models/boat_model.dart';
import 'package:abhrna/services/firestore_service.dart';

class BoatService extends FirestoreService<BoatModel> {
  BoatService()
    : super(
        collection: 'boats',
        fromMap: (map) => BoatModel.fromMap(map),
        toMap: (boat, {forUpdate = false}) => boat.toMap(forUpdate: forUpdate),
      );
}
