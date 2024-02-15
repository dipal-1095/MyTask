import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginusingsharedpref/api_data_detail.dart';

class ApiDataItemFetch extends StatefulWidget {
  const ApiDataItemFetch({Key? key}) : super(key: key);

  @override
  State<ApiDataItemFetch> createState() => _ApiDataItemState();
}

class _ApiDataItemState extends State<ApiDataItemFetch> {
  late List<Photos> photoList;
  late bool _error;
  late bool _isLoading;
  late int _pageNumber;
  final int _numberOfPostPerRequest = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    photoList = [];
    _error = false;
    _isLoading = false;
    _scrollController.addListener(_scrollListener);
    _fetchPhotos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPhotos();
    }
  }

  Future<void> _fetchPhotos() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(
          'https://jsonplaceholder.typicode.com/photos?_page=$_pageNumber&_limit=$_numberOfPostPerRequest'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Photos> fetchedPhotos = data.map<Photos>((photoData) {
          return Photos(
            title: photoData['title'],
            id: photoData['id'],
            url: photoData['url'],
          );
        }).toList();

        setState(() {
          photoList.addAll(fetchedPhotos);
          _pageNumber++;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error fetching photos: $e');
      setState(() {
        _error = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: Text(
            'ItemDetails',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.amber,
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildBody(),
          ),
        ));
  }

  Widget _buildBody() {
    if (_error) {
      return _buildErrorWidget();
    } else {
      return Stack(
        children: [
          _buildGridView(),
          if (_isLoading) _buildLoadingIndicator(),
        ],
      );
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred while fetching photos.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = false;
                _isLoading = true;
                photoList.clear();
              });
              _fetchPhotos();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      itemCount: photoList.length + (_isLoading ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 350,
      ),
      itemBuilder: (context, index) {
        if (index < photoList.length) {
          return _buildPhotoItem(photoList[index], index);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPhotoItem(Photos photo, int index) {
    return InkWell(
      child: Container(
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
              child: Image.network(
                photo.url,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Notes ID: ${photo.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        var push = Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ApiDataDetail(
                      item: photo,
                    )));
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Photos {
  final String title;
  final int id;
  final String url;

  Photos({required this.title, required this.id, required this.url});
}
