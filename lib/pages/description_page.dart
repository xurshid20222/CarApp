import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/car_model.dart';
import '../servisec/rtdb_service.dart';
import 'detail_page.dart';

class DescriptionPage extends StatefulWidget {
  static const id = 'desc_page';
  final DetailState state;
  late CarModel? car;

  DescriptionPage({Key? key, this.car, this.state = DetailState.read})
      : super(key: key);

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool bottomSheet = false;
  bool isLoading = false;

  void _showBottom(CarModel car) {
    bottomSheet = true;
    widget.car = car;
    showButtonSheet(car);
    setState(() {});
  }

  void _showBottomCancel() {
    bottomSheet = false;
    setState(() {});
  }

  void _deleteDialog(String postKey) async {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text("Delete Car"),
            content: const Text("Do you want to delete this car?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () => _deleteCar(postKey),
                child: const Text("Delete"),
              ),
              CupertinoDialogAction(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Delete Car"),
            content: const Text("Do you want to delete this car?"),
            actions: [
              TextButton(
                onPressed: () => _deleteCar(postKey),
                child: const Text("Delete"),
              ),
              TextButton(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        }
      },
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _deleteCar(String carCey) async {
    Navigator.pop(context);
    isLoading = true;
    setState(() {});

    await RTDBService.deleteCars(carCey);
    if (mounted) Navigator.of(context).pop();
  }

  void _editCar(CarModel car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DetailPage(
            state: DetailState.update,
            car: car,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: bottomSheet ? showButtonSheet(widget.car!) : null,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 35,
            onPressed: () => _showBottom(widget.car!),
            icon: const Icon(
              Icons.more_horiz_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        // alignment: Alignment.bottomCenter,
        children: [
          //image
          Container(
            // color: Colors.red,
            height: 450,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            foregroundDecoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.1),
                    ])),
            child: widget.car!.image != null
                ? PageView(
                    children: List.generate(
                        widget.car!.image.length,
                        (index) => Image.network(
                              widget.car!.image[index], //todo
                              fit: BoxFit.cover,
                            )),
                  )
                : const Image(
                    image: AssetImage(
                      "assets/images/plesxolder.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                height: 200,
                padding: const EdgeInsets.only(left: 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text(
                        'Information',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //#name
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Name:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: widget.car!.carName,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //#company
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Company:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: widget.car!.company,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //#description
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Description:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: widget.car!.description,
                            ),
                          ]),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //#Speed
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Speed:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: widget.car!.speed,
                            ),
                          ]),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //#energy
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Energy:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: widget.car!.energy,
                            ),
                          ]),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //#price
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(
                                text: 'Price:  ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 20)),
                            TextSpan(
                              style: const TextStyle(color: Colors.blue),
                              text: '\$${widget.car!.price}',
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showButtonSheet(CarModel car) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(left: 30, right: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: _showBottomCancel,
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.cart_fill_badge_plus,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  const Text(
                    'Buy',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _editCar(car);
                    },
                    icon: const Icon(CupertinoIcons.settings_solid,
                        size: 40, color: Colors.white),
                  ),
                  const Text(
                    'Edit',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    'Share',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _deleteDialog(car.carKey);
                    },
                    icon: const Icon(
                      CupertinoIcons.delete,
                      size: 35,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
