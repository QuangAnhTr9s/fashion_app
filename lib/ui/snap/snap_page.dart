import 'package:flutter/material.dart';
import 'package:fashion_app/shared/const/images.dart';
class SnapPage extends StatefulWidget {
  const SnapPage({super.key});

  @override
  State<SnapPage> createState() => _SnapPageState();
}

class _SnapPageState extends State<SnapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // exploreU19 (1:1825)
            padding:  const EdgeInsets.fromLTRB(0, 0, 0, 201),
            width:  double.infinity,
            decoration:  const BoxDecoration (
              color:  Color(0xffffffff),
            ),
            child:
            Column(
              crossAxisAlignment:  CrossAxisAlignment.center,
              children:  [
                Container(
                  // autogroupnp2tHUP (3NVz6Ez28kv5jNYrLfnP2T)
                  margin:  const EdgeInsets.fromLTRB(0, 0, 0, 54),
                  width:  586,
                  height:  686,
                  child:
                  Image.asset(
                   MyImages.snapPicture,
                    width:  586,
                    height:  686,
                  ),
                ),
                Container(
                  // exploretheappkcs (1:1831)
                  margin:  const EdgeInsets.fromLTRB(0, 0, 29, 11),
                  child:
                  const Text(
                    'Explore the app',
                    style:  TextStyle (
                      fontSize:  20,
                      fontWeight:  FontWeight.w500,
                      height:  1.26,
                      color:  Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  // loremipsumdolorsitametconsecte (1:1832)
                  margin:  const EdgeInsets.fromLTRB(0, 0, 13, 51),
                  constraints:  const BoxConstraints (
                    maxWidth:  328,
                  ),
                  child:
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi maecenas quis interdum enim enim molestie faucibus. Pretium non non massa eros, nunc, urna. Ac laoreet sagittis donec vel. Amet, duis justo, quam quisque egestas. Quam enim at dictum condimentum. Suspendisse.',
                    textAlign:  TextAlign.center,
                    style:  TextStyle (
                      fontSize:  12,
                      fontWeight:  FontWeight.w400,
                      height:  1.26,
                      color:  Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  // autogroupafkfirX (3NVzGjgXtaS6VPexfEAfkf)
                  margin:  const EdgeInsets.fromLTRB(37, 0, 53, 0),
                  width:  double.infinity,
                  height:  48,
                  decoration:  BoxDecoration (
                    color:  const Color(0xff0e0d0d),
                    borderRadius:  BorderRadius.circular(8),
                  ),
                  child:
                  const Center(
                    child:
                    Text(
                      'Lets Start',
                      style:  TextStyle (
                        fontSize:  20,
                        fontWeight:  FontWeight.w500,
                        height:  1.26,
                        color:  Color(0xfffcf9f9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
