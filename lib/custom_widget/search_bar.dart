import 'package:fashion_app/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MySearchBarDelegate extends SearchDelegate {

  final List<String> historySearch  = MySharedPreferences.getHistorySearch();

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
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); // close search bar
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    historySearch.add(query);
    MySharedPreferences.setSaveHistorySearch(historySearch);
    return Text(
        query,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(historySearch.isNotEmpty){
      return ListView.separated(
        shrinkWrap: true,
        itemCount: historySearch.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey,),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(historySearch[index], style: const TextStyle(fontSize: 18),)),
      );
    }else{
      return Container();
    }
  }
}
