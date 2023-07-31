import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/controllers/profile_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/shared/bloc_shared/bloc_gender/gender_bloc.dart';

class AllGenderWidget extends StatelessWidget {
  const AllGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => GenderBloc(profileController: ProfileController())..add(ConsultAllGenderEvent()),
      child: allGenderList(),);
  }

  Widget allGenderList() {
    return BlocBuilder<GenderBloc, GenderState>(
      builder: (context, state) {
        if(state is GenderDataSuccessState) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocalization.labelGender,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.always,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  // style: fontTextBlack,
                  // key: _genderKey,
                  validator: (value) {
                    // return genderValidator(value.toString());
                  },
                  items: state.genderMap.data.map((item) {
                    return DropdownMenuItem(
                      child: Text(item.descriptionEs),
                      value: item.idGender,
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    /*_genderKey.currentState!.validate();
                    _mySelectionGender = newVal.toString();*/

                  },
                  onTap: () {
                   /* _genderValid = _genderKey.currentState!.validate();
                    _saveButtonEnable = _isFormValid();*/
                  },
                  value: null,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
