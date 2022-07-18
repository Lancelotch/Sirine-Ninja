import 'package:flutter/material.dart';

class CheckboxFormField extends StatefulWidget {
  final Function callback;
  const CheckboxFormField({Key? key, required this.callback}) : super(key: key);

  @override
  _CheckboxFormFieldState createState() => _CheckboxFormFieldState();
}

class _CheckboxFormFieldState extends State<CheckboxFormField> {
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (state) {
        return Column(
          children: [
            Checkbox(
              value: checkboxValue,
              onChanged: (value) {
                checkboxValue = value!;
                state.didChange(value);
              },
            ),
            Text(
              state.errorText ?? '',
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        );
      },
      validator: (value) {
        if (!checkboxValue) return 'You must check this box';
        return null;
      },
      onSaved: (value) {
        widget.callback('Check Box', value.toString());
      },
    );
  }
}
