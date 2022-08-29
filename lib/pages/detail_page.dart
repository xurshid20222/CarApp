import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car_model.dart';
import '../servisec/rtdb_service.dart';
import '../servisec/stor_service.dart';
import '../servisec/util_service.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  final DetailState state;
  final CarModel? car;

  const DetailPage({this.state = DetailState.create, this.car, Key? key})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController carNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController energyController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  bool isLoading = false;
  List<File> imageFileList = [];
  List<String> imageNetworkPaths = [];
  CarModel? updateCar;

  // for image
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? files;

  @override
  void initState() {
    super.initState();
    _detectState();
  }

  void _detectState() {
    if (widget.state == DetailState.update && widget.car != null) {
      updateCar = widget.car;
      carNameController.text = updateCar!.carName;
      descriptionController.text = updateCar!.description;
      companyController.text = updateCar!.company;
      priceController.text = updateCar!.price;
      yearController.text = updateCar!.year;
      energyController.text = updateCar!.energy;
      speedController.text = updateCar!.speed;
      setState(() {});
    }
  }

  void _getImage() async {
    final ImagePicker imagePicker = ImagePicker();

    imageFileList = [];
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    print(selectedImages);
    if (selectedImages == null) return;
    for (var i in selectedImages) {
      imageFileList.add(File(i.path));
    }
    print('--------------------------$imageFileList');
    setState(() {
    });

    // var image = await _picker.pickImage(source: ImageSource.gallery);

    // var image = await _picker.pickImage(source: ImageSource.gallery);
    // // List<PickedFile> images = await _picker.pickMultiImage()
    // if (image != null) {
    //   setState(() {
    //     file = File(image.path);
    //
    //   });
    // } else {
    //   if (mounted) Utils.fireSnackBar("Please select image for post", context);
    // }



  }

  void _addPost() async {
    String carName = carNameController.text.trim();
    String description = descriptionController.text.trim();
    String company = companyController.text.trim();
    String price = priceController.text.trim();
    String year = yearController.text.trim();
    String energy = energyController.text.trim();
    String speed = speedController.text.trim();
    String? imageUrl;

    if (carName.isEmpty ||
        description.isEmpty ||
        company.isEmpty ||
        price.isEmpty ||
        year.isEmpty ||
        energy.isEmpty ||
        speed.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});


    if (imageFileList.isNotEmpty) {
      imageNetworkPaths = await StorageService.uploadImages(imageFileList);
    }

    CarModel car = CarModel(
        carKey: "",
        // id: id,
        carName: carName,
        description: description,
        company: company,
        price: price,
        year: year,
        energy: energy,
        speed: speed,
        image: imageNetworkPaths);

    await RTDBService.storeCar(car).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  void _updateCar() async {
    String carName = carNameController.text.trim();
    String description = descriptionController.text.trim();
    String company = companyController.text.trim();
    String price = priceController.text.trim();
    String year = yearController.text.trim();
    String energy = energyController.text.trim();
    String speed = speedController.text.trim();
    String? imageUrl;

    if (carName.isEmpty ||
        description.isEmpty ||
        company.isEmpty ||
        price.isEmpty ||
        energy.isEmpty ||
        speed.isEmpty ||
        year.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }

    CarModel car = CarModel(
        carKey: updateCar!.carKey,
        // id: updateCar!.id,
        carName: carName,
        description: description,
        company: company,
        price: price,
        year: year,
        energy: energy,
        speed: speed,
        image: imageNetworkPaths);

    await RTDBService.updateCars(car).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: widget.state == DetailState.update
            ? const Text("Update Car")
            : const Text("Add Car"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // #image
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      height: 305,
                      width: 305,
                      child: (updateCar != null &&
                          imageFileList.isEmpty)
                          ? Image.network(updateCar!.image.first)
                          : (imageFileList.isEmpty
                          ? const Image(
                        image: AssetImage("assets/images/add_car.png"),
                      )
                          : PageView(
                        children: List.generate(imageFileList.length, (index) => Image.file(imageFileList[index],),),
                      )
                      ),
                    ),
                  ),


                  // #carName
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: carNameController,
                      decoration: const InputDecoration(
                        hintText: "  Car Name",
                          border: InputBorder.none
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #company
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: companyController,
                      decoration: const InputDecoration(
                        hintText: "  Company",
                          border: InputBorder.none
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //description
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: "  Description",
                          border: InputBorder.none
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //#price   // #year
                  Row(
                    children: [
                      //#price
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              hintText: "  Price",
                                border: InputBorder.none
                            ),
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // #year
                     Expanded(
                       child:  Container(
                         height: 50,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: TextField(
                           controller: yearController,
                           decoration: const InputDecoration(
                               hintText: "  Year of manufacture",
                               border: InputBorder.none
                           ),
                           style: const TextStyle(fontSize: 18, color: Colors.black),
                           keyboardType: TextInputType.number,
                           textInputAction: TextInputAction.next,
                         ),
                       ),
                     )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //#speed energy
                  Row(
                    children: [
                      //#price
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: energyController,
                            decoration: const InputDecoration(
                                hintText: "  Energy",
                                border: InputBorder.none
                            ),
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // #year
                      Expanded(
                        child:  Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: speedController,
                            decoration: const InputDecoration(
                                hintText: "  Speed",
                                border: InputBorder.none
                            ),
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // #add_update
                  ElevatedButton(
                    onPressed: () {
                      if (widget.state == DetailState.update) {
                        _updateCar();
                      } else {
                        _addPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade700,
                        minimumSize: const Size(double.infinity, 50)),
                    child: Text(
                      widget.state == DetailState.update ? "Update" : "Add",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

enum DetailState {
  create,
  update,
  read
}
