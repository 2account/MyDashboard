import 'package:flutter/material.dart';

/// Used for NotesDetail page navigation in a NotesPage
/// Makes the background when you pull down transparent.
class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
    bool fullscreenDialog = false,
  }) : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

 final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}