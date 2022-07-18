import 'package:flutter/material.dart';

class RadioFormField extends StatefulWidget {
  final Function callback;
  const RadioFormField({Key? key, required this.callback}) : super(key: key);

  @override
  _RadioFormFieldState createState() => _RadioFormFieldState();
}

class _RadioFormFieldState extends State<RadioFormField> {
  String radioValue = 'Top';

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (state) {
        return Column(
          children: [
            Radio<String>(
                value: 'Top',
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value!;
                  });
                }),
            Radio<String>(
                value: 'Bottom',
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value!;
                  });
                }),
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
        if (radioValue == 'Bottom')
          return 'You must choose the top radio button.';
        return null;
      },
      onSaved: (value) {
        widget.callback('Radio', radioValue);
      },
    );
  }
}
