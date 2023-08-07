import '../../models/worker.dart';
import 'home/WorkerViewFromUser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  final String? service;

  const SearchPage({Key? key, this.service}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Worker>? workers;
  List<Worker>? searchResults;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('workers')
        .where('service', isEqualTo: widget.service)
        .get()
        .then((snapshot) {
      setState(() {
        workers = snapshot.docs.map((doc) => Worker.fromSnapshot(doc)).toList();
        searchResults = workers; // Initialize search results with all workers
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildSearchContainer,
      const SizedBox(height: 20.0),
      searchResults == null ? const SizedBox() : _buildListView
    ]);
  }

  Widget get _buildSearchContainer => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(children: [
        _buildTextField,
        const SizedBox(width: 10),
        _buildCloseButton
      ]));

  Widget get _buildTextField => Expanded(
      child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for Services by city / worker name',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 40),
          ),
          onChanged: updateSearchQuery));

  Widget get _buildCloseButton => IconButton(
      onPressed: _clearSearch,
      icon: const Icon(Icons.clear, color: Colors.grey));

  Widget get _buildListView => Expanded(
          child: ListView.separated(
        itemBuilder: (context, index) {
          final worker = searchResults?[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WorkerFromUser(worker: worker);
                }));
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        leading: worker?.photoUrl != null &&
                                worker?.photoUrl != " " &&
                                worker?.photoUrl != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  worker!.photoUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              )
                            : Image.network(
                                'https://www.w3schools.com/w3images/avatar2.png',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${worker?.firstName ?? ''} ${worker?.lastName ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ]),
                        subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(worker?.service ?? ''),
                              Text(worker?.city ?? '')
                            ])),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Available on: ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 10, 118, 126),
                                  
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 15),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: worker!.availability.values
                                    .map((e) => Column(
                                          children: [
                                            Text(e),
                                            const SizedBox(height: 5)
                                          ],
                                        ))
                                    .toList())
                          ],
                        ))
                  ]));
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: searchResults?.length ?? 0,
      ));

  //Functions
  void updateSearchQuery(query) {
    setState(() {
      query = _searchController.text;
      searchResults =
          searchWorkers(query); // Update search results based on query
    });
  }

  List<Worker> searchWorkers(String query) {
    if (workers == null) return [];

    if (query.isEmpty) {
      return workers!; // Return all workers if the query is empty
    }

    return workers!
        .where((worker) =>
            worker.firstName.toLowerCase().contains(query.toLowerCase()) ||
            worker.city.toLowerCase().contains(query.toLowerCase()) ||
            worker.service.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchResults = workers; // Reset search results to show all workers
    });
  }
}
