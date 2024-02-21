import 'package:flutter/material.dart';
import 'package:loginusingsharedpref/data_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List item = [
    Data(
        image: "assets/images/item1.jpg",
        title: 'Cotton Salwar Suit Dress',
        price: "\₹669"),
    Data(
        image: "assets/images/item12.jpg",
        title: 'Rose Gold Necklace',
        price: "\₹500"),
    Data(
        image: "assets/images/item9.jpg",
        title: 'Kids South Indian Clothes',
        price: "\₹600"),
    Data(
        image: "assets/images/item8.jpg",
        title: 'Blue Shoes For Man',
        price: "\₹1000"),
    Data(
        image: "assets/images/item5.jpg",
        title: 'Diamond Bracelet',
        price: "\₹700"),
    Data(image: "assets/images/item2.jpg", title: 'Earring', price: "\₹300"),
    Data(
        image: "assets/images/item4.jpg",
        title: 'Golden Bracelet',
        price: "\₹250"),
    Data(
        image: "assets/images/item3.jpg",
        title: 'Simple Earring',
        price: "\₹200"),
    Data(
        image: "assets/images/item6.jpg",
        title: 'Simple Bracelet',
        price: "\₹400"),
    Data(
        image: "assets/images/item7.jpg",
        title: 'White Shoes',
        price: "\₹1200"),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 300),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blue.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: Image(
                        image: AssetImage(item[index].image),
                        height: 180,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item[index].title,
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            item[index].price,
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Colors.grey.shade600),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
