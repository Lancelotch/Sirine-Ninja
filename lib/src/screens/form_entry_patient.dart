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
  String ruanganId = '';
  String ruangKamarId = '';
  String ruangKamarTidurId = '';
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
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.all(32),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DropdownButtonFormField(
                        value: ruanganId,
                        items: const [
                          DropdownMenuItem<String>(
                              child: Text('-Ruangan-'), value: ''),
                          DropdownMenuItem<String>(
                              child: Text('ruangan-1'), value: 'ruangan-1'),
                          DropdownMenuItem<String>(
                              child: Text('ruangan-2'), value: 'ruangan-2'),
                          DropdownMenuItem<String>(
                              child: Text('ruangan-3'), value: 'ruangan-3'),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            ruanganId = value!;
                          });
                        },
                        validator: (value) {
                          if (ruanganId == '') {
                            return 'You must select ruangan';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            fieldValues['ruanganId'] = value.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DropdownButtonFormField(
                        value: ruangKamarId,
                        items: const [
                          DropdownMenuItem<String>(
                              child: Text('-Kamar-'), value: ''),
                          DropdownMenuItem<String>(
                              child: Text('kamar-1'), value: 'kamar-1'),
                          DropdownMenuItem<String>(
                              child: Text('kamar-2'), value: 'kamar-2'),
                          DropdownMenuItem<String>(
                              child: Text('kamar-3'), value: 'kamar-3'),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            ruangKamarId = value!;
                          });
                        },
                        validator: (value) {
                          if (ruangKamarId == '') {
                            return 'You must select kamar';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            fieldValues['ruangKamarId'] = value.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DropdownButtonFormField(
                        value: ruangKamarTidurId,
                        items: const [
                          DropdownMenuItem<String>(
                              child: Text('-Tempat tidur-'), value: ''),
                          DropdownMenuItem<String>(
                              child: Text('tempat-tidur-1'),
                              value: 'tempat-tidur-1'),
                          DropdownMenuItem<String>(
                              child: Text('tempat-tidur-2'),
                              value: 'tempat-tidur-2'),
                          DropdownMenuItem<String>(
                              child: Text('tempat-tidur-3'),
                              value: 'tempat-tidur-3'),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            ruangKamarTidurId = value!;
                          });
                        },
                        validator: (value) {
                          if (ruangKamarTidurId == '') {
                            return 'You must select tempat tidur';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            fieldValues['ruangKamarTidurId'] = value.toString();
                          });
                        }),
                  ),
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
                                  ruanganId = '';
                                  ruangKamarId = '';
                                  ruangKamarTidurId = '';
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
                                      ruangKamarTidurId:
                                          fieldValues['ruangKamarTidurId'],
                                      ruanganId: fieldValues['ruanganId']);
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
    await docUser.set(json);
  }
}
