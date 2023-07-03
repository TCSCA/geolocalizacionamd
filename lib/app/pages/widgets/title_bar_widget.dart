import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';

class TitleBar extends StatelessWidget {
  final String title;
  const TitleBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
            onPressed: () {
              BlocProvider.of<MainBloc>(context)
                  .add(const ShowHomeServiceAssignedEvent());
            },
            icon: const Icon(
              Icons.update,
              size: 25,
              color: Colors.black,
            ),
            label: const Text(
              'Actualizar',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ))
        /* IconButton(
            onPressed: () {
              BlocProvider.of<MainBloc>(context)
                  .add(const ShowHomeServiceAssignedEvent());
            },
            icon: const Icon(
              Icons.update,
              size: 33,
            )) */
      ],
    );
  }
}
