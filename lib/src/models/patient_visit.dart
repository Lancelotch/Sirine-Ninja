import 'dart:ffi';

class TandaVital {
  final int skor;
  final int tandaVitalId;
  TandaVital(this.skor, this.tandaVitalId);
}

class PatienVisit {
  String id;
  final String nama;
  final String noRm;
  final String? ruangKamarId;
  final String? ruangKamarTidurId;
  final String? ruanganId;
  final int? scoreEws;
  final List<TandaVital>? tandaVitals;

  PatienVisit(
      {this.id = '',
      required this.nama,
      required this.noRm,
      this.ruangKamarId,
      this.ruangKamarTidurId,
      this.ruanganId,
      this.scoreEws,
      this.tandaVitals});

  Map<String, dynamic> toJson() => {
        'instruksi_id': id,
        'nama': nama,
        'no_rm': noRm,
        'ruang_kamar_id': ruangKamarId,
        'ruang_kamar_tidur_id': ruangKamarTidurId,
        'ruangan_id': ruanganId
      };
}
