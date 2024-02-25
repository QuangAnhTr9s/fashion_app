import '../../models/product/product.dart';

class FakeProduct {
  // static List<Product> listProduct = [];
  static List<Product> listProduct = [
    Product(
        id: 1,
        name: 'Cotton Canvas And GG Supreme Jacket',
        price: 4100,
        // urlPhoto: List.from(FireImages().cottonCanvasAndGGSupremeJacket),
        urlPhoto: [
          '/products/images/cotton_canvas_and_gg_supreme_jacket/cotton_canvas_and_gg_supreme_jacket.png',
          '/products/images/cotton_canvas_and_gg_supreme_jacket/Gucci Cotton canvas and GG Supreme jacket.jpg',
        ],
        store: 'GUCCI',
        description:
            'The jacket, a signature Gucci item, continues to be a staple throughout the Spring Summer 2023 creating a new idea of daywear that reflects the House’s aesthetic. Part of the selection, the style is crafted from dark grey cotton canvas and defined by beige and ebony GG Supreme canvas inserts.',
        typeByGender: 'man',
        category: 'jacket',
        date: '05/09/2023',
        sizes: ['S', 'M', 'L'],
        colors: [0xff36454f]),
    Product(
        id: 2,
        name: 'Linen Canvas Jacket',
        price: 4200,
        // urlPhoto: List.from(FireImages().gucciLinenCanvasJacket),
        urlPhoto: [
          '/products/images/gucci_linen_canvas_jacket/gucci_linen_canvas_jacket.png',
        ],
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
        // urlPhoto: List.from(FireImages().gearedShortsImages),
        urlPhoto: [
          '/products/images/geared_shorts/biege_geared_shorts.jpg',
          '/products/images/geared_shorts/black_geared_shorts.jpg',
          '/products/images/geared_shorts/blue_geared_shorts.jpg',
          '/products/images/geared_shorts/olive_geared_shorts.jpg',
          '/products/images/geared_shorts/yellow_geared_shorts.jpg',
          '/products/images/geared_shorts/biege_geared_shorts.jpg',
        ],
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
        // urlPhoto: List.from(FireImages().womenDryExCrewNeckShortSleeveTImages),
        urlPhoto: [
          '/products/images/women_dry_ex_crew_neck_short_sleeve_t/black_women_dry_ex_crew_neck_short_sleeve_t.jpg',
          '/products/images/women_dry_ex_crew_neck_short_sleeve_t/green_women_dry_ex_crew_neck_short_sleeve_t.jpg',
          '/products/images/women_dry_ex_crew_neck_short_sleeve_t/pink_women_dry_ex_crew_neck_short_sleeve_t.jpg',
          '/products/images/women_dry_ex_crew_neck_short_sleeve_t/white_women_dry_ex_crew_neck_short_sleeve_t.jpg',
          '/products/images/women_dry_ex_crew_neck_short_sleeve_t/pink_women_dry_ex_crew_neck_short_sleeve_t.jpg',
        ],
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
        // urlPhoto: List.from(FireImages().sweatLongSleeveFullZipHoodieImages),
        urlPhoto: [
          '/products/images/sweat_long_sleeve_full_zip_hoodie/black_sweat_long_sleeve_full_zip_hoodie.jpg',
          '/products/images/sweat_long_sleeve_full_zip_hoodie/blue_sweat_long_sleeve_full_zip_hoodie.jpg',
          '/products/images/sweat_long_sleeve_full_zip_hoodie/gray_sweat_long_sleeve_full_zip_hoodie.jpg',
          '/products/images/sweat_long_sleeve_full_zip_hoodie/olive_sweat_long_sleeve_full_zip_hoodie.jpg',
          '/products/images/sweat_long_sleeve_full_zip_hoodie/white_sweat_long_sleeve_full_zip_hoodie.jpg',
          '/products/images/sweat_long_sleeve_full_zip_hoodie/white_sweat_long_sleeve_full_zip_hoodie.jpg',
        ],
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
        urlPhoto: [
          '/products/images/just_psych_womens_loose_t_shirts_with_corn_powder/black_just_psych_womens_loose_t_shirts_with_corn_powder.png',
          '/products/images/just_psych_womens_loose_t_shirts_with_corn_powder/purple_just_psych_womens_loose_t_shirts_with_corn_powder.png',
          '/products/images/just_psych_womens_loose_t_shirts_with_corn_powder/turquoise_just_psych_womens_loose_t_shirts_with_corn_powder.png',
          '/products/images/just_psych_womens_loose_t_shirts_with_corn_powder/white_just_psych_womens_loose_t_shirts_with_corn_powder.png',
          '/products/images/just_psych_womens_loose_t_shirts_with_corn_powder/showcase_white_just_psych_womens_loose_t_shirts_with_corn_powder.png'
        ],
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
        // urlPhoto: List.from(FireImages().womensZipTShirtWithNeckline),
        urlPhoto: [
          '/products/images/womens_zip_t_shirt_with_neckline/black_womens_zip_t_shirt_with_neckline.png',
          '/products/images/womens_zip_t_shirt_with_neckline/brown_womens_zip_t_shirt_with_neckline.png',
          '/products/images/womens_zip_t_shirt_with_neckline/green_womens_zip_t_shirt_with_neckline.png',
          '/products/images/womens_zip_t_shirt_with_neckline/red_womens_zip_t_shirt_with_neckline.png',
          '/products/images/womens_zip_t_shirt_with_neckline/white_womens_zip_t_shirt_with_neckline.png',
          '/products/images/womens_zip_t_shirt_with_neckline/showcase_red_womens_zip_t_shirt_with_neckline.png',
        ],
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
        // urlPhoto: List.from(FireImages().bambooHeartNeckTShirtForWomen),
        urlPhoto: [
          '/products/images/bamboo_heart_neck_t_shirt_for_women/navy_bamboo_heart_neck_t_shirt_for_women.png',
          '/products/images/bamboo_heart_neck_t_shirt_for_women/red_bamboo_heart_neck_t_shirt_for_women.png',
          '/products/images/bamboo_heart_neck_t_shirt_for_women/white_bamboo_heart_neck_t_shirt_for_women.png',
          '/products/images/bamboo_heart_neck_t_shirt_for_women/showcase_white_bamboo_heart_neck_t_shirt_for_women.png',
        ],
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
        // urlPhoto: List.from(
        //     FireImages().womensTShirtsEmbroideredRightNowCottonUSABeautiful),
        urlPhoto: [
          '/products/images/womens_t_shirts_embroidered_right_now_cotton_usa_beautiful/white_womens_t_shirts_embroidered_right_now_cotton_usa_beautiful.png',
          '/products/images/womens_t_shirts_embroidered_right_now_cotton_usa_beautiful/blue_womens_t_shirts_embroidered_right_now_cotton_usa_beautiful.png',
          '/products/images/womens_t_shirts_embroidered_right_now_cotton_usa_beautiful/brown_womens_t_shirts_embroidered_right_now_cotton_usa_beautiful.png',
          '/products/images/womens_t_shirts_embroidered_right_now_cotton_usa_beautiful/black_womens_t_shirts_embroidered_right_now_cotton_usa_beautiful.png',
          '/products/images/womens_t_shirts_embroidered_right_now_cotton_usa_beautiful/showcase_brown_womens_t_shirts_embroidered_right_now_cotton_usa_beautiful.png',
        ],
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
        // urlPhoto: List.from(
        //     FireImages().womensLooseTShirtsWithDolphinPrintedCornmealFashion),
        urlPhoto: [
          '/products/images/womens_loose_t_shirts_with_dolphin_printed_cornmeal_fashion/white_womens_loose_t_shirts_with_dolphin_printed_cornmeal_fashion.png',
          '/products/images/womens_loose_t_shirts_with_dolphin_printed_cornmeal_fashion/showcase_white_womens_loose_t_shirts_with_dolphin_printed_cornmeal_fashion.png',
        ],
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
        // urlPhoto: List.from(
        //     FireImages().womensLooseTShirtsWithDolphinPrintedCornmealFashion),
        urlPhoto: [
          '/products/images/t_shirt_men_clean_vietnam_back_body_print/white_t_shirt_men_clean_vietnam_back_body_print.png',
          '/products/images/t_shirt_men_clean_vietnam_back_body_print/showcase_white_t_shirt_men_clean_vietnam_back_body_print.png',
        ],
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
          '2XL',
        ],
        colors: [
          0xffffffff,
        ]),
    Product(
        id: 12,
        name: "Premium Cotton USA Men's T-shirt",
        price: 15,
        urlPhoto: [
          "/products/images/premium_cotton_usa_men's_t_shirt/black_premium_cotton_usa_men's_t_shirt.png",
          "/products/images/premium_cotton_usa_men's_t_shirt/blue_premium_cotton_usa_men's_t_shirt.png",
          "/products/images/premium_cotton_usa_men's_t_shirt/green_premium_cotton_usa_men's_t_shirt.png",
          "/products/images/premium_cotton_usa_men's_t_shirt/white_premium_cotton_usa_men's_t_shirt.png",
          "/products/images/premium_cotton_usa_men's_t_shirt/showcase_premium_cotton_usa_men's_t_shirt.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/06/2023',
        sizes: [
          'M',
          'L',
          'XL',
          '2XL',
        ],
        colors: [
          0xff000000,
          0xff2986cc,
          0xff4fa876,
          0xffffffff,
        ]),
    Product(
        id: 13,
        name: "T-Shirt Men's Wide Print Chest Letters",
        price: 15,
        urlPhoto: [
          "/products/images/t_shirt_men's_wide_print_chest_letters/black_t_shirt_men's_wide_print_chest_letters.png",
          "/products/images/t_shirt_men's_wide_print_chest_letters/white_t_shirt_men's_wide_print_chest_letters.png",
          "/products/images/t_shirt_men's_wide_print_chest_letters/showcase_t_shirt_men's_wide_print_chest_letters.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/06/2023',
        sizes: [
          'M',
          'L',
          'XL',
          '2XL',
        ],
        colors: [
          0xff000000,
          0xffffffff,
        ]),
    Product(
        id: 14,
        name: "Cotton USA Men's T-shirt with Printed Chest Pockets",
        price: 15,
        urlPhoto: [
          "/products/images/cotton_usa_men's_t_shirt_with_printed_chest_pockets/white_cotton_usa_men's_t_shirt_with_printed_chest_pockets.png",
          "/products/images/cotton_usa_men's_t_shirt_with_printed_chest_pockets/black_cotton_usa_men's_t_shirt_with_printed_chest_pockets.png",
          "/products/images/cotton_usa_men's_t_shirt_with_printed_chest_pockets/showcase_cotton_usa_men's_t_shirt_with_printed_chest_pockets.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/06/2023',
        sizes: [
          'M',
          'L',
          'XL',
          '2XL',
        ],
        colors: [
          0xffffffff,
          0xff000000,
        ]),
    Product(
        id: 15,
        name: "Cotton USA Men's T-shirt with Printed Chest Pockets",
        price: 15,
        urlPhoto: [
          "/products/images/cotton_usa_embossed_mens_t_shirt/stone_gray_cotton_usa_embossed_mens_t_shirt.png",
          "/products/images/cotton_usa_embossed_mens_t_shirt/black_cotton_usa_embossed_mens_t_shirt.png",
          "/products/images/cotton_usa_embossed_mens_t_shirt/turquoise_cotton_usa_embossed_mens_t_shirt.png",
          "/products/images/cotton_usa_embossed_mens_t_shirt/showcase_cotton_usa_embossed_mens_t_shirt.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 't-shirt',
        date: '01/06/2023',
        sizes: [
          'M',
          'L',
          'XL',
          '2XL',
        ],
        colors: [
          0xff93c47d,
          0xff000000,
          0xff77cbeb,
          0xffffffff,
        ]),
    Product(
        id: 16,
        name: "Men's Kaki Shorts with Chunky Body Shape",
        price: 21,
        urlPhoto: [
          "/products/images/men's_kaki_shorts_with_chunky_body_shape/black_mens_kaki_shorts_with_chunky_body_shape.png",
          "/products/images/men's_kaki_shorts_with_chunky_body_shape/grey_mens_kaki_shorts_with_chunky_body_shape.png",
          "/products/images/men's_kaki_shorts_with_chunky_body_shape/showcase_mens_kaki_shorts_with_chunky_body_shape.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 'shorts',
        date: '01/06/2023',
        sizes: [
          '29',
          '30',
          '31',
          '32',
        ],
        colors: [
          0xff000000,
          0xff999999,
        ]),
    Product(
        id: 17,
        name: "Men's Shorts With Back Pockets",
        price: 20,
        urlPhoto: [
          "/products/images/men's_shorts_with_back_pockets/blue_mens_shorts_with_back_pockets.png",
          "/products/images/men's_shorts_with_back_pockets/black_mens_shorts_with_back_pockets.png",
          "/products/images/men's_shorts_with_back_pockets/grey_mens_shorts_with_back_pockets.png",
          "/products/images/men's_shorts_with_back_pockets/showcase_mens_shorts_with_back_pockets.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 'shorts',
        date: '01/06/2023',
        sizes: [
          '29',
          '30',
          '31',
          '32',
        ],
        colors: [
          0xff4098da,
          0xff000000,
          0xff999999,
        ]),
    Product(
        id: 18,
        name: "Men's Boobs Bomber Jacket",
        price: 29,
        urlPhoto: [
          "/products/images/men's_boobs_bomber_jacket/red_mens_boobs_bomber_jacket.png",
          "/products/images/men's_boobs_bomber_jacket/showcase_mens_boobs_bomber_jacket.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 'jacket',
        date: '01/06/2023',
        sizes: [
          'M',
          'L',
          'XL',
          '2XL',
        ],
        colors: [
          0xfff44336,
        ]),
    Product(
        id: 19,
        name: "Men's Sports Jacket With Hood",
        price: 29,
        urlPhoto: [
          "/products/images/men's_sports_jacket_with_hood/blue_mens_sports_jacket_with_hood.png",
          "/products/images/men's_sports_jacket_with_hood/black_mens_sports_jacket_with_hood.png",
          "/products/images/men's_sports_jacket_with_hood/showcase_mens_sports_jacket_with_hood.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'man',
        category: 'jacket',
        date: '01/06/2023',
        sizes: [
          'L',
          'XL',
        ],
        colors: [
          0xff2986cc,
          0xff000000,
        ]),
    Product(
        id: 20,
        name: "Women's Khaki Short Jacket",
        price: 29,
        urlPhoto: [
          "/products/images/women's_khaki_short_jacket/green_womens_khaki_short_jacket.png",
          "/products/images/women's_khaki_short_jacket/black_womens_khaki_short_jacket.png",
          "/products/images/women's_khaki_short_jacket/showcase_womens_khaki_short_jacket.png",
        ],
        store: 'YODY',
        description:
            "High quality 100% Cotton USA material. Cotton yarn from the US is the most trusted. Wear anytime, anywhere thanks to its ability to absorb sweat well, cool, suitable for Vietnam weather. Light stretch, conforms to body movement",
        typeByGender: 'women',
        category: 'jacket',
        date: '01/06/2023',
        sizes: [
          'L',
          'XL',
        ],
        colors: [
          0xff6aa84f,
          0xff000000,
        ]),
  ];
}
