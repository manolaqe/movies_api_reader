import 'package:flutter/material.dart';

class PhotosWidget extends StatefulWidget {
  const PhotosWidget({super.key, required this.movie});

  final Map<String, dynamic> movie;

  @override
  State<PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  String shownPictureUrl = '';
  @override
  void initState() {
    shownPictureUrl = widget.movie['large_cover_image'] as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(
          child: SizedBox(
        height: 500,
        width: 500,
        child: Image.network(shownPictureUrl),
      )),
      const SizedBox(
        height: 20,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  shownPictureUrl = widget.movie['background_image'] as String;
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(height: 100, widget.movie['background_image'] as String)),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  shownPictureUrl = widget.movie['background_image_original'] as String;
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(height: 100, widget.movie['background_image_original'] as String)),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  shownPictureUrl = widget.movie['small_cover_image'] as String;
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                      Image.network(fit: BoxFit.fitHeight, height: 100, widget.movie['small_cover_image'] as String)),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  shownPictureUrl = widget.movie['medium_cover_image'] as String;
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(height: 100, widget.movie['medium_cover_image'] as String)),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  shownPictureUrl = widget.movie['large_cover_image'] as String;
                });
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(height: 100, widget.movie['large_cover_image'] as String)),
            ),
          ],
        ),
      )
    ]);
  }
}
