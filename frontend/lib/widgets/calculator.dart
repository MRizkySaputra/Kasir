import 'package:flutter/material.dart';

class CalculatorWidget extends StatefulWidget {
  final void Function(double result)? onResult;

  const CalculatorWidget({super.key, this.onResult});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _expression = '';
  String _display = '0';

  final operators = ['+', '-', '×', '÷'];

  void _onPress(String value) {
    setState(() {
      /// CLEAR
      if (value == 'C') {
        _expression = '';
        _display = '0';
        widget.onResult?.call(0);
        return;
      }

      /// EQUAL
      if (value == '=') {
        if (_expression.isEmpty) return;

        final result = _calculate(_expression);
        _display = _format(result);
        _expression = _display;
        widget.onResult?.call(result);
        return;
      }

      /// OPERATOR
      if (operators.contains(value)) {
        if (_expression.isEmpty && value != '-') return;

        if (operators.contains(_expression.characters.last)) {
          _expression =
              _expression.substring(0, _expression.length - 1) + value;
        } else {
          _expression += value;
        }
        _display = value;
        return;
      }

      /// NUMBER
      _expression += value;
      _display = value;
    });
  }

  String _format(double val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(2);
  }

  /// ===============================
  /// CORE CALCULATION (AMAN & AKURAT)
  /// ===============================
  double _calculate(String expr) {
    final tokens = _tokenize(expr);
    final rpn = _toRPN(tokens);
    return _evalRPN(rpn);
  }

  List<String> _tokenize(String expr) {
    expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
    final regex = RegExp(r'(\d+\.?\d*|[+\-*/])');
    return regex.allMatches(expr).map((m) => m.group(0)!).toList();
  }

  int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  List<String> _toRPN(List<String> tokens) {
    final output = <String>[];
    final stack = <String>[];

    for (final t in tokens) {
      if (double.tryParse(t) != null) {
        output.add(t);
      } else {
        while (stack.isNotEmpty && _precedence(stack.last) >= _precedence(t)) {
          output.add(stack.removeLast());
        }
        stack.add(t);
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return output;
  }

  double _evalRPN(List<String> rpn) {
    final stack = <double>[];

    for (final t in rpn) {
      if (double.tryParse(t) != null) {
        stack.add(double.parse(t));
      } else {
        final b = stack.removeLast();
        final a = stack.removeLast();

        switch (t) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(b == 0 ? 0 : a / b);
            break;
        }
      }
    }
    return stack.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _displayBox(),
        const SizedBox(height: 10),
        _row(['7', '8', '9', '÷']),
        _row(['4', '5', '6', '×']),
        _row(['1', '2', '3', '-']),
        _row(['C', '0', '=', '+']),
      ],
    );
  }

  Widget _displayBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _expression,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            _display,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _row(List<String> buttons) {
    return Row(
      children: buttons.map((b) {
        final isOp = operators.contains(b) || b == '=' || b == 'C';
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isOp ? Colors.green[600] : Colors.grey[300],
                foregroundColor: isOp ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _onPress(b),
              child: Text(
                b,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
