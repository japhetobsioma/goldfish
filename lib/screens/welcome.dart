import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../models/user_information.dart';

final _userInformationProvider = StateNotifierProvider<UserInformationNotifier>(
    (ref) => UserInformationNotifier());

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Input your information to customize your hydration plan'),
            const Text('Gender'),
            const GenderWidget(),
            const Text('Date of birth'),
            const DateOfBirthWidget(),
            const Text('Wake-up time'),
            const WakeUpTimeWidget(),
            const Text('Bedtime'),
            const BedtimeWidget(),
            const ApplyWidget(),
          ],
        ),
      ),
    );
  }
}

final _genderState = Provider<Gender>((ref) {
  return ref.watch(_userInformationProvider.state).gender;
});

final _genderProvider = Provider<Gender>((ref) {
  return ref.watch(_genderState);
});

class GenderWidget extends HookWidget {
  const GenderWidget();

  @override
  Widget build(BuildContext context) {
    final _genderModel = useProvider(_genderProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(
          title: const Text('Male'),
          value: Gender.male,
          groupValue: _genderModel,
          onChanged: (value) {
            context.read(_userInformationProvider).selectGender(value);
          },
        ),
        RadioListTile(
          title: const Text('Female'),
          value: Gender.female,
          groupValue: _genderModel,
          onChanged: (value) {
            context.read(_userInformationProvider).selectGender(value);
          },
        ),
      ],
    );
  }
}

final _dateOfBirthState = Provider<DateTime>((ref) {
  return ref.watch(_userInformationProvider.state).dateOfBirth;
});

final _dateOfBirthProvider = Provider<DateTime>((ref) {
  return ref.watch(_dateOfBirthState);
});

class DateOfBirthWidget extends HookWidget {
  const DateOfBirthWidget();

  @override
  Widget build(BuildContext context) {
    final _dateOfBirthModel = useProvider(_dateOfBirthProvider);

    Future<void> _showDatePicker() async {
      final _dateNow = DateTime.now();

      final _selectedDate = await showDatePicker(
        context: context,
        initialDate: _dateOfBirthModel,
        firstDate: DateTime(1905, 1),
        lastDate: DateTime(_dateNow.year, _dateNow.day),
        initialDatePickerMode: DatePickerMode.year,
      );

      if (_selectedDate != null && _selectedDate != _dateOfBirthModel) {
        context.read(_userInformationProvider).selectDateOfBirth(_selectedDate);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _showDatePicker,
          child: const Text('SHOW DATE PICKER'),
        ),
        Text(
            'Selected date of birth: ${DateFormat.yMd().format(_dateOfBirthModel)}'),
      ],
    );
  }
}

final _wakeUpTimeState = Provider<TimeOfDay>((ref) {
  return ref.watch(_userInformationProvider.state).wakeUpTime;
});

final _wakeUpTimeProvider = Provider<TimeOfDay>((ref) {
  return ref.watch(_wakeUpTimeState);
});

class WakeUpTimeWidget extends HookWidget {
  const WakeUpTimeWidget();

  @override
  Widget build(BuildContext context) {
    final _wakeUpTimeModel = useProvider(_wakeUpTimeProvider);

    Future<void> _showTimePicker() async {
      final _selectedTime = await showTimePicker(
        context: context,
        initialTime: _wakeUpTimeModel,
      );

      if (_selectedTime != null && _selectedTime != _wakeUpTimeModel) {
        context.read(_userInformationProvider).selectWakeUpTime(_selectedTime);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _showTimePicker,
          child: const Text('SHOW TIME PICKER'),
        ),
        Text('Selected wake-up time: ${_wakeUpTimeModel.format(context)}'),
      ],
    );
  }
}

final _bedtimeState = Provider<TimeOfDay>((ref) {
  return ref.watch(_userInformationProvider.state).bedtime;
});

final _bedtimeProvider = Provider<TimeOfDay>((ref) {
  return ref.watch(_bedtimeState);
});

class BedtimeWidget extends HookWidget {
  const BedtimeWidget();

  @override
  Widget build(BuildContext context) {
    final _bedtimeModel = useProvider(_bedtimeProvider);

    Future<void> _showTimePicker() async {
      final _selectedTime = await showTimePicker(
        context: context,
        initialTime: _bedtimeModel,
      );

      if (_selectedTime != null && _selectedTime != _bedtimeModel) {
        context.read(_userInformationProvider).selectBedtime(_selectedTime);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _showTimePicker,
          child: const Text('SHOW TIME PICKER'),
        ),
        Text('Selected bedtime: ${_bedtimeModel.format(context)}'),
      ],
    );
  }
}

class ApplyWidget extends HookWidget {
  const ApplyWidget();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read(_userInformationProvider).setWaterIntakeGoal();
        context.read(_userInformationProvider).insertUserInformation();
        context.read(_userInformationProvider).queryAllRows();
      },
      child: const Text('APPLY'),
    );
  }
}
