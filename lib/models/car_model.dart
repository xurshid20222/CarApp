class CarModel {
  late String carKey;
  // late String id;
  late String carName;
  late String company;
  late String price;
  late String description;
  late String energy;
  late String speed;
  late String year;
  // String? image;
   late List<String> image;

  CarModel({
    required this.carKey,
    // required this.id,
    required this.carName,
    required this.description,
    required this.year,
    required this.company,
    required this.energy,
    required this.speed,
    required this.price,
     this.image = const[],
    // this.image,
  });

  CarModel.fromJson(Map<String, dynamic> json) {
    carKey = json['carKey'];
    // id = json['id'];
    carName = json['carName'];
    energy = json['energy'];
    speed = json['speed'];
    company = json['company'];
    price = json['price'];
    description = json['description'];
    year = json['year'];
    // image = json['image'];
    image = [];
    if (json['image'] != null) {
      json['image'].forEach((v) {
        image.add(v as String);
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'carKey': carKey,
    // 'id': id,
    'carName': carName,
    'price': price,
    'company': company,
    'description': description,
    'year': year,
    'speed': speed,
    'energy': energy,
    'image': image,
  };
}