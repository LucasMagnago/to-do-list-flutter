import 'package:flutter/material.dart';

class Task {
  final String _id = UniqueKey().toString();
  String _description = "";
  bool _done = false;

  Task(this._description, this._done);

  String get id => _id;
  String get description => _description;
  bool get done => _done;

  set description(String description) {
    _description = description;
  }

  set done(bool done) {
    _done = done;
  }
}
