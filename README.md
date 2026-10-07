# Modul 3: Null Safety dan Pemrograman Asinkron

Repositori ini berisi implementasi latihan dan tugas praktikum untuk **Modul 3: Null Safety dan Pemrograman Asinkron** pada mata kuliah **Pemrograman IV**.

---

## 📁 Struktur Berkas

```text
Modul3/
├── Dokument/
│   └── 03 Modul Praktikum Pemrograman IV - Modul 03.pdf
├── Latihan/
│   ├── modul03_nullsafety.dart   # Latihan 1 (Null Safety) & Latihan 2 (Penanganan Error)
│   └── modul03_async.dart        # Latihan 3, 4 & Tugas Praktikum (Async/Await, Future.wait)
└── README.md
```

---

## 🛠️ Prasyarat

Pastikan Dart SDK atau Flutter SDK sudah terpasang di komputer Anda. Periksa instalasi dengan perintah:

```bash
dart --version
```

---

## 🚀 Cara Menjalankan Program

Buka terminal pada direktori utama proyek (`Modul3`), kemudian jalankan perintah berikut:

### 1. Memeriksa Kualitas & Analisis Kode (Linter)
Pastikan tidak ada issue atau error pada penulisan kode:
```bash
dart analyze
```

---

### 2. Menjalankan Modul Null Safety & Penanganan Error
Berkas ini memuat implementasi penanganan data opsional dengan operator null-aware serta penanganan custom exception (`ResiTidakDitemukan`) menggunakan blok `try-catch-on-finally`.

```bash
dart run Latihan/modul03_nullsafety.dart
```

---

### 3. Menjalankan Modul Pemrograman Asinkron & Tugas Praktikum
Berkas ini memuat:
* **Latihan 3**: Pengambilan data asinkron secara berurutan (*sequential*).
* **Latihan 4**: Pengambilan data secara paralel menggunakan `Future.wait`.
* **Tugas Praktikum (Skenario 1)**: Pemantauan banyak resi sah secara bersamaan.
* **Tugas Praktikum (Skenario 2)**: Pemantauan banyak resi yang memuat resi tidak terdaftar tanpa menghentikan proses pelacakan resi lainnya.

```bash
dart run Latihan/modul03_async.dart
```

---

## 📊 Ringkasan Fitur Tugas Praktikum

* **Custom Exception**: `ResiTidakDitemukan` dilemparkan saat resi tidak terdapat di basis data.
* **Basis Data Resi**: Menggunakan struktur `Map<String, String>` berisi daftar resi logistik.
* **Eksekusi Paralel & Fault-Tolerant**: Fungsi `pantauBanyakResi` menjalankan pelacakan seluruh resi secara serentak menggunakan `Future.wait` dengan isolasi error per resi, sehingga kegagalan satu resi tidak membatalkan atau mematikan proses resi yang valid.