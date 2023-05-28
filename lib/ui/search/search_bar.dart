import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../component/image_firebase_storage.dart';
import '../../models/product/product.dart';
import '../../shared/const/screen_consts.dart';

class MySearchBarDelegate extends SearchDelegate {
  final List<String> historySearch = MySharedPreferences.getHistorySearch();
  Function(String)? updateQuery;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          titleLarge: theme.textTheme.titleLarge!.copyWith(
            // Kiểu cho query
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 14),
        ),
        textSelectionTheme: theme.textSelectionTheme.copyWith(
          cursorColor: Colors.grey,
        ));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
          )),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); // close search bar
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.grey,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      if (historySearch.contains(query)) {
        historySearch.remove(query);
      }
      historySearch.insert(0, query);
      MySharedPreferences.saveHistorySearch(historySearch);
      return _buildGridViewResults(query);
    }
    return const SizedBox();
  }

  Widget _buildGridViewResults(String query) {
    List<Product> listProduct = _fetchProductsWithQueryBySearch(query);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 3 / 5,
      ),
      itemCount: listProduct.length,
      itemBuilder: (context, index) {
        final product = listProduct[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(context, RouteName.productInfoScreen,
              arguments: product),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Product Image
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ImagesFireBaseStore(
                      urlImage: product.urlPhoto.first,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                //Product Info
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandableText(
                          product.name,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          expandText: '',
                          linkColor: Colors.black,
                          maxLines: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              constraints: const BoxConstraints(maxWidth: 50),
                              child: Text(
                                '${product.price} \$',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Text(
                              product.sizes.join('  '),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: product.colors.length,
                            itemBuilder: (context, index) {
                              var color = product.colors[index];
                              return Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(color),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 5,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (historySearch.isNotEmpty)
          ListViewHistory(
            historySearch: historySearch,
            updateQuery: (value) {
              query = value;
              showSuggestions(context);
            },
          ),
        _buildSearchSuggestions(query.trim()),
      ],
    );
  }

  Widget _buildSearchSuggestions(String query) {
    List<Product> listProduct = _fetchProductsWithQueryBySearch(query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey.shade300,
          height: 4,
        ),
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: const Text(
            'Search Suggestions',
            style: TextStyle(fontSize: 17),
          ),
        ),
        Container(
          color: Colors.grey.shade300,
          height: 1,
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey.shade300,
                  height: 1,
                ),
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              final product = listProduct.elementAt(index);
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.productInfoScreen,
                      arguments: product);
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Product Image
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: double.infinity,
                          height: double.infinity,
                          child: ImagesFireBaseStore(
                            urlImage: product.urlPhoto.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      //Product Info
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    product.sizes.join('  '),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 180,
                                  ),
                                  height: 20,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: product.colors.length,
                                    itemBuilder: (context, index) {
                                      var color = product.colors[index];
                                      bool isBorder = (color == 0xffffffff);
                                      return Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Color(color),
                                          shape: BoxShape.circle,
                                          border: isBorder
                                              ? Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 1.0)
                                              : null,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${product.price} \$',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  List<Product> _fetchProductsWithQueryBySearch(String query) {
    List<Product> listProduct = List.from(FakeProduct.listProduct);
    if (query.trim().isNotEmpty) {
      List<Product> listResult = listProduct
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      listResult.sort(
        (a, b) => b.favoriteCount.compareTo(a.favoriteCount),
      );
      return listResult;
    } else {
      listProduct.sort(
        (a, b) => b.favoriteCount.compareTo(a.favoriteCount),
      );
      return listProduct;
    }
  }
}

class ListViewHistory extends StatefulWidget {
  const ListViewHistory({
    super.key,
    required this.historySearch,
    required this.updateQuery, // Thêm thuộc tính updateQuery
  });

  final List<String> historySearch;
  final Function(String)? updateQuery;

  @override
  State<ListViewHistory> createState() => _ListViewHistoryState();
}

class _ListViewHistoryState extends State<ListViewHistory> {
  List<String> historySearch = [];
  final delegate = MySearchBarDelegate();
  int maxLengthOfHistory = 6;

  @override
  void initState() {
    super.initState();
    historySearch = widget.historySearch;
  }

  @override
  Widget build(BuildContext context) {
    return historySearch.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: historySearch.length > maxLengthOfHistory
                    ? maxLengthOfHistory
                    : historySearch.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade400,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final selectedQuery = historySearch[index];
                      widget.updateQuery?.call(selectedQuery);
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) =>
                          _buildDialog(context, historySearch, index),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        historySearch[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              //button Show more/ Show less
              if (historySearch.length > maxLengthOfHistory)
                _buildButtonControlShowHistory(
                    'Show more', historySearch.length)
              else if (historySearch.length == maxLengthOfHistory)
                _buildButtonControlShowHistory('Show less', 5)
              else
                const SizedBox(),
            ],
          );
  }

  Dialog _buildDialog(
      BuildContext context, List<String> historySearch, int index) {
    return Dialog(
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                historySearch.removeAt(index);
                await MySharedPreferences.saveHistorySearch(historySearch).then(
                  (value) {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                );
              },
              child: Container(
                height: 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: const [
                    Text(
                      'Delete',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonControlShowHistory(
    String text,
    int newLength,
  ) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 38,
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => setState(() {
              maxLengthOfHistory = newLength;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              historySearch.clear();
              await MySharedPreferences.saveHistorySearch(historySearch);
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
