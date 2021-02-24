import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../models/user_information.dart';

final _userInformationProvider =
    StateNotifierProvider((ref) => UserInformationNotifier());

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? const PortraitStyleWidget()
              : const LandscapeStyleWidget(),
        ),
      ),
    );
  }
}

const _titleText = 'Customize your hydration plan';
const _genderText = 'GENDER';
const _birthdayText = 'BIRTHDAY';
const _wakeUpTimeText = 'WAKE-UP TIME';
const _bedtimeText = 'BEDTIME';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget();

  @override
  Widget build(BuildContext context) {
    return Text(
      _titleText,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class InformationFieldsWidget extends StatelessWidget {
  const InformationFieldsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _genderText,
          style: Theme.of(context).textTheme.overline,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const GenderWidget(),
        const SizedBox(
          height: 32.0,
        ),
        Text(
          _birthdayText,
          style: Theme.of(context).textTheme.overline,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const BirthdayWidget(),
        const SizedBox(
          height: 32.0,
        ),
        Text(
          _wakeUpTimeText,
          style: Theme.of(context).textTheme.overline,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const WakeUpTimeWidget(),
        const SizedBox(
          height: 32.0,
        ),
        Text(
          _bedtimeText,
          style: Theme.of(context).textTheme.overline,
        ),
        const SizedBox(
          height: 12.0,
        ),
        const BedtimeWidget(),
      ],
    );
  }
}

class PortraitStyleWidget extends StatelessWidget {
  const PortraitStyleWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const TitleTextWidget(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: const InformationFieldsWidget(),
        ),
        Column(
          children: [
            const ApplyWidget(),
          ],
        ),
      ],
    );
  }
}

class LandscapeStyleWidget extends StatelessWidget {
  const LandscapeStyleWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40.0,
          ),
          child: Column(
            children: [
              const TitleTextWidget(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: const InformationFieldsWidget(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40.0,
          ),
          child: Column(
            children: [
              const ApplyWidget(),
            ],
          ),
        ),
      ],
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

    return Row(
      children: [
        ChoiceChip(
          label: const Text('Male'),
          selected: _genderModel == Gender.male ? true : false,
          onSelected: (_) {
            context.read(_userInformationProvider).selectGender(Gender.male);
          },
        ),
        const SizedBox(
          width: 10.0,
        ),
        ChoiceChip(
          label: const Text('Female'),
          selected: _genderModel == Gender.female ? true : false,
          onSelected: (_) {
            context.read(_userInformationProvider).selectGender(Gender.female);
          },
        ),
      ],
    );
  }
}

final _birthdayState = Provider<DateTime>((ref) {
  return ref.watch(_userInformationProvider.state).birthday;
});

final _birthdayProvider = Provider<DateTime>((ref) {
  return ref.watch(_birthdayState);
});

class BirthdayWidget extends HookWidget {
  const BirthdayWidget();

  @override
  Widget build(BuildContext context) {
    final _birthdayModel = useProvider(_birthdayProvider);

    Future<void> _showDatePicker() async {
      final _dateNow = DateTime.now();

      final _selectedDate = await showDatePicker(
        context: context,
        initialDate: _birthdayModel,
        firstDate: DateTime(1905, 1),
        lastDate: DateTime(_dateNow.year, _dateNow.day),
        initialDatePickerMode: DatePickerMode.year,
      );

      if (_selectedDate != null && _selectedDate != _birthdayModel) {
        context.read(_userInformationProvider).selectBirthday(_selectedDate);
      }
    }

    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: _showDatePicker,
          child: IgnorePointer(
            child: TextFormField(
              key: Key(_birthdayModel.toString()),
              initialValue: DateFormat.yMd().format(_birthdayModel),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                ),
              ),
            ),
          ),
        ),
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
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: _showTimePicker,
          child: IgnorePointer(
            child: TextFormField(
              key: Key(_wakeUpTimeModel.toString()),
              initialValue: _wakeUpTimeModel.format(context),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: const Icon(
                  Icons.brightness_5,
                ),
              ),
            ),
          ),
        ),
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
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: _showTimePicker,
          child: IgnorePointer(
            child: TextFormField(
              key: Key(_bedtimeModel.toString()),
              initialValue: _bedtimeModel.format(context),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: const Icon(
                  Icons.nights_stay,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ApplyWidget extends HookWidget {
  const ApplyWidget();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read(_userInformationProvider).setWaterIntakeGoal();
        context.read(_userInformationProvider).insertUserInformation();

        context.read(_userInformationProvider).queryAllRows();
      },
      icon: const Icon(
        Icons.how_to_reg,
      ),
      label: const Text('APPLY PLAN'),
    );
  }
}
