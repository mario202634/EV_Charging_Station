import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    //return Text('Home Screen', ) ;
    return Scaffold(
      appBar: AppBar(
      leading: Icon(
        Icons.menu, ),
      title: Text(
          'EV Charging Station'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: SearchFunction,
            icon: Icon(
          Icons.search, )),
        IconButton(onPressed: RingFunction, icon: Icon(Icons.access_alarm))
      ],
      elevation: 0.0,
    ),
      body: Container(
        color: Colors.purpleAccent,
        width: double.infinity,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.pinkAccent,
              child: Text(
                  'One',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              color: Colors.blueAccent,
              child: Text(
                'Two',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0
                ),
              ),
            ),
            Container(
              color: Colors.greenAccent,
              child: Text(
                'Three',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              color: Colors.amberAccent,
              child: Text(
                'Four',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void SearchFunction()
  {
    print('Search performed');
  }

  void RingFunction()
  {
    print('Ring performed');
  }

}