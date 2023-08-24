import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/pages/routes/geoamd_route.dart';
import 'common_widgets.dart';

class AmdPendingCardEmpty extends StatelessWidget {
  final String title;
  final String message;
  const AmdPendingCardEmpty(
      {super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(10.0, 10.0),
            blurRadius: 20.0,
            color: const Color(0xff2B5178).withOpacity(0.7))
      ]),
      child: Card(
        margin: const EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Color(0xff2B5178), width: 1.0)),
        color: const Color(0xFFfbfcff).withOpacity(0.5),
        //shadowColor: const Color(0xff2B5178).withOpacity(0.7),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Image.asset('assets/images/gps_doctor_image.png'),
                  title: Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.black)),
                  subtitle: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Flexible(
                              child: Text(
                            message,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.black),
                          )),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<MainBloc>(context).add(
                                    const ValidateConfirmedAmdProcessedAdminEvent());
                              },
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  elevation: 5,
                                  side: const BorderSide(
                                      width: 2, color: Color(0xffFFFFFF)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xffF96352),
                                      Color(0xffD84835)
                                    ]),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    'Ver Atención',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
