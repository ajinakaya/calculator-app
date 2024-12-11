import 'package:flutter/material.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajina Calculator App'),
        centerTitle: true,
      ),
      body: const CalculatorView(),
    );
  }
}

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _history = [];
  int? first;
  String operation = "";

  void onButtonPressed(String symbol) {
    if (symbol == "C") {
      _textController.clear();
      first = null;
      operation = "";
      _history.clear();
    } else if (symbol == "<-") {
      if (_textController.text.isNotEmpty) {
        _textController.text =
            _textController.text.substring(0, _textController.text.length - 1);
      }
    } else if (["+", "-", "*", "/", "%"].contains(symbol)) {
      if (_textController.text.isNotEmpty) {
        first = int.tryParse(_textController.text);
        if (first != null) {
          _history.insert(0, "$first");
        }
        operation = symbol;
        _textController.clear();
      }
    } else if (symbol == "=") {
      if (_textController.text.isNotEmpty &&
          first != null &&
          operation.isNotEmpty) {
        int second = int.tryParse(_textController.text) ?? 0;
        int result = 0;

        switch (operation) {
          case "+":
            result = first! + second;
            break;
          case "-":
            result = first! - second;
            break;
          case "*":
            result = first! * second;
            break;
          case "/":
            result = second != 0 ? first! ~/ second : 0;
            break;
          case "%":
            result = first! % second;
            break;
        }

        _history.insert(0, "$first $operation $second = $result");
        _textController.text = result.toString();
        first = null;
        operation = "";
      }
    } else {
      _textController.text += symbol;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> lstSymbols = [
      '7',
      '8',
      '9',
      '/',
      '4',
      '5',
      '6',
      '*',
      '1',
      '2',
      '3',
      '-',
      'C',
      '0',
      '=',
      '+',
      '<-',
      '%'
    ];

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _history[index],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // TextBox for input and output
              TextField(
                controller: _textController,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: lstSymbols.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () => onButtonPressed(lstSymbols[index]),
                      child: Text(
                        lstSymbols[index],
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
              ),
            ],
            ),
        );
  }
}
