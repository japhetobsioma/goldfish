import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/helpers.dart';
import '../../models/user_info.dart';
import '../../states/cup.dart';
import '../../states/cup_manager.dart';

class CupManagerScreen extends HookWidget {
  const CupManagerScreen();

  @override
  Widget build(BuildContext context) {
    final cup = useProvider(cupProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cup'),
      ),
      body: Container(
        width: double.maxFinite,
        child: cup.when(
          data: (value) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.allCup.length,
              itemBuilder: (_, index) {
                final id = value.allCup[index]['cupID'] as int;
                final amount = value.allCup[index]['amount'] as int;
                final measurement =
                    (value.allCup[index]['measurement'] as String)
                        .toLiquidMeasurement;

                return Column(
                  children: [
                    CupItem(
                      id: id,
                      amount: amount,
                      measurement: measurement,
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dialogResult = await showDialog(
            context: context,
            builder: (context) => const AddCupDialog(),
          );

          if (dialogResult == 'SAVE') {
            await context.read(cupManagerProvider).addCup();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CupItem extends StatelessWidget {
  const CupItem({
    @required this.id,
    @required this.amount,
    @required this.measurement,
  });

  final int id;
  final int amount;
  final LiquidMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.local_cafe),
      title: Text('$amount ${measurement.description}'),
    );
  }
}

class AddCupDialog extends HookWidget {
  const AddCupDialog();

  @override
  Widget build(BuildContext context) {
    final amountGlobalKey = useState(GlobalKey<FormState>());
    final amountTextController = useTextEditingController();
    final cup = useProvider(cupProvider.state);

    return AlertDialog(
      title: const Text('Add cup'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Wrap(
        children: [
          Form(
            key: amountGlobalKey.value,
            child: TextFormField(
              controller: amountTextController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Amount',
                hintText: 'e.g. 100',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (amount) {
                if (amount.isEmpty) {
                  return 'Enter amount';
                }

                if (amount.isZero) {
                  return 'The amount can not be 0';
                }

                if (double.tryParse(amount) == null) {
                  return 'Invalid number format';
                }

                if (double.tryParse(amount) < 0) {
                  return 'The amount can not be negative';
                }

                List<Map<String, dynamic>> cupList;
                var isDuplicate = false;
                cup.when(
                  data: (value) {
                    cupList = value.allCup;

                    cupList.forEach((element) {
                      final listAmount = element['amount'] as int;

                      if (listAmount == int.tryParse(amount)) {
                        isDuplicate = true;
                      }
                    });
                  },
                  loading: () {},
                  error: (_, __) {},
                );
                if (isDuplicate) {
                  return 'The same cup amount is already inserted';
                }

                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            amountGlobalKey.value.currentState.validate();

            if (amountGlobalKey.value.currentState.validate()) {
              amountGlobalKey.value.currentState.validate();

              final cupAmount = int.tryParse(amountTextController.text);
              context.read(cupManagerProvider).setCupAmount(cupAmount);

              Navigator.pop(context, 'SAVE');
            }
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
