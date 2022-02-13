import 'package:cloud_firestore/cloud_firestore.dart';

get today {
  Timestamp time = Timestamp.fromDate(DateTime.now());
  return time;
}