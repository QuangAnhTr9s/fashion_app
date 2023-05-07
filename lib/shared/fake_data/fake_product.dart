import 'package:fashion_app/network/images/fire_storage_images.dart';

import '../../models/product.dart';

class FakeProduct {
  List<Product> listProduct = [
    Product(
        id: 1,
        name: 'Cotton canvas and GG Supreme jacket',
        price: 4100,
        urlPhoto: List.from(FireImages().cottonCanvasAndGGSupremeJacket),
        description:
            'The jacket, a signature Gucci item, continues to be a staple throughout the Spring Summer 2023 creating a new idea of daywear that reflects the House’s aesthetic. Part of the selection, the style is crafted from dark grey cotton canvas and defined by beige and ebony GG Supreme canvas inserts.',
        sizes: ['S', 'M', 'L'],
        colors: [0xff36454f]),
    Product(
        id: 2,
        name: 'Linen canvas jacket',
        price: 4200,
        urlPhoto: List.from(FireImages().gucciLinenCanvasJacket),
        description:
            'The Spring Summer 2023 collection looks at the concept of tailoring with a new lens. Classic silhouettes are reinterpreted, combining minimal jackets with cues from the 1990s, including lingerie inspirations, for an innovative update of the wardrobe. This asymmetrical jacket is presented in an off white linen, further defined by contrasting piping and a leather belt.',
        sizes: ['S', 'M', 'L', 'XL'],
        colors: [0xfffdeedb]),
    Product(
        id: 3,
        name: 'Geared Shorts',
        price: 30,
        urlPhoto: List.from(FireImages().gearedShortsImages),
        description:
            'Lightweight nylon with added water resistance. Tough, practical pants with many handy details.',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        colors: [0xffe3d6c5, 0xff000000, 0xff576fa4, 0xff808000, 0xffffa500]),
    Product(
        id: 4,
        name: 'Women Dry-ex Crew Neck Short Sleeve T',
        price: 17,
        urlPhoto: List.from(FireImages().womenDryExCrewNeckShortSleeveTImages),
        description:
            "Our high-performance 'DRY-EX' T-shirt. With a natural texture for a casual style.",
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        colors: [0xff000000, 0xff88e9e5, 0xffffc0cb, 0xffffffff]),
    Product(
        id: 5,
        name: 'Sweat Long Sleeve Full-Zip Hoodie',
        price: 35,
        urlPhoto: List.from(FireImages().sweatLongSleeveFullZipHoodieImages),
        description:
            'The material, cut, and details have all evolved. Vintage-inspired with a modern fit.',
        sizes: [
          'M',
          'L',
        ],
        colors: [
          0xff000000,
          0xff677dad,
          0xff808080,
          0xff4c5a4b,
          0xffffffff,
        ]),
  ];
}
// List<String> covertColorToHex(List<String> listImages){
//   //get color
//   List<String> listColors = listImages.map((image) => image.split('/').last.split('_').first).toList();
//   List<String> hexColors = listColors.map((color) {
//       String hex = ColorUtils.intToHex(color);
//       return hex;
//
//   }).toList();
//   return hexColors;
// }
