import 'package:fashion_app/network/images/fire_storage_images.dart';

import '../../models/product/product.dart';

class FakeProduct {
  static List<Product> listProduct = [
    Product(
        id: 1,
        name: 'Cotton canvas and GG Supreme jacket',
        price: 4100,
        urlPhoto: List.from(FireImages().cottonCanvasAndGGSupremeJacket),
        store: 'GUCCI',
        description:
            'The jacket, a signature Gucci item, continues to be a staple throughout the Spring Summer 2023 creating a new idea of daywear that reflects the House’s aesthetic. Part of the selection, the style is crafted from dark grey cotton canvas and defined by beige and ebony GG Supreme canvas inserts.',
        typeByGender: 'man',
        category: 'jacket',
        date: '05/09/2022',
        sizes: ['S', 'M', 'L'],
        colors: [0xff36454f]),
    Product(
        id: 2,
        name: 'Linen canvas jacket',
        price: 4200,
        urlPhoto: List.from(FireImages().gucciLinenCanvasJacket),
        store: 'GUCCI',
        description:
            'The Spring Summer 2023 collection looks at the concept of tailoring with a new lens. Classic silhouettes are reinterpreted, combining minimal jackets with cues from the 1990s, including lingerie inspirations, for an innovative update of the wardrobe. This asymmetrical jacket is presented in an off white linen, further defined by contrasting piping and a leather belt.',
        category: 'jacket',
        date: '05/09/2022',
        typeByGender: 'women',
        sizes: ['S', 'M', 'L', 'XL'],
        colors: [0xfffdeedb]),
    Product(
        id: 3,
        name: 'Geared Shorts',
        price: 30,
        urlPhoto: List.from(FireImages().gearedShortsImages),
        store: 'Uniqlo',
        description:
            'Lightweight nylon with added water resistance. Tough, practical pants with many handy details.',
        category: 'shorts',
        date: '01/02/2023',
        typeByGender: 'man',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        colors: [0xffe3d6c5, 0xff000000, 0xff576fa4, 0xff808000, 0xffffa500]),
    Product(
        id: 4,
        name: 'Women Dry-ex Crew Neck Short Sleeve T',
        price: 17,
        urlPhoto: List.from(FireImages().womenDryExCrewNeckShortSleeveTImages),
        store: 'Uniqlo',
        description:
            "Our high-performance 'DRY-EX' T-shirt. With a natural texture for a casual style.",
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        colors: [0xff000000, 0xff88e9e5, 0xffffc0cb, 0xffffffff]),
    Product(
        id: 5,
        name: 'Sweat Long Sleeve Full-Zip Hoodie',
        price: 35,
        urlPhoto: List.from(FireImages().sweatLongSleeveFullZipHoodieImages),
        store: 'Uniqlo',
        description:
            'The material, cut, and details have all evolved. Vintage-inspired with a modern fit.',
        typeByGender: 'men, women',
        category: 'sweatshirts & hoodies',
        date: '01/05/2023',
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
    Product(
        id: 6,
        name: "Just Psych Women's Loose T-shirts With Corn Powder",
        price: 10,
        urlPhoto:
            List.from(FireImages().justPsychWomensLooseTShirtsWithCornPowder),
        store: 'YODY',
        description:
            'Comfortable working with extremely elastic elastic material. Cornstarch cotton yarn accounts for 80%, so the absorbent efficiency is high. High color fastness has polyester fiber from alcohol in corn, so the product has excellent toughness & color.',
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'M',
          'L',
        ],
        colors: [
          0xff000000,
          0xff993299,
          0xff41bdcc,
          0xffffffff,
        ]),
    Product(
        id: 7,
        name: "Women's Zip T-shirt with Neckline",
        price: 10,
        urlPhoto: List.from(FireImages().womensZipTShirtWithNeckline),
        store: 'YODY',
        description:
            "Stylish women's t-shirt for women. Slim design, heart neck helps to accentuate body curves. The stylized neck creates a new highlight for the product. A variety of colors to suit a variety of wearer preferences. The shirt is soft, slightly stretchy and suitable for going out and going to work",
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'S',
          'M',
          'L',
        ],
        colors: [
          0xff000000,
          0xfff7deb6,
          0xff008000,
          0xffff0000,
          0xffffffff,
        ]),
    Product(
        id: 8,
        name: "Bamboo Heart Neck T-shirt for Women",
        price: 10,
        urlPhoto: List.from(FireImages().bambooHeartNeckTShirtForWomen),
        store: 'YODY',
        description:
            "Women's T-shirt Bamboo material: 95% Bamboo + 5% Spandex. The fabric is made from bamboo, so it is very benign and environmentally friendly. Soft, breathable, safe for the skin. Elasticity, high strength. Heart neck design, easy to wear. Very convenient, easy to coordinate with many outfits: shorts, jeans, khakis, skirts...",
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'S',
        ],
        colors: [
          0xff323299,
          0xffff0000,
          0xffffffff,
        ]),
    Product(
        id: 9,
        name: "Women's T-shirts Embroidered Right Now Cotton USA Beautiful",
        price: 12,
        urlPhoto: List.from(
            FireImages().womensTShirtsEmbroideredRightNowCottonUSABeautiful),
        store: 'YODY',
        description:
            "Material 100% Cotton USA. The world's best Cotton yarn comes from the US with finer and more optimal dyeing ability. Absorbing sweat is very suitable for the weather in Vietnam. Light stretch, conforms to body movements. The print on the front creates a personal highlight",
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'S',
          'M',
          'L',
          'XL',
        ],
        colors: [
          0xffffffff,
          0xff00a5e5,
          0xfff9cb9c,
          0xff000000,
        ]),
    Product(
        id: 10,
        name: "Women's Loose T-shirts With Dolphin Printed Cornmeal Fashion",
        price: 15,
        urlPhoto: List.from(
            FireImages().womensLooseTShirtsWithDolphinPrintedCornmealFashion),
        store: 'YODY',
        description:
            "Cornstarch Women's T-shirt - a great innovation at YODY! The product has good elasticity and does not deform: the fabric has a spring-like structure, so it is extremely elastic without the use of spandex yarn, the surface of the fabric recovers well immediately after stretching.",
        typeByGender: 'women',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'S',
          'M',
          'L',
        ],
        colors: [
          0xffffffff,
        ]),
    Product(
        id: 11,
        name: "T-Shirt Men Clean Vietnam Back Body Print",
        price: 15,
        urlPhoto: List.from(
            FireImages().womensLooseTShirtsWithDolphinPrintedCornmealFashion),
        store: 'YODY',
        description:
            "Men's t-shirt made of environmentally friendly recycled cotton. Composition: 60% Cotton + 20% Polyester + 20% Recycle Polyester. Fabric is soft, airy, good absorption. T-shirt is slightly elastic, limiting wrinkles when wash. Featuring a signature chest print for the recycled material collection. Comfortable loose fit, youthful style.",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'M',
          'L',
          'XL',
        ],
        colors: [
          0xffffffff,
        ]),
    Product(
        id: 12,
        name: "Cotton Usa Embossed Men's T-shirt",
        price: 15,
        urlPhoto: List.from(FireImages().bambooHeartNeckTShirtForWomen),
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/05/2023',
        sizes: [
          'M',
          'L',
          'XL',
        ],
        colors: [
          0xff000000,
          0xff40d7e0,
          0xff98b57d,
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
