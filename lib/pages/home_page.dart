import 'dart:io';
import 'package:car_app/pages/description_page.dart';
import 'package:car_app/servisec/remote_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/car_model.dart';
import '../servisec/rtdb_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";
  CarModel? car;

  HomePage({Key? key, this.car}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  bool isLoading = false;
  bool bottomSheet = false;
  List<CarModel> items = [];

  @override
  void initState() {
    super.initState();
    _getAllPost();
  }

  void _getAllPost() async {
    isLoading = true;
    setState(() {});

    items = await RTDBService.loadCars();

    // remote config
    await RemoteService.initConfig();

    isLoading = false;
    setState(() {});
  }

  void _openDetailPage() {
    Navigator.pushNamed(context, DetailPage.id);
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
                onPressed: () => _deletePost(postKey),
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
                onPressed: () => _deletePost(postKey),
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

  void _deletePost(String carCey) async {
    Navigator.pop(context);
    isLoading = true;
    setState(() {});

    await RTDBService.deleteCars(carCey);
    _getAllPost();
  }

  void _editPost(CarModel car) {
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

  void _description(CarModel car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DescriptionPage(
            state: DetailState.read,
            car: car,
          );
        },
      ),
    );
  }

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CarApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    _getAllPost();
    super.didPopNext();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: bottomSheet ? showButtonSheet(widget.car!) : null,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:
            RemoteService.themeBackgroundColors[RemoteService.defaultBKColor],
        title: const Icon(
          CupertinoIcons.car_detailed,
          size: 70,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            // physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _itemOfList(items[index]);
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child:  CircularProgressIndicator(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            RemoteService.themeBackgroundColors[RemoteService.defaultBKColor],
        onPressed: _openDetailPage,
        child: const Icon(
          CupertinoIcons.car_detailed,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _itemOfList(CarModel car) {
    return Row(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.only(right: 70, left: 10, top: 20),
          color:
              RemoteService.themeBackgroundColors[RemoteService.defaultBKColor],
          child: Container(
            // color: Colors.red,
            padding: const EdgeInsets.only(left: 10),
            height: 600,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),

                //#CAR NAME and #MORE ACTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //#carNmae
                    Text(
                      car.carName,
                      style: TextStyle(
                          color: RemoteService.themeTextColors[RemoteService.defaultTextColor],
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),

                    //#more_horiz
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: IconButton(
                        onPressed: () {
                          _showBottom(car);
                        },
                        splashRadius: 25,
                        icon: RemoteService.changesIcons[RemoteService.defaultIconColor],
                      ),
                    )
                  ],
                ),
                //#company
                Text(
                  car.company,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),

                //#image
                Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(right: 20,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 340,
                  width: 270,
                  child: car.image != null
                      ? PageView(
                    children: List.generate(car.image.length, (index) => Image.network(
                      car.image[index],
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
                const SizedBox(
                  height: 30,
                ),

                //#View Button
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                    onPressed:  () => _description(car),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        minimumSize: const Size(250, 50)),
                    child: const Text("View",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
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
                      _editPost(car);
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
                    onPressed: (){},
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


