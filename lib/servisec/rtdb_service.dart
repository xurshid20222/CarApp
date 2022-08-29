import 'package:firebase_database/firebase_database.dart';

import '../models/car_model.dart';

class RTDBService {
  static final database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> storeCar(CarModel car) async {
    String? key = database.child("cars").push().key;
    car.carKey = key!;
    await database.child("cars").child(car.carKey).set(car.toJson());
    return database.onChildAdded;
  }

  static Future<List<CarModel>> loadCars() async {
    List<CarModel> items = [];
    Query query = database.child("cars");
    var snapshot = await query.once();
    var result = snapshot.snapshot.children;

    for(DataSnapshot item in result) {
      if(item.value != null) {
        items.add(CarModel.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }

    return items;
  }

  static Future<void> deleteCars(String postKey) async {
    await database.child("cars").child(postKey).remove();
  }

  static Future<Stream<DatabaseEvent>> updateCars(CarModel car) async {
    await database.child("cars").child(car.carKey).set(car.toJson());
    return database.onChildAdded;
  }
}