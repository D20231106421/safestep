import 'package:flutter/material.dart';

/// A [PageRouteBuilder] that slides the new screen in from the right
/// and back out to the right on pop, identical to the [AnimatedSwitcher]
/// transition used in [AppShell].
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({required WidgetBuilder builder, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // New screen slides in from the right; slides back out to the right on pop.
            final slideIn = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            );

            // Outgoing screen slides slightly to the left while new screen enters.
            final slideOut = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.25, 0.0),
            ).animate(
              CurvedAnimation(
                  parent: secondaryAnimation, curve: Curves.easeInOut),
            );

            return SlideTransition(
              position: slideOut,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            );
          },
        );
}
