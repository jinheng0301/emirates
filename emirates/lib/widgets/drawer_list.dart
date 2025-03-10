import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Guest',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.map),
              title: Text('Airport Maps'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.timer),
              title: Text('Flight Status'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.luggage),
              title: Text('Baggage tracker'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Travel updates'),
            ),
          ),

          Divider(),

          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('FAQ'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('Contact us'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.comment),
              title: Text('Send Feedback'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(leading: Icon(Icons.list), title: Text('Legal')),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.rule),
              title: Text('Rules and Notices'),
            ),
          ),

          Divider(),

          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('About Emirates'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Country and Language'),
            ),
          ),

          Divider(),

          GestureDetector(
            onTap: () {
              print('EMIRATES SKYWARDS tapped');
            },
            child: Container(
              color: Colors.green[200],
              width: width * 0.8,
              height: height * 0.3,
              padding: EdgeInsets.all(13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'EMIRATES SKYWARDS',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    'Join now and start enjoying the benefits',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          Spacer(),

          ListTile(
            title: Text(
              'APP VERSION 12.7.1',
              style: TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
