import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loginusingsharedpref/api_item_fetch.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({super.key});

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  late List<Photos> photoList;
  final _numberOfPostPerRequest = 10;
  final PagingController<int, Photos> _pagingController =
      PagingController(firstPageKey: 0);

  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPhotos(pageKey);
    });
    super.initState();
  }

  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<Photos>> _getPhotos(int pageKey) async {
    try {
      final response = await http.get(Uri.parse(
          'https://jsonplaceholder.typicode.com/photos?_page=$pageKey&_limit=$_numberOfPostPerRequest'));
      var data = jsonDecode(response.body.toString());
      List<Photos> photoList = []; // Create a list to hold photos
      if (response.statusCode == 200) {
        for (Map i in data) {
          Photos photos = Photos(title: i['title'], id: i['id'], url: i['url']);
          photoList.add(photos); // Add each photo to the list
        }
      }
      final isLastPage = photoList.length < _numberOfPostPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(photoList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(photoList, nextPageKey);
      }
      return photoList; // Return the list of photos
    } catch (e) {
      print('error-->');
      _pagingController.error(e);
      // Since an error occurred, you might want to throw the error
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ItemDetails',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Photos>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) => Padding(
              padding: EdgeInsets.all(15.0),
              child: ApiDataItemFetch(),
            ),
          ),
        ),
      ),
    );
  }

}
