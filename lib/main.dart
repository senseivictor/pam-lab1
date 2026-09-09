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
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '.'));

    if (amount == null || amount < 0) {
      setState(() {
        _errorMessage = 'Introduceți o sumă validă, mai mare sau egală cu 0.';
        _result = null;
      });
      return;
    }

    final convertedAmount = amount * _ratesToRon[_sourceCurrency]! /
        _ratesToRon[_targetCurrency]!;

    setState(() {
      _errorMessage = null;
      _result = '${convertedAmount.toStringAsFixed(2)} $_targetCurrency';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversie monedă')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.currency_exchange, size: 72),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Sumă',
                      hintText: 'Exemplu: 100',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _convert(),
                  ),
                  const SizedBox(height: 16),
                  _currencyDropdown(
                    label: 'Moneda sursă',
                    value: _sourceCurrency,
                    onChanged: (value) => setState(() => _sourceCurrency = value!),
                  ),
                  const SizedBox(height: 16),
                  _currencyDropdown(
                    label: 'Moneda destinație',
                    value: _targetCurrency,
                    onChanged: (value) => setState(() => _targetCurrency = value!),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _convert,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Convertește'),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text('Suma convertită'),
                            const SizedBox(height: 8),
                            Text(
                              _result!,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: _ratesToRon.keys
          .map((currency) => DropdownMenuItem(value: currency, child: Text(currency)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
