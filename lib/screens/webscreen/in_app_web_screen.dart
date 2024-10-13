// import 'dart:convert';
//
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// enum WebSourceType{html,url}
//
// class InAppWebScreen extends StatefulWidget {
//   final String source;
//   final String title;
//   final WebSourceType webSourceType;
//   const InAppWebScreen({super.key,required this.title,required this.source,this.webSourceType = WebSourceType.url,});
//
//   @override
//   State<InAppWebScreen> createState() => _InAppWebScreenState();
// }
//
// class _InAppWebScreenState extends State<InAppWebScreen> {
//
//   bool isLoading = true;
//
//   late final WebViewController _controller;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     String data = widget.source;
//
//     if (widget.webSourceType == WebSourceType.html){
//       data  = base64Encode(
//         const Utf8Encoder().convert(widget.source),
//       );
//
//       data = "data:text/html;base64,$data";
//     }
//
//
//
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//
//           },
//           onPageStarted: (String url) {
//
//           },
//           onPageFinished: (String url) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               setState(() {
//                 isLoading = false;
//               });
//             });
//           },
//           onWebResourceError: (WebResourceError error) {
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(data));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios,
//           ),
//         ),
//         title: Text(widget.title),
//         elevation: 0,
//       ),
//       body: FadeInUp(
//         child: Center(
//           child: Visibility(
//             visible: isLoading == false,
//             replacement: const CircularProgressIndicator(),
//             child: FadeIn(
//               child: WebViewWidget(controller: _controller),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
