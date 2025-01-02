import 'package:flutter/cupertino.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final List<Route> routeStack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    routeStack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    routeStack.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final index = routeStack.indexOf(oldRoute!);
    if (index != -1) {
      routeStack[index] = newRoute!;
    } else {
      routeStack.add(newRoute!);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  static bool containsRoute(String routeName) {
    return routeStack.any((route) => route.settings.name == routeName);
  }
}