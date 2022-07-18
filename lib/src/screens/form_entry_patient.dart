import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ninja/src/models/patient_visit.dart';
import 'package:ninja/src/widgets/checkbox_form_field.dart';
import 'package:ninja/src/widgets/radio_form_field.dart';

class FormEntryPatient extends StatefulWidget {
  const FormEntryPatient({Key? key}) : super(key: key);
  static const routeName = '/form-entry-patient';
  @override
  _FormEntryPatientState createState() => _FormEntryPatientState();
}

class _FormEntryPatientState extends State<FormEntryPatient> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  String dropdownValue = '';
  Map<String, String> fieldValues = {};

  setFieldValue(label, value) {
    fieldValues[label] = value;
  }

  TextEditingController noRm = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController room = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Entry Pasien')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nomor rekam medis',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Field is required.';
                        return null;
                      },
                      controller: noRm,
                      onSaved: (value) {
                        setState(() {
                          fieldValues['noRm'] = value!;
                        });
                      }),
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Field is required.';
                        return null;
                      },
                      controller: name,
                      onSaved: (value) {
                        setState(() {
                          fieldValues['nama'] = value!;
                        });
                      }),
                  DropdownButtonFormField(
                      value: dropdownValue,
                      items: const [
                        DropdownMenuItem<String>(
                            child: Text('-Pilih-Ruangan-'), value: ''),
                        DropdownMenuItem<String>(
                            child: Text('President'), value: 'mewah'),
                        DropdownMenuItem<String>(
                            child: Text('Bupati'), value: 'standart'),
                        DropdownMenuItem<String>(
                            child: Text('Rakyat'), value: 'sengsara'),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      validator: (value) {
                        if (dropdownValue == '') {
                          return 'You must select ruangan';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          fieldValues['ruangKamarId'] = value.toString();
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(140, 52),
                                  textStyle: TextStyle(fontSize: 20)),
                              onPressed: () {
                                noRm.clear();
                                name.clear();
                                setState(() {
                                  dropdownValue = '';
                                });
                              },
                              child: Text('Reset')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(140, 52),
                                  textStyle: TextStyle(fontSize: 20)),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  _key.currentState!.save();

                                  final patientVisit = PatienVisit(
                                      id: '112334',
                                      nama: name.text,
                                      noRm: noRm.text,
                                      ruangKamarId: fieldValues['ruangKamarId'],
                                      ruangKamarTidurId: 'ngarang',
                                      ruanganId: 'ssss');
                                  createPatientVisit(patientVisit);
                                }
                              },
                              child: Text('submit')),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future createPatientVisit(PatienVisit patient) async {
    final docUser =
        FirebaseFirestore.instance.collection('test-kunjungan').doc();

    final json = patient.toJson();
    await docUser.set({'name': 'candra'});
  }
}
