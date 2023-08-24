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
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
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
            label: Text(
              'Actualizar',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.black),
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
