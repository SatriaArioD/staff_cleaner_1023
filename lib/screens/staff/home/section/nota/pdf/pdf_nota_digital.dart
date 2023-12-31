import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/services/firebase_services.dart';

Future<Uint8List> makePdf(
  String noSurat,
  ScheduleModel schedule,
  User? user,
) async {
  final fs = FirebaseServices();
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());

  List<dynamic> itemYangDibersihkan = schedule.items ?? [];

  final total = itemYangDibersihkan.fold(0, (i, el) {
    return i + el["harga"] as int;
  });

  final qUser =
      await fs.getDataCollectionByQuery("staff", "email", user?.email);

  final date = DateTime.now();

  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 150,
                  width: 250,
                  child: Image(imageLogo),
                ),
                V(8.0),
                Text("PT.YUK BERSIHIN SEJAHTERAH"),
                Text("Jl.Sunan Giri No.1, Rawamangun, Jakarta, 13320"),
                Text("Web            : yukbersihin.com"),
                Text("Email          : yukbersihin.id@gmail.com"),
                Text("Instagram   : @yukbersihin"),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("No: $noSurat"),
                V(8.0),
                Text("Date           : ${date.day}/${date.month}/${date.year}"),
                Text("Customer   : ${schedule.customer?.name ?? '-'}"),
                Text("Addres       :"),
                Container(
                    width: 170, child: Text(schedule.address?.address ?? '-'))
              ]),
            ]),
            V(64.0),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    PaddedText('No'),
                    PaddedText(
                      'Item',
                    ),
                    PaddedText(
                      'Service',
                    ),
                    PaddedText(
                      'Price',
                    )
                  ],
                ),
                for (var i = 0; i < itemYangDibersihkan.length; i++)
                  TableRow(
                    children: [
                      PaddedText(
                        "${i + 1}",
                      ),
                      PaddedText(
                        "${itemYangDibersihkan[i]["item"]}",
                      ),
                      PaddedText(
                        "${itemYangDibersihkan[i]["service"]}",
                      ),
                      PaddedText(
                        "Rp. ${itemYangDibersihkan[i]["harga"]}",
                      )
                    ],
                  )
              ],
            ),
            V(24.0),
            Container(
                width: double.infinity,
                color: PdfColors.grey,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("TOTAL: Rp. $total"))),
            V(140.0),
            Align(
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
            ),
            V(64.0),
            Text("Terms of Payment:"),
            Text("- The payment transfer to our account:"),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("BCA 0948589772 PT. YUK BERSIHIN SEJAHTERAH")),
            Text(
                "- Please send us the payment proof to our Whatsapp 08111129089"),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );

Widget H(n) => SizedBox(width: n);

Widget V(n) => SizedBox(height: n);
