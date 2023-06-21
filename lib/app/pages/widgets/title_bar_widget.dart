import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/bloc/login_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/bloc/main_bloc.dart';

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
        IconButton(
            onPressed: () {
              BlocProvider.of<MainBloc>(context)
                  .add(const ShowHomeServiceAssignedEvent());
            },
            icon: const Icon(
              Icons.update,
              size: 33,
            ))
      ],
    );
  }
}
