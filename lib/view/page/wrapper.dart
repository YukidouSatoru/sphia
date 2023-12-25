import 'package:flutter/material.dart';

// cards in dashboard
const cardhorizontalSpacing = 12.0;
const cardVerticalSpacing = 12.0;
const edgehorizontalSpacing = 24.0;
const edgeVerticalSpacing = 24.0;

// page padding
const dashboardPadding = EdgeInsets.all(0.0);
const defaultPadding = EdgeInsets.all(20.0);

class PageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PageWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? defaultPadding,
      child: child,
    );
  }
}
