import 'package:flutter/material.dart';

typedef NavigationItemCallback = void Function();

/// Widget used for home page navigation
class NavigationItem extends StatelessWidget {
  // Constructor
  NavigationItem(
      {this.context, this.image, this.title, this.onTap, this.background});

  // Properties
  final BuildContext context;
  final String image;
  final String title;
  final Function onTap;
  final Color background;

  // Build method
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      elevation: 0.75,
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        splashColor: Colors.green,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15),
          // Set height and width
          height: 160,
          width: 160,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      ((background == null) ? Color(0xFFecf0f1) : background),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(7),
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    image,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF718093)),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
