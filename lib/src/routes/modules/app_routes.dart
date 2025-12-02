import 'package:go_router/go_router.dart';

import '../../pages/web_view.dart';

class AppRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/webView/:title/:url',
        name: 'webView',
        builder: (_, GoRouterState state) {
          final String title = state.pathParameters['title']!;
          final String url = state.pathParameters['url']!;
          return WebView(
            title: title,
            url: url,
          );
        },
      ),
    ];
  }
}
