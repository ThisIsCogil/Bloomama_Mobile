# Bloomama Mobile 🌸👶

Bloomama Mobile adalah aplikasi pendamping kehamilan dan kesehatan ibu yang dibangun menggunakan Flutter. Aplikasi ini membantu calon ibu untuk melacak perkembangan kehamilan dari minggu ke minggu, memantau kondisi kesehatan, mengatur jadwal konsultasi medis, serta mendapatkan akses ke mentor dan tips seputar kehamilan.

## ✨ Fitur Utama

- **Pelacak Kehamilan (Pregnancy Tracker):** Pantau perkembangan janin dari minggu ke-1 hingga minggu ke-40 dengan visualisasi menarik (termasuk aset 3D dan ilustrasi).
- **Manajemen Janji Temu (Appointments):** Jadwalkan dan kelola konsultasi dengan dokter atau bidan.
- **Sistem Mentoring:** Akses khusus ke mentor untuk mendapatkan saran dan dukungan selama masa kehamilan.
- **Pemantauan Kesehatan:** Lacak parameter kesehatan ibu dan bayi dengan antarmuka yang ramah pengguna.
- **Artikel & Tips Harian:** Dapatkan tips dan trik yang disesuaikan dengan usia kandungan.
- **Otentikasi Aman:** Sistem login, pendaftaran, dan manajemen profil pengguna yang terjamin keamanannya.

## 🛠 Teknologi yang Digunakan

- **Framework:** [Flutter](https://flutter.dev/) (Cross-platform UI framework)
- **Bahasa Pemrograman:** Dart
- **Aset & Animasi:** Menggunakan ilustrasi kustom, model 3D (`.glb`), dan animasi [Lottie](https://lottiefiles.com/).
- **Integrasi API:** Layanan REST API internal menggunakan `ApiService`.

## 📋 Prasyarat Instalasi

Sebelum Anda dapat menjalankan project ini di komputer lokal Anda, pastikan Anda telah menginstal:

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi stable terbaru disarankan).
2. [Dart SDK](https://dart.dev/get-dart) (sudah termasuk dalam paket Flutter).
3. IDE seperti [Visual Studio Code](https://code.visualstudio.com/) atau [Android Studio](https://developer.android.com/studio).
4. Emulator Android/iOS atau perangkat fisik untuk pengujian.

## 📂 Susunan Project

Berikut adalah struktur utama dari folder `lib/` (kode sumber aplikasi):

- `lib/controllers/` : Logika bisnis dan State Management (Auth, Kesehatan, Kehamilan, dll).
- `lib/models/` : Struktur data (User, Appointment, Health, Event, dll).
- `lib/services/` : Kelas untuk mengelola request ke API/Backend.
- `lib/views/` : Kumpulan UI/Halaman Aplikasi (Screens, Bottomsheets, dll).
- `lib/widgets/` : Komponen UI yang dapat digunakan kembali (Reusable components).
- `lib/auth_middleware.dart` : Middleware untuk menangani sesi otentikasi.
- `lib/main.dart` : Titik masuk utama (Entry point) aplikasi.

## 🚀 Contoh Penggunaan (Instalasi & Menjalankan)

```bash
# 1. Clone repositori ini
git clone [https://github.com/username/bloomama_mobile.git](https://github.com/username/bloomama_mobile.git)
cd bloomama_mobile

# 2. Unduh semua dependensi (packages)
flutter pub get

# 3. Jalankan aplikasi di emulator atau perangkat yang terhubung
flutter run

# 4. Kompilasi ke APK (opsional untuk Android)
flutter build apk --release
```

## 🤝 Kontribusi

Kami sangat menyambut kontribusi dari komunitas! Jika Anda ingin berkontribusi, silakan ikuti langkah-langkah berikut:

1. *Fork* repositori ini.
2. Buat *branch* fitur Anda (`git checkout -b fitur/FiturLuarBiasa`).
3. Lakukan *commit* pada perubahan Anda (`git commit -m 'Menambahkan beberapa FiturLuarBiasa'`).
4. *Push* ke *branch* tersebut (`git push origin fitur/FiturLuarBiasa`).
5. Buka sebuah *Pull Request* (PR).

Pastikan kode yang Anda tulis rapi dan tidak merusak fitur yang sudah ada. 

## 📄 Lisensi

Project ini dilisensikan di bawah **MIT License**.

MIT License

Copyright (c) 2026 Bloomama

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
