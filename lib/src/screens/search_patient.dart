import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ninja/src/models/patient_visit.dart';
import 'package:ninja/src/screens/patient_detail.dart';

class SearchPatient extends StatefulWidget {
  const SearchPatient({Key? key}) : super(key: key);
  static const routeName = '/search-patient';
  @override
  _SearchPatientState createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  static const historyLength = 5;

  final List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  late List<String> filteredSearchHistory = [];

  late String selectedTerm = '';

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
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            key: UniqueKey(),
            searchTerm: selectedTerm,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({
    required Key key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PatienVisit>>(
        stream: readPatientVisit(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Patient not found');
          }
          if (snapshot.hasData) {
            final patients = snapshot.data!;
            return ListView(
              children: patients.map(buildPatient).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });

    // ListView.builder(
    //   // Providing a restorationId allows the ListView to restore the
    //   // scroll position when a user leaves and returns to the app after it
    //   // has been killed while running in the background.
    //   restorationId: 'sampleItemListView',
    //   itemCount: 3,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //         title: Text('SampleItem'),
    //         leading: const CircleAvatar(
    //           // Display the Flutter Logo image asset.
    //           foregroundImage: AssetImage('assets/images/flutter_logo.png'),
    //         ),
    //         onTap: () {
    //           // Navigate to the details page. If the user leaves and returns to
    //           // the app after it has been killed while running in the
    //           // background, the navigation stack is restored.
    //           Navigator.restorablePushNamed(
    //             context,
    //             PatientDetail.routeName,
    //           );
    //         });
    //   },
    // );
  }

  Widget buildPatient(PatienVisit patientVisit) => ListTile(
      title: Text(patientVisit.noRm), subtitle: Text(patientVisit.nama));

  Stream<List<PatienVisit>> readPatientVisit() => FirebaseFirestore.instance
      .collection('test-kunjungan')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PatienVisit.fromJson(doc.data()))
          .toList());
}
