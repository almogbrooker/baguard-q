import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  final ImageProvider image;

  const BackgroundImageWidget({
    Key? key,
    required this.image,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        
      color: Colors.white,//Colors.green.shade500, //Color.fromRGBO(20, 112, 104, 0.8),
        image: DecorationImage(

          alignment: Alignment.bottomLeft,
          image: image,
          scale: 2.4,
          //fit: BoxFit.cover,
          //colorFilter: ColorFilter.mode(
            //Colors.black.withOpacity(0.2),
            //BlendMode.darken,
           // Color.fromRGBO(20, 112, 104, 0.8),
          //),
        ),
      ),
      child: child,
    );
  }
}
