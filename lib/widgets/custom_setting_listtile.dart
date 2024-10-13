
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomSettingListTile extends StatefulWidget {
  final IconData prefixIcon;
  final String labelText;
  final Widget trailingWidget;
  final VoidCallback onTap;

  const CustomSettingListTile({
    Key? key,
    required this.prefixIcon,
    required this.labelText,
    required this.trailingWidget,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomSettingListTile> createState() => _CustomSettingListTileState();
}

class _CustomSettingListTileState extends State<CustomSettingListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    widget.prefixIcon,
                    size: 24,
                    color: Get.isDarkMode
                        ? Colors.white60
                        : const Color.fromARGB(133, 0, 0, 0),
                  ),
                ),
                Text(
                  widget.labelText,
                  style: const TextStyle(
                    // fontFamily: ,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            widget.trailingWidget,
          ],
        ),
      ),
    );
  }
}
