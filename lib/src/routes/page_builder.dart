import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SlideTransitionPage extends CustomTransitionPage {
  SlideTransitionPage({
    required super.child,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

// class NoTransitionPage extends CustomTransitionPage {
//   NoTransitionPage({
//     required super.child,
//   }) : super(
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return child;
//           },
//           transitionDuration: const Duration(milliseconds: 300),
//         );
// }
