import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';

class BluetoothOnView extends StatefulWidget {
  const BluetoothOnView({Key? key}) : super(key: key);

  @override
  State<BluetoothOnView> createState() => _BluetoothOnViewState();
}

class _BluetoothOnViewState extends State<BluetoothOnView> {
  bool lighting = false;
  bool airConditioning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(AppStrings.lightingCheckBox),
                  activeColor: AppColors.checkBoxActiveColor,
                  value: lighting,
                  onChanged: (value) {
                    setState(() {
                      lighting = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(AppStrings.airConditioningCheckBox),
                  activeColor: AppColors.checkBoxActiveColor,
                  value: airConditioning,
                  onChanged: (value) {
                    setState(() {
                      airConditioning = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ElevatedButton(
              child: const Text(AppStrings.configure),
              onPressed: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () {
                FlutterBlue.instance.stopScan();
              },
              backgroundColor: AppColors.stopColor,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              onPressed: () {
                FlutterBlue.instance.startScan(
                  timeout: const Duration(seconds: 4),
                );
              },
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
