import 'package:flutter/material.dart';
import 'package:metersystem/utlis/Colors.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final IconData? icon;
  final String? label;
  final TextStyle? labelStyle;
  final double? spacing; // Vertical spacing between icon and label

  const CustomIconButton({
    Key? key,
    this.onTap,
    this.padding,
    this.margin,
    this.decoration,
    this.icon,
    this.label,
    this.labelStyle,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:margin ?? const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(10),

          decoration: decoration ??
              BoxDecoration(
                border: Border.all(width: 1, color: CColors.primery),
                borderRadius: BorderRadius.circular(15),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon!),
              if (icon != null && spacing != null) SizedBox(height: spacing),
              if (label != null)
                Text(
                  label!,
                  style: labelStyle ?? const TextStyle(fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
