import 'package:flutter/material.dart';

import '../themes/colors.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    this.margin,
  });

  final String title;
  final String description;
  final Color color;
  final EdgeInsets? margin;


  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16),
      margin: margin ?? const  EdgeInsets.all(12),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: color.withOpacity(0.1)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Icon(
            Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyle(
                    weight: FontWeight.bold,
                    size: 16,
                    color:color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textStyle(
                    color: color,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
