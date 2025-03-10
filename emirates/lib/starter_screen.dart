import 'package:emirates/screens/skywards_screen.dart';
import 'package:emirates/widgets/drawer_list.dart';
import 'package:emirates/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://static.vecteezy.com/system/resources/previews/014/414/710/non_2x/fly-emirates-logo-on-transparent-background-free-vector.jpg',
          height: 70,
          width: double.infinity,
        ),
        actions: [InkWell(onTap: () {}, child: Icon(Icons.lock_clock))],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: AlwaysScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: CupertinoTabBar(
          onTap: navigationTapped,
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? Colors.yellow : Colors.blue,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.airplane_ticket,
                color: _page == 1 ? Colors.yellow : Colors.blue,
              ),
              label: 'Book',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
                color: _page == 2 ? Colors.yellow : Colors.blue,
              ),
              label: 'My Trips',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SkywardsScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.person,
                  color: _page == 3 ? Colors.yellow : Colors.blue,
                ),
              ),
              label: 'Skywards',
            ),
          ],
        ),
      ),

      drawer: DrawerList(),
    );
  }
}
