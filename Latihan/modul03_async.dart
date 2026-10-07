// ==========================================
// KELAS EXCEPTION
// ==========================================
class ResiTidakDitemukan implements Exception {
  final String resi;
  ResiTidakDitemukan(this.resi);

  @override
  String toString() => 'Resi $resi tidak ditemukan pada basis data.';
}

// ==========================================
// BASIS DATA RESI (Minimal 5 Resi)
// ==========================================
final Map<String, String> basisStatusResi = {
  'SLG-001': 'Paket sedang dalam perjalanan menuju gudang transit Bandung.',
  'SLG-002': 'Paket telah tiba di fasilitas sortir Surabaya.',
  'SLG-003': 'Paket sedang diantar oleh kurir ke alamat penerima.',
  'SLG-004': 'Paket telah diterima oleh Budi (Ybs) di Jakarta.',
  'SLG-005': 'Paket diproses di pusat logistik Semarang.',
};

// ==========================================
// FUNGSI ASINKRON (Latihan 3 & Tugas Praktikum 1)
// ==========================================
Future<String> ambilStatusKiriman(String resi) async {
  // Simulasi jeda pengambilan data dari server/jaringan selama 1 detik
  await Future.delayed(const Duration(seconds: 1));

  final status = basisStatusResi[resi];
  if (status == null) {
    throw ResiTidakDitemukan(resi);
  }
  return status;
}

Future<double> ambilOngkir(String resi) async {
  await Future.delayed(const Duration(seconds: 1));
  return 105400;
}

// ==========================================
// FUNGSI LATIHAN 4: Perbandingan Waktu Berurutan vs Paralel
// ==========================================
Future<void> bandingkanWaktu() async {
  final mulai = DateTime.now();
  final hasil = await Future.wait([
    ambilStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001'),
  ]);
  final durasi = DateTime.now().difference(mulai);
  print('Status       : ${hasil[0]}');
  print('Ongkir       : Rp${(hasil[1] as double).toStringAsFixed(0)}');
  print('Durasi total : ${durasi.inMilliseconds} ms');
}

// ==========================================
// TUGAS PRAKTIKUM 2: Pemantauan Banyak Resi secara Bersamaan
// ==========================================
Future<void> pantauBanyakResi(List<String> daftarResi) async {
  final List<String> resiGagal = [];
  final List<String> hasilBerhasil = [];

  // Menjalankan pemanggilan seluruh resi secara bersamaan (paralel)
  final futures = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      hasilBerhasil.add('$resi: $status');
      print('  [BERHASIL] $resi -> $status');
    } on ResiTidakDitemukan catch (e) {
      resiGagal.add(resi);
      print('  [GAGAL]    $resi -> $e');
    } catch (e) {
      resiGagal.add(resi);
      print('  [GAGAL]    $resi -> Terjadi kesalahan: $e');
    }
  }).toList();

  await Future.wait(futures);

  print('\n  Ringkasan Pemantauan:');
  print('  - Total diproses  : ${daftarResi.length}');
  print('  - Berhasil        : ${hasilBerhasil.length}');
  print('  - Gagal tercatat  : ${resiGagal.length} (${resiGagal.isEmpty ? "Tidak ada" : resiGagal.join(", ")})');
}

// ==========================================
// MAIN FUNCTION
// ==========================================
Future<void> main() async {
  print('=====================================================');
  print('1. LATIHAN 3: Pemanggilan Berurutan (Sequential)');
  print('=====================================================');
  final stopwatch = Stopwatch()..start();
  print('1. Permintaan data dikirim...');
  try {
    final status = await ambilStatusKiriman('SLG-002');
    print('2. $status');
    final ongkir = await ambilOngkir('SLG-002');
    print('3. Ongkos kirim: Rp${ongkir.toStringAsFixed(0)}');
  } on ResiTidakDitemukan catch (e) {
    print('Kesalahan resi: $e');
  } catch (e) {
    print('Gagal mengambil data: $e');
  }
  print('4. Proses selesai.');
  stopwatch.stop();
  print('Durasi berurutan: ${stopwatch.elapsedMilliseconds} ms\n');

  print('=====================================================');
  print('2. LATIHAN 4: Eksekusi Paralel (Future.wait)');
  print('=====================================================');
  await bandingkanWaktu();
  print('');

  print('=====================================================');
  print('3. TUGAS PRAKTIKUM - SKENARIO 1: Seluruh Resi Sah');
  print('=====================================================');
  final resiSah = ['SLG-001', 'SLG-002', 'SLG-003', 'SLG-004', 'SLG-005'];
  await pantauBanyakResi(resiSah);
  print('');

  print('=====================================================');
  print('4. TUGAS PRAKTIKUM - SKENARIO 2: Terdapat Resi Tidak Sah');
  print('=====================================================');
  final resiCampuran = ['SLG-001', 'SLG-999', 'SLG-003', 'XYZ-123', 'SLG-005'];
  await pantauBanyakResi(resiCampuran);
  print('=====================================================');
}
