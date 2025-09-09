import 'package:flutter/material.dart';

class FlagPage extends StatefulWidget {
  final String flag;
  final int sliderValue;

  const FlagPage({super.key, required this.flag, required this.sliderValue});

  @override
  State<FlagPage> createState() => _FlagPageState();
}

class _FlagPageState extends State<FlagPage> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.sliderValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flag Preview")),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Center(child: Image.network(widget.flag, width: _value)),
            ),
            Slider(
              value: _value,
              min: 50,
              max: 1000,
              onChanged: (v) {
                setState(() => _value = v);

                if (_value < 400) {
                  Navigator.pop(context, _value.toInt());
                }
              },
            ),
            SizedBox(height: 12),
            Text("Size: ${_value.toInt()} px", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
