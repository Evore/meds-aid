import 'package:flutter/material.dart';

import 'labels.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hint;
  final bool hasObscureToggle;
  final bool obscureText;
  final TextInputType textInputType;
  final FormFieldValidator<dynamic> validator;
  InputField(this.controller, this.labelText,
      {this.hasObscureToggle = false,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.validator, this.hint});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomLabel(widget.labelText),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.textInputType,
          onSaved: (input) => this.widget.controller,
          validator: widget.validator ??
              (input) {
                return (input == null || input.isEmpty) ? "Empty field" : null;
              },
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.labelText,
            
            suffixIcon: widget.hasObscureToggle ? suffixIcon() : null,
          ),
        ),
      ],
    );
  }

  Widget suffixIcon() {
    return IconButton(
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
    );
  }
}

class DropDownField extends StatefulWidget {
  final dynamic value;
  final List<dynamic> items;
  final String label;
  final String hint;
  final String errorText;
  final void Function(dynamic) onChanged;
  final bool disabled;
  DropDownField(
      {this.items,
      this.errorText,
      this.value,
      this.label,
      this.hint,
      this.onChanged,
      this.disabled = false});
  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  dynamic value;
  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomLabel(widget.label),
        DropdownButtonFormField(
          isExpanded: true,
            onSaved: (value) => value,
            validator: (input) {
              return (input == null)
                  ? widget.errorText ?? "No value selected"
                  : null;
            },
            hint: Text(widget.hint ?? ''),
            value: value,
            elevation: 2,
            decoration: InputDecoration(enabled: !widget.disabled),
            items: widget.items
                .map((item) => DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    ))
                .toList(),
            onChanged: widget.disabled
                ? null
                : (selectedItem) {
                    setState(() {
                      value = selectedItem;
                    });

                    if (widget.onChanged != null)
                      widget.onChanged(selectedItem);
                  }),
      ],
    );
  }
}
