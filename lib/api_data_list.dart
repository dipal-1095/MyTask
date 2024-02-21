import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiDataItem extends StatefulWidget {
  const ApiDataItem({super.key});

  @override
  State<ApiDataItem> createState() => _ApiDataItemState();
}

class _ApiDataItemState extends State<ApiDataItem> {
  List<Photos> photoList = [];

  Future<List<Photos>> getPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        Photos photos = Photos(title: i['title'], id: i['id'], url: i['url']);
        photoList.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text(
          'ItemDetails',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: getPhotos(),
          builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: photoList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 350),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.orange.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: InkWell(
                                child: Image(
                                  image: NetworkImage(snapshot.data![index].url.toString()),
                                  height: 180,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![index].title.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .merge(
                                        TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins'),
                                      ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                 'Notes ID:'+snapshot.data![index].id.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .merge(
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
              );
          }),
    );
  }
}

class Photos {
  String title, url;
  int id;
  Photos({required this.title, required this.id, required this.url});
}
