import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SharedParts/TitleText.dart';
import 'package:link/services/userInfo.dart';

class PickInterests extends StatefulWidget {
  const PickInterests({Key? key}) : super(key: key);

  @override
  _PickInterestsState createState() => _PickInterestsState();
}

class _PickInterestsState extends State<PickInterests> {

  List<String> interestList = ["Coffee", "Photography", "Martial Arts", "Crypto", "Fashion", "Baking", "Climbing", "Fishing", "Biking", "Skiing", "Snowboarding", "Tattoos", "Crossfit", "Activism", "Walking", "Hiking", "Sports", "Reading", "Clubbing", "Cars", "Shopping", "Collecting", "Boxing", "Rugby", "Basketball", "Poetry", "Meditation", "Yoga", "Gym", "Hockey", "Running", "Travel", "Sneakers", "Comedy", "Ice Skating", "E-Sports", "Cosplay", "Painting", "Surfing", "Bowling", "Cooking", "Fencing", "Soccer", "Entrepreneurship", "Astrology", "Dancing", "Gardening", "Art", "Politics", "Gaming", "Board Games", "Volunteering", "D&D", "Wine", "Makeup", "Writing", "Vegan", "Ballet", "Baseball", "Motorcycles", "Archery", "Camping", "Music", "Swimming", "Stocks"];
  List<String> selectedList = [];
  List<String> searchList = [];
  TextEditingController searchController = TextEditingController(text: '');

  @override
  initState() {
    super.initState();
    searchList = interestList.toList();
    getInfo();
  }

  getInfo() async {
    selectedList = await UserData.getInterests();
    setState(() {
      selectedList = selectedList;
    });
  }

  search() {
    if (searchController.text == ''){
      searchList = interestList.toList();
      return;
    }
    searchList.clear();
    String searchTerm = searchController.text.toLowerCase();
    for(String element in interestList){
      if(element.toLowerCase().startsWith(searchTerm)){
        searchList.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: TextButton(onPressed: () {},
          child: Text(selectedList.length.toString() + "/10"),
        ),
        title: subTitleText(
          'Choose Interests',
        ),
        actions: [
          InkWell(
            onTap: () async {
              CollectionReference users = FirebaseFirestore.instance.collection('users');

              final prefs = await SharedPreferences.getInstance();
              await prefs.setStringList('interests', selectedList);

              users.doc(user.uid).update({'interests': selectedList})
                  .then((value) => print("User Updated"))
                  .catchError((error) => print("Failed to update user: $error"));

              Fluttertoast.showToast(
                msg: 'Interests Updated',
                backgroundColor: Colors.grey,
              );

              Navigator.pop(context);
            },
            child: Icon(
              Icons.check,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child:
          TextFormField(
            controller: searchController,
            obscureText: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: search(),
          ),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
          ),
          child: searchList.isEmpty ? Center(child: Text("No Results"))
          : ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (BuildContext context, int index) {
                String element = searchList.elementAt(index);
                return ListTile(
                  title: Text(searchList.elementAt(index)),
                  selected: selectedList.contains(element),
                  onTap: () {
                    setState(() {
                      if (selectedList.contains(element)) {
                        selectedList.remove(element);
                      }
                      else if (selectedList.length < 10) {
                        selectedList.add(element);
                      }
                    });

                  },
                  trailing: selectedList.contains(element)
                      ? Icon(Icons.check)
                      : null,
                );
              })
      ),
    );
  }
}
