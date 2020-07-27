import 'package:flutter/material.dart';

typedef DrawerNavigationTileCallback = void Function();

/// Widget used for home page navigation
class DrawerNavigationTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTapped;

  DrawerNavigationTile({this.title, this.icon, this.onTapped});

  // Build method
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      splashColor: Colors.grey[750],
      onTap: onTapped,
      child: ListTile(
        title: Row(
          children: [
            Icon(
              (icon == null) ? Icons.home : icon,
              color: Colors.grey[750],
            ),
            SizedBox(width: 15),
            Text(
              (title == null) ? "Home" : title,
              style: TextStyle(
                color: Colors.grey[750],
              ),
            ),
            Spacer(flex: 1),
            Icon(
              Icons.arrow_right,
              color: Colors.grey[750],
            )
          ],
        ),
      ),
    );
  }
}
