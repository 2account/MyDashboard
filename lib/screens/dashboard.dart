import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:dashboard/widgets/misc/DrawerNavigationTile.dart';
import 'package:dashboard/widgets/misc/navigationitem.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // AppBar
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      //
      // Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                    color: Theme.of(context).backgroundColor,
                  )),
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Text(widget.title),
                  ),
                ),
              ),
            ),
            DrawerNavigationTile(
              title: "Del ${widget.title}",
              icon: Icons.share,
              onTapped: () {
                // Vibrate the phone
                HapticFeedback.vibrate();
                // Close the drawer
                Navigator.of(context).pop();
                // Create RenderBox object
                final RenderBox box = context.findRenderObject();
                // Open share dialog
                Share.share(
                  "Hent ${widget.title} fra Googles Play Store!",
                  subject: "${widget.title} - En fed app!",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size,
                );
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height - 250,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  DrawerNavigationTile(
                    title: "Indstillinger",
                    icon: Icons.settings,
                    onTapped: () => {
                      // Vibrate the phone
                      HapticFeedback.vibrate()
                    },
                  ),
                  DrawerNavigationTile(
                    title: "Om ${widget.title}",
                    icon: Icons.info_outline,
                    onTapped: () {
                      // Vibrate the phone
                      HapticFeedback.vibrate();
                      // Close the drawer
                      Navigator.of(context).pop();
                      // Show the about dialog
                      showAboutDialog(
                        context: context,
                        applicationName: "${widget.title}",
                        applicationVersion: "1.0.0",
                        applicationLegalese:
                            "${widget.title} er en brugbar app designet til at holde styr på alle dine madplaner, opskrifter, og meget mere.",
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //
      // Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavigationItem(
                  background: Color(0xFFff9ff3).withOpacity(0.7),
                  context: context,
                  image: "assets/images/calendar.png",
                  title: "Madplan",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    debugPrint("Food plan was pressed")
                  },
                ),
                NavigationItem(
                  background: Color(0xFF54a0ff).withOpacity(0.5),
                  context: context,
                  image: "assets/images/scroll.png",
                  title: "Indkøbsliste",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    debugPrint("Shopping list was pressed")
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavigationItem(
                  background: Color(0xFFff9f43).withOpacity(0.5),
                  context: context,
                  image: "assets/images/milk.png",
                  title: "Dagligvarer",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    debugPrint("Groceries was pressed")
                  },
                ),
                NavigationItem(
                  background: Color(0xFF2ed573).withOpacity(0.45),
                  context: context,
                  image: "assets/images/list.png",
                  title: "Todo",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    Navigator.pushNamed(context, "todo")
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavigationItem(
                  background: Color(0xFFee5253).withOpacity(0.6),
                  context: context,
                  image: "assets/images/creditcard.png",
                  title: "Udgifter",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                  },
                ),
                NavigationItem(
                  background: Color(0xFF341f97).withOpacity(0.5),
                  context: context,
                  image: "assets/images/draw.png",
                  title: "Noter",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    Navigator.of(context).pushNamed("notes")
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NavigationItem(
                  background: Color(0xFF1dd1a1).withOpacity(0.4),
                  context: context,
                  image: "assets/images/steak.png",
                  title: "Spisesteder",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    debugPrint("Restaurants was pressed")
                  },
                ),
                NavigationItem(
                  background: Color(0xFF2e86de).withOpacity(0.55),
                  context: context,
                  image: "assets/images/book.png",
                  title: "Opskrifter",
                  onTap: () => {
                    HapticFeedback.vibrate(),
                    debugPrint("Recipes was pressed")
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
