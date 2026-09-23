import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversie monedă',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  final Map<String, double> _ratesToRon = {
    'RON': 1,
    'EUR': 4.97,
    'USD': 4.58,
    'GBP': 5.81,
    'CHF': 5.20,
  };

  String _sourceCurrency = 'RON';
  String _targetCurrency = 'EUR';
  String? _result;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '.'));

    if (amount == null || amount < 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final convertedAmount = amount * _ratesToRon[_sourceCurrency]! /
        _ratesToRon[_targetCurrency]!;

    setState(() {
      _result = '${convertedAmount.toStringAsFixed(2)} $_targetCurrency';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversie monedă')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input: suma
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Sumă'),
            ),
            const SizedBox(height: 16),

            // UI control 1: Dropdown Moneda Sursă
            _currencyDropdown(
              label: 'Moneda sursă',
              value: _sourceCurrency,
              onChanged: (value) => setState(() => _sourceCurrency = value!),
            ),
            const SizedBox(height: 16),

            // UI control 2: Dropdown Moneda Destinație
            _currencyDropdown(
              label: 'Moneda destinație',
              value: _targetCurrency,
              onChanged: (value) => setState(() => _targetCurrency = value!),
            ),
            const SizedBox(height: 16),

            // UI control 3: ElevatedButton
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convertește'),
            ),
            const SizedBox(height: 24),

            // Output: suma convertită afișată într-un Text
            if (_result != null)
              Text(
                _result!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _currencyDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: _ratesToRon.keys
          .map((currency) => DropdownMenuItem(value: currency, child: Text(currency)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
