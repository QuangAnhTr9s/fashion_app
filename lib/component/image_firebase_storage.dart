import 'package:flutter/material.dart';

import '../network/fire_base/fire_storage.dart';

class ImagesFireBaseStore extends StatelessWidget {
  final String urlImage;
  final BoxFit fit;

  // final double height;
  // final double width;

  const ImagesFireBaseStore(
      {super.key, required this.urlImage, required this.fit});

  @override
  Widget build(BuildContext context) {
    FireStorage fireStorage = FireStorage();
    return FutureBuilder(
      future: fireStorage.downloadURL(urlImage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final imageURL = snapshot.data!;
          return Image.network(
            imageURL,
            fit: fit,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }
        return Container();
      },
    );
  }
}
