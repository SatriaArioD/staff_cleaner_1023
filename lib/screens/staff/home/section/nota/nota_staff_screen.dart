import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/screens/staff/home/section/nota/pdf/pdf_nota_digital.dart';

class NotaStaffScreen extends StatefulWidget {
  final String noSurat;
  final ScheduleModel schedule;
  final User? user;

  const NotaStaffScreen(
      {super.key,
      required this.noSurat,
      required this.schedule,
      required this.user});

  @override
  State<NotaStaffScreen> createState() => _NotaStaffScreenState();
}

class _NotaStaffScreenState extends State<NotaStaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(
          widget.noSurat,
          widget.schedule,
          widget.user,
        ),
      ),
    );
    ;
  }
}
