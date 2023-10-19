import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/services/firebase_services.dart';

Future<Uint8List> makePdf(
  String noSurat,
  ScheduleModel schedule,
  User? user,
) async {
  final fs = FirebaseServices();
  final pdf = pw.Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());

  pdf.addPage(pw.MultiPage(header: (context) {
    return _header(context, imageLogo, noSurat, schedule);
  }, footer: (context) {
    return _footer(context);
  }, build: (context) {
    return [
      _contentTable(context, schedule),
      V(24.0),
      _contentPrice(context, schedule),
      V(48.0),
      _contentSignature(context, schedule),
      V(32.0),
      _contentTerms(context),
    ];
  }));
  return pdf.save();
}

pw.Widget _header(
  pw.Context context,
  MemoryImage imageLogo,
  String noSurat,
  ScheduleModel schedule,
) {
  final DateTime date = DateTime.now();
  return pw.Column(
    children: [
      pw.Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                height: 150,
                width: 250,
                child: Image(imageLogo),
              ),
              V(8.0),
              pw.Text("PT.YUK BERSIHIN SEJAHTERAH"),
              pw.Text("Jl.Sunan Giri No.1, Rawamangun, Jakarta, 13320"),
              pw.Text("Web            : yukbersihin.com"),
              pw.Text("Email          : yukbersihin.id@gmail.com"),
              pw.Text("Instagram   : @yukbersihin"),
            ],
          ),
          pw.Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pw.Text("No: $noSurat"),
              V(8.0),
              pw.Text(
                  "Date           : ${date.day}/${date.month}/${date.year}"),
              pw.Text("Customer   : ${schedule.customer?.name ?? '-'}"),
              pw.Text("Addres       :"),
              pw.Container(
                width: 170,
                child: Text(schedule.address?.address ?? '-'),
              )
            ],
          ),
        ],
      ),
      V(64.0),
    ],
  );
}

pw.Widget _contentTable(pw.Context context, ScheduleModel schedule) {
  List<dynamic> itemYangDibersihkan = schedule.items ?? [];

  return pw.Table(
    border: TableBorder.all(color: PdfColors.black),
    children: [
      pw.TableRow(
        children: [
          paddedText('No'),
          paddedText(
            'Item',
          ),
          paddedText(
            'Service',
          ),
          paddedText(
            'Price',
          )
        ],
      ),
      for (var i = 0; i < itemYangDibersihkan.length; i++)
        TableRow(
          children: [
            paddedText(
              "${i + 1}",
            ),
            paddedText(
              "${itemYangDibersihkan[i]["item"]} ${convertNote(itemYangDibersihkan[i])}",
            ),
            paddedText(
              "${itemYangDibersihkan[i]["service"]}",
            ),
            paddedText(
              formatter().format(convertPrice(itemYangDibersihkan[i])),
            )
          ],
        )
    ],
  );
}

pw.Widget _contentPrice(pw.Context context, ScheduleModel schedule) {
  List<dynamic> itemYangDibersihkan = schedule.items ?? [];
  final total = itemYangDibersihkan.fold(0, (i, el) {
    return i + convertPrice(el).toInt();
  });
  return pw.Container(
    width: double.infinity,
    color: PdfColors.grey,
    child: pw.Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (convertDiscount(schedule) != null) ...[
            Text(
                'DISKON: ${schedule.discountType == 'Nominal' ? formatter().format(convertDiscount(schedule)) : '${convertDiscount(schedule)}%'} (${schedule.discountType})'),
            V(4.0),
          ],
          Text(
              "TOTAL: ${formatter().format(convertTotalWithDiscount(schedule, total))}"),
        ],
      ),
    ),
  );
}

pw.Widget _contentSignature(pw.Context context, ScheduleModel schedule) {
  return pw.Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          schedule.staffs?.length ?? 0,
          (index) => Container(
            margin: EdgeInsets.only(top: index == 0 ? 0 : 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schedule.staffs![index].fullName ?? '-'),
                Divider(),
                Text(
                    'Staff cleaner ${schedule.staffs!.length > 1 ? '${index + 1}' : ''}'),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

pw.Widget _contentTerms(pw.Context context) {
  return pw.Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pw.Text("Terms of Payment:"),
      pw.Text("- The payment transfer to our account:"),
      pw.Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: pw.Text("BCA 0948589772 PT. YUK BERSIHIN SEJAHTERAH")),
      pw.Text("- Please send us the payment proof to our Whatsapp 08111129089"),
    ],
  );
}

pw.Widget _footer(pw.Context context) {
  return pw.Container(
    margin: const EdgeInsets.only(top: 64.0),
    alignment: Alignment.bottomRight,
    child: pw.Text(
      'Page ${context.pageNumber}/${context.pagesCount}',
      style: const pw.TextStyle(
        fontSize: 12,
        color: PdfColors.black,
      ),
    ),
  );
}

NumberFormat formatter() {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );
}

String convertNote(Map value) {
  if (value['lebar'] != null && value['panjang'] != null) {
    return '\ntotal luas: ${convertLuas(value)} m²  @${value['harga']}';
  }
  return '';
}

num convertLuas(Map value) {
  num lebar = value['lebar'];
  num panjang = value['panjang'];
  num total = lebar * panjang;
  return total;
}

num convertPrice(Map value) {
  if (value['lebar'] != null && value['panjang'] != null) {
    num lebar = value['lebar'];
    num panjang = value['panjang'];
    num harga = value['harga'];
    num total = lebar * panjang * harga;
    return total;
  }
  return value['harga'];
}

num convertTotalWithDiscount(ScheduleModel schedule, int total) {
  num diskon = num.tryParse(schedule.discount ?? '') ?? 0;
  String? diskonType = schedule.discountType;
  if (diskonType != null) {
    if (diskonType == 'Nominal') {
      return total - diskon;
    }
    if (diskonType == 'Persentase') {
      return total - ((diskon / 100) * total);
    }
  }
  return total;
}

num? convertDiscount(ScheduleModel schedule) {
  if (schedule.discountType != null) {
    return num.tryParse(schedule.discount ?? '');
  }
  return null;
}

Widget paddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    pw.ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 48,
        ),
        child: pw.Padding(
          padding: const EdgeInsets.all(10),
          child: pw.Text(
            text,
            textAlign: align,
          ),
        ));

Widget H(n) => pw.SizedBox(width: n);

Widget V(n) => pw.SizedBox(height: n);
