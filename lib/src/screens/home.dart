import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ninja/src/screens/form_entry_patient.dart';
import 'package:ninja/src/screens/search_patient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ButtonActions {
  final String imageUrl, text;
  ButtonActions(this.imageUrl, this.text);
}

class _HomeScreenState extends State<HomeScreen> {
  static const historyLength = 5;

  final List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  List<String> filteredSearchHistory = [];

  String selectedTerm = '';

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 140,
                child: Expanded(
                  child: GridView.count(crossAxisCount: 3, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            border: Border.all(
                              color: Colors.red.shade800,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text('10',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            border: Border.all(
                              color: Colors.orange.shade800,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text('10',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[600],
                            border: Border.all(
                              color: Colors.yellow.shade800,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text('10',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              Container(
                child: TextField(
                    autofocus: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 14),
                      hintText: 'Cari nomor RM pasien',
                      suffixIcon: Icon(Icons.search, color: Colors.black38),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(SearchPatient.routeName);
                    }),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 200,
                  width: double.infinity,
                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black45,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(FormEntryPatient.routeName);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/patient.png"),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: Text('Entry Data Pasien'),
                              )
                            ],
                          ),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black45,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () => {},
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/patient.png"),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: Text('Monitoring'),
                              )
                            ],
                          ),
                        )
                      ]))
            ]),
          ),
        ),
      ),
    );
  }
}
