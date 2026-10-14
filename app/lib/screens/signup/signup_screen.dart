import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            spacing: 8,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email address',
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  final v = value?.trim() ?? '';

                  if (v.isEmpty) return 'Email is required';

                  return RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value!)
                      ? null
                      : 'Invalid email';
                },
              ),
              FilledButton(onPressed: () {}, child: Text(''))
            ],
          ),
        ),
      ],
    );
  }
}
