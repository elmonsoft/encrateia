import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'my_color.dart';

class MyButton extends RaisedButton {
  MyButton.delete({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.delete,
          textColor: Colors.white,
          child: child ?? const Text('Delete'),
          onPressed: onPressed,
        );

  MyButton.cancel({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.cancel,
          child: child ?? const Text('Cancel'),
          onPressed: onPressed,
        );

  MyButton.save({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.save,
          child: child ?? const Text('Save'),
          onPressed: onPressed,
        );

  MyButton.add({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.add,
          child: child ?? const Text('Add'),
          onPressed: onPressed,
        );

  MyButton.navigate({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.navigate,
          child: child ?? const Text('Navigate'),
          onPressed: onPressed,
        );

  MyButton.detail({Widget child, VoidCallback onPressed})
      : super(
          color: MyColor.detail,
          textColor: Colors.white,
          child: child ?? const Text('Detail'),
          onPressed: onPressed,
        );

  MyButton.activity({Widget child, VoidCallback onPressed})
      : super(
    color: MyColor.activity,
    textColor: Colors.white,
    child: child ?? const Text('Activity'),
    onPressed: onPressed,
  );
}
