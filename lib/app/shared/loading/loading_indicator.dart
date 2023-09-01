import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String menssage;
  const LoadingIndicator({super.key, required this.menssage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const GetLoadingIndicator(),
      //  GetText(displayedText: menssage),
      ],
    );
  }
}

class GetLoadingIndicator extends StatelessWidget {
  const GetLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 32.0),
      child: SizedBox(
        width: 32.0,
        height: 32.0,
        child: CircularProgressIndicator(
          color: Color(0xff2B5178),
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}

class GetText extends StatelessWidget {
  final String displayedText;
  const GetText({super.key, required this.displayedText});

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
      textAlign: TextAlign.center,
    );
  }
}
