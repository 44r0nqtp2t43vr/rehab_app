import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

class SelectPlanDialog extends StatefulWidget {
  final AppUser patient;

  const SelectPlanDialog({super.key, required this.patient});

  @override
  State<SelectPlanDialog> createState() => _SelectPlanDialogState();
}

class _SelectPlanDialogState extends State<SelectPlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weeksToAdd = TextEditingController();

  @override
  void initState() {
    _weeksToAdd.text = "8";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 10,
      color: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/actuator.svg',
                    width: MediaQuery.of(context).size.width * .06,
                    height: MediaQuery.of(context).size.height * .06,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create",
                          style: TextStyle(
                            fontFamily: 'Sailec Bold',
                            fontSize: 22,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Therapy Plan",
                          style: TextStyle(
                            fontFamily: 'Sailec Light',
                            fontSize: 16,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      var weeksNum = int.tryParse(_weeksToAdd.text);
                      if (weeksNum != null && weeksNum > 1) {
                        weeksNum--;
                        setState(() {
                          _weeksToAdd.text = weeksNum.toString();
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _weeksToAdd,
                      textAlign: TextAlign.center,
                      decoration: customInputDecoration.copyWith(
                        labelText: 'No. of Weeks',
                        hintText: 'No. of Weeks',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! < 1 || int.tryParse(value)! > 48) {
                          return 'Invalid value';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      var weeksNum = int.tryParse(_weeksToAdd.text);
                      if (weeksNum != null && weeksNum < 48) {
                        weeksNum++;
                        setState(() {
                          _weeksToAdd.text = weeksNum.toString();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                    data: darkButtonTheme,
                    child: ElevatedButton(
                      onPressed: () => _createPlan(context),
                      child: const Text('Create Plan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                    data: darkButtonTheme,
                    child: ElevatedButton(
                      onPressed: () => _onCloseButtonPressed(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPlan(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();

      final userType = BlocProvider.of<UserBloc>(context).state;

      if (userType is UserNone && userType.data is Admin) {
        BlocProvider.of<ViewedPatientBloc>(context).add(AddPatientPlanEvent(AddPlanData(user: widget.patient, planSelected: int.parse(_weeksToAdd.text) * 7)));
      } else if (userType is UserNone && userType.data is Therapist) {
        BlocProvider.of<ViewedTherapistPatientBloc>(context).add(AddTherapistPatientPlanEvent(AddPlanData(user: widget.patient, planSelected: int.parse(_weeksToAdd.text) * 7)));
      }
    }
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
