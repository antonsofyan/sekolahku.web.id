# Buku Panduan Pengguna: Sistem Penerimaan Murid Baru (SPMB)
**Versi: 2.0.0**

## PERSYARATAN SISTEM MINIMUM
- **PHP**: Versi 8.5 atau lebih tinggi
- **MySQL**: Versi 8.0 atau lebih tinggi (atau MariaDB 10.6+)
- **Ekstensi PHP**: `ctype`, `curl`, `dom`, `libxml`, `mbstring`, `mysqli`, `gd`, `mbstring`
- **Composer**: Untuk manajemen dependensi
- **Web Server**: Apache (mod_rewrite) atau Nginx

> [!TIP]
> **Saran Deployment**: Sistem ini akan berjalan dengan performa maksimal dan stabilitas yang baik jika menggunakan **VPS (Virtual Private Server)** dengan akses penuh ke sistem operasi, bukan pada layanan *shared hosting*.

## KEUNGGULAN UTAMA SISTEM

Sistem PMB ini dirancang bukan sekadar sebagai formulir pendaftaran digital, melainkan sebuah platform manajemen penerimaan yang *scalable* dan modern. Berikut adalah kelebihan utamanya:

1. **Multi-Level & Multi-Cabang (Skala Yayasan)**
   Sistem ini mendukung berbagai jenjang pendidikan dalam satu yayasan — dari SD, SMP, SMA, hingga SMK — sekaligus multi-cabang di berbagai lokasi. Satu instalasi dapat mengelola penerimaan siswa baru untuk seluruh unit sekolah dalam satu yayasan dengan konfigurasi yang terpisah per cabang.

2. **Arsitektur Relasional yang Mature**
   Sistem dibangun dengan MySQL InnoDB yang telah teruji dan didukung secara luas. Struktur database fully relational dengan foreign key semantics, indexing komprehensif, dan soft-delete pattern di setiap tabel. Cocok untuk deployment di berbagai penyedia hosting.

3. **Kemandirian Digital (Tanpa Vendor Lock-in)**
   Institusi memiliki kontrol 100% penuh atas data privasi calon siswa dan *source code* aplikasi. Tidak perlu biaya langganan tahunan atau per-siswa.

4. **Keamanan Lapis Ganda**
   Aplikasi dilengkapi Rate Limiting (ThrottleFilter) pada endpoint autentikasi, **Cloudflare Turnstile** untuk perlindungan bot tanpa *captcha*, password policy yang ketat (bcrypt cost 12), remember-me token dengan bcrypt, session ID regeneration setelah login, soft delete dengan pemulihan data, serta validasi file upload.

5. **Performa Ekstra Cepat & Ringan**
   Dibangun di atas CodeIgniter 4 dengan *Single Page Application behavior* (CoreUI 5), waktu muat halaman sangat cepat — penting saat ribuan calon pendaftar mengakses sistem secara serentak.

6. **Sistem Persyaratan Hybrid (General & Specific Requirements)**
   Sistem mendukung logika kombinasi **Persyaratan Umum** (berlaku untuk seluruh prodi dalam satu tahun ajaran) dan **Persyaratan Khusus** (per *admission offering*). Logika ini berlaku untuk **Nilai Rapor**, **Nilai Ujian Saringan Masuk**, maupun **Dokumen**. Sistem secara otomatis menggabungkan keduanya sehingga pendaftar melihat daftar persyaratan yang lengkap dan relevan.

7. **Model Data Hierarkis yang Komprehensif**
   Data master menggunakan model hierarkis: **Yayasan (Foundation) → Sekolah/Cabang → Jenjang Kelas (Entry Grade) → Program Kelas (Education Track) → Jurusan/Program Keahlian (Education Program)** — mencakup kebutuhan SD (tanpa jurusan), SMP (tanpa jurusan), SMA (IPA/IPS/Bahasa), dan SMK (TKJ/AKL/DKV dll).

8. **Mendukung Multi-Registrasi (Opsional)**
   Administrator dapat mengaktifkan fitur multi-registrasi melalui Pengaturan Aplikasi. Calon siswa dapat mendaftar ke beberapa program dalam satu periode (maksimal sesuai pengaturan). Fitur ini berguna untuk sistem seleksi dengan preferensi ganda.

9. **Soft Delete & Data Recovery**
   Semua data master dan registrasi mendukung soft-delete. Data yang dihapus dapat dipulihkan (restore) oleh administrator.

10. **Geographic Data bawaan**
    Data provinsi, kabupaten/kota, dan kecamatan seluruh Indonesia sudah tersedia dan siap digunakan dalam formulir pendaftaran.

---

Sistem Penerimaan Murid Baru (SPMB) ini dirancang untuk memudahkan proses pendaftaran sekolah baik bagi calon siswa maupun panitia (Administrator). Panduan ini dibagi menjadi beberapa bagian sesuai dengan peran pengguna.

---

## BAGIAN A: PANDUAN CALON SISWA

Langkah demi langkah bagi calon siswa untuk melakukan pendaftaran secara mandiri.

### 1. Pembuatan Akun (Registrasi)
1. Buka halaman utama aplikasi dan klik menu **Daftar/Register**.
2. Masukkan **Nama Lengkap**, **Email Aktif**, **Nomor WhatsApp**, dan **Kata Sandi**.
3. *Catatan*: Satu email hanya dapat digunakan untuk satu akun pendaftaran. Pastikan Anda tidak melupakan *password* Anda.
4. Klik tombol **Daftar**. Sistem akan mengirimkan *link* verifikasi ke email yang terdaftar (menggunakan SMTP yang dikonfigurasi administrator).

### 2. Login dan Aktivasi Akun
1. Buka email Anda dan klik *link* verifikasi yang dikirimkan sistem.
2. Setelah akun diaktivasi, masuk (*login*) menggunakan email dan kata sandi.
3. *Catatan*: Jika lupa kata sandi, gunakan fitur **Lupa Password** di halaman login.

### 3. Dashboard Siswa & Pengisian Data Diri
Setelah login, Anda akan masuk ke **Dashboard Siswa** yang menampilkan progres pendaftaran. Lengkapi data secara berurutan:

1. **Identitas Diri** (`/students/profile`): Lengkapi NIK, NPWP, jenis kelamin, tempat/tanggal lahir, kewarganegaraan, agama, dan status penerima KPS.
2. **Alamat Tinggal** (`/students/address`): Isi detail alamat lengkap dengan negara, provinsi, kabupaten/kota, dan kecamatan (menggunakan *cascading select* dari data geografis).
3. **Kontak** (`/students/contact`): Isi nomor telepon, WhatsApp, Telegram, Facebook, Twitter, Instagram, dan TikTok.
4. **Data Ayah** (`/students/parents`): Lengkapi NIK, nama, tempat/tanggal lahir, pendidikan, penghasilan, dan pekerjaan ayah.
5. **Data Ibu** (`/students/parents`): Lengkapi data ibu (struktur sama dengan data ayah).
6. **Data Wali** (`/students/guardian`): Jika ada, lengkapi data wali (opsional).
7. **Asal Sekolah** (`/students/school`): Pilih asal sekolah, NISN, NPSN, alamat sekolah, jurusan (jika ada), dan tahun lulus.

### 4. Pemilihan Program Tujuan
1. Setelah data diri lengkap, masuk ke menu **Pilihan Program Tujuan** (`/students/admissions`).
2. Pilih **Periode** dan **Sekolah/Cabang** untuk melihat program yang tersedia.
3. Pilih program (kombinasi jenjang kelas, program kelas, dan jurusan) yang diinginkan.
4. Sistem akan menampilkan informasi kuota yang tersedia.
5. Jika fitur multi-registrasi diaktifkan, Anda dapat memilih lebih dari satu program (maksimal sesuai ketentuan).
6. *Catatan*: Setelah submit, pilihan program tidak dapat diubah lagi.

### 5. Input Nilai Rapor & Upload Dokumen Persyaratan
1. **Nilai Rapor** (`/students/subject-grade-requirements`): Masukkan nilai mata pelajaran sesuai persyaratan yang telah ditentukan oleh panitia untuk program yang Anda pilih. Sistem akan menampilkan persyaratan umum (per tahun ajaran) dan persyaratan khusus (per program).
2. **Dokumen Persyaratan** (`/students/document-requirements`): Unggah (*upload*) dokumen wajib (Pas Foto, Ijazah, Kartu Keluarga, dll.) dalam format PDF/JPG sesuai ukuran maksimal yang tertera.

### 6. Finalisasi (Submit)
1. Masuk ke halaman **Konfirmasi** (`/students/confirmation`). Periksa kembali seluruh data yang Anda masukkan.
2. Unggah **Bukti Transfer** pembayaran biaya pendaftaran (biaya mengikuti ketentuan periode pendaftaran yang berlaku).
3. Klik **Submit**.
4. *Penting*: Setelah tombol *Submit* ditekan, **data tidak dapat diubah lagi** (terkunci).
5. Unduh (*Download*) halaman PDF **Formulir Pendaftaran** sebagai bukti.

### 7. Pembatalan Pendaftaran
- Jika status masih *draft* (belum *submit*), Anda dapat membatalkan pendaftaran melalui halaman konfirmasi.
- Setelah *submit*, pembatalan hanya dapat dilakukan oleh administrator.

---

## BAGIAN B: PANDUAN ADMINISTRATOR

Panduan bagi panitia/administrator untuk mengelola penerimaan siswa di *Back-Office*.

### 0. Akun Administrator Default
Untuk akses awal ke sistem, gunakan kredensial berikut:
- **Email**: `admin@sekolah.sch.id`
- **Password**: `12345`

*Penting: Segera ubah kata sandi Anda setelah berhasil login pertama kali melalui menu **Profile** di sidebar.*

### 1. Dashboard Administrator
Setelah login, Anda akan masuk ke **Dashboard** (`/administrator/dashboard`) yang menampilkan:
- Ringkasan jumlah pendaftar, pendaftar hari ini, pembayaran pending, dan total offering aktif
- Grafik tren pendaftaran (per bulan)
- program terpopuler
- Statistik real-time

### 2. Konfigurasi Data Master (Wajib)
Sebelum pendaftaran dibuka, Data Master berikut harus dikonfigurasi melalui menu **Master Data**:

**Data Entitas:**
- **Foundation/Yayasan** (`/administrator/foundations`): Data yayasan penyelenggara (jika diperlukan).
- **Cabang/Sekolah** (`/administrator/branches`): Tambahkan unit sekolah (SD, SMP, SMA, SMK, dll.) di bawah yayasan.
- **Tahun Ajaran** (`/administrator/academic-years`): Buat tahun ajaran (contoh: 2025/2026).
- **Jenjang Kelas** (`/administrator/entry-grades`): Tentukan jenjang kelas yang dibuka per sekolah (Kelas 1, Kelas 7, Kelas 10).
- **Program Kelas** (`/administrator/education-tracks`): Tentukan jenis program kelas (Reguler, Unggulan, Internasional, Bilingual, Tahfidz).
- **Jurusan/Program** (`/administrator/education-programs`): Daftarkan program keahlian (IPA, IPS, TKJ, AKL, DKV) per sekolah.
- **Jalur Masuk** (`/administrator/admission-pathways`): Tentukan jalur pendaftaran (Undangan, Prestasi, Ujian Tulis, Reguler).
- **Jenis Pendaftar** (`/administrator/applicant-types`): Tentukan jenis pendaftar (Siswa Baru, Pindahan).
- **Mata Pelajaran** (`/administrator/subjects`): Buat referensi mata pelajaran untuk nilai rapor.
- **Referensi Dokumen** (`/administrator/documents`): Buat referensi dokumen persyaratan.

**Data Geografis:**
- **Provinsi** (`/administrator/provinces`): sudah tersedia (34 provinsi).
- **Kabupaten/Kota** (`/administrator/districts`): sudah tersedia.
- **Kecamatan** (`/administrator/subdistricts`): sudah tersedia.

### 3. Periode & Gelombang Pendaftaran
Masuk ke menu **Periode Pendaftaran** (`/administrator/admission-periods`):
1. Buat periode baru dengan memilih tahun ajaran, nama gelombang, kode, dan tanggal buka/tutup pendaftaran.
2. Tentukan **Biaya Pendaftaran** (`registration_fee`) — biaya ini bersifat global untuk semua program dalam periode tersebut.
3. Tanggal pengumuman kelulusan juga dapat ditentukan di sini.

### 4. Pengaturan Penerimaan (Admission Offerings)
Setiap kombinasi sekolah, jenjang, program kelas, dan jurusan yang dibuka pada suatu periode *wajib* dikonfigurasi:
1. Masuk ke menu **Pembukaan Pendaftaran** (`/administrator/admission-offerings`).
2. Buat *offering* baru dengan memilih Periode, Cabang, Jenjang Kelas, Program Kelas, Jurusan (jika ada), dan Jenis Pendaftar.
3. Tentukan **Kuota** dan **Urutan Tampilan**.
4. Biaya pendaftaran diambil secara global dari periode yang dipilih — tidak dapat diatur per offering.

### 5. Persyaratan Umum (General Requirements)
Diatur per tahun ajaran melalui menu **Persyaratan Umum**:
- **Persyaratan Umum Nilai Rapor** (`/administrator/general-subject-grade-requirements/{academic_year_id}`): Tentukan mata pelajaran dan nilai minimum yang berlaku untuk **seluruh** program pada tahun ajaran tersebut.
- **Persyaratan Umum Ujian Saringan** (`/administrator/general-entrance-exam-scores/{academic_year_id}`): Tentukan mata ujian dan skor minimum yang berlaku umum.
- **Persyaratan Umum Dokumen** (`/administrator/general-document-requirements/{academic_year_id}`): Tentukan dokumen wajib yang berlaku umum.

### 6. Persyaratan Khusus (Specific Requirements)
Diatur per *admission offering* melalui sub-menu di halaman **Pembukaan Pendaftaran**:
- **Persyaratan Khusus Nilai Rapor**: Tambahkan mata pelajaran tambahan khusus untuk program tertentu (contoh: Fisika untuk Teknik).
- **Persyaratan Khusus Ujian Saringan**: Tambahkan mata ujian khusus (contoh: Tes Gambar untuk DKV).
- **Persyaratan Khusus Dokumen**: Tambahkan dokumen khusus (contoh: Surat Keterangan Buta Warna).

Sistem akan secara otomatis **mengombinasikan** Persyaratan Umum + Persyaratan Khusus saat ditampilkan ke pendaftar.

### 7. Manajemen Pendaftar
1. **Daftar Pendaftar** (`/administrator/registrants`): Menampilkan semua calon siswa yang telah mendaftar. Data dapat difilter berdasarkan tahun akademik, status seleksi, sekolah, jenjang, program, dan jalur masuk.
2. **Verifikasi Pembayaran**: Operator wajib memverifikasi *upload* bukti transfer pendaftar untuk mengubah status pembayaran.
3. **Input & Verifikasi Nilai**: Panitia dapat menginput dan memperbarui nilai rapor serta nilai ujian saringan masuk per pendaftar.
4. **Cetak Formulir**: Cetak Formulir Pendaftaran PDF secara individual sebagai arsip. Formulir diformat dengan kop resmi dan tata letak siap cetak.
5. **Download Dokumen**: Unduh dokumen persyaratan yang telah diupload pendaftar.

### 8. Manajemen Siswa
- **Daftar Siswa** (`/administrator/students/{offering_id}`): Kelola siswa per *offering* penerimaan. Fungsionalitas serupa dengan manajemen pendaftar, dikhususkan untuk siswa yang telah diterima/didaftarkan.
- Status seleksi pendaftar dapat diubah: 0 (Belum Lengkap), 1 (Ditinjau), 2 (Terverifikasi), 3 (Seleksi), 4 (Lulus), 5 (Cadangan), 6 (Tidak Lulus), 7 (Daftar Ulang).

### 9. Manajemen Akun Operator
- **Operator** (`/administrator/operators`): Buat, ubah, dan nonaktifkan akun staf penerimaan (hanya untuk Super Admin). Operator memiliki akses terbatas untuk mengelola data pendaftar tanpa akses ke pengaturan sistem.
- **Profile** (`/administrator/profile`): Admin dan Operator dapat memperbarui data diri dan mengganti kata sandi masing-masing.

### 10. Pengaturan Aplikasi
Masuk ke menu **Pengaturan Aplikasi** (`/administrator/application-settings`):
- **Profil Institusi**: Nama lembaga, alamat, telepon, email, logo, dan favicon.
- **Pembayaran**: Upload informasi/instruksi pembayaran.
- **Ketentuan Pendaftaran**: Upload file syarat dan ketentuan pendaftaran.
- **SMTP**: Konfigurasi server email untuk pengiriman notifikasi (verifikasi akun, reset password).
- **Keamanan (Cloudflare Turnstile)**: Masukkan **Site Key** dan **Secret Key** untuk mengaktifkan perlindungan bot pada formulir registrasi.
- **Multi-Registrasi**: Aktifkan/nonaktifkan fitur pendaftaran ke beberapa program sekaligus, dan tentukan jumlah maksimal pendaftaran.
- **Zona Waktu**: Atur zona waktu sistem.

### 11. Laporan & Statistik Pendaftaran
Menu **Laporan Statistik Pendaftaran** (`/administrator/admission-statistic-report`) menyediakan:
- Grafik pendaftar per sekolah/cabang (pie chart)
- Grafik pendaftar per status kelulusan
- Grafik pendaftar per jenjang kelas/jurusan
- Grafik pendaftar per program kelas
- Grafik pendaftar per jalur masuk
- Grafik pendaftar per jenis pendaftar
- Grafik pendaftar per asal sekolah
- Grafik pendaftar per provinsi asal
- Grafik tren pendaftaran per bulan
- Grafik pendaftar per jenis kelamin
- Grafik pendaftar per golongan penghasilan orang tua

### 12. Mengaktifkan Cloudflare Turnstile (Pelindung Anti-Spam & Bot)

Sistem Penerimaan Murid Baru ini dilengkapi dengan dukungan **Cloudflare Turnstile** untuk melindungi formulir pendaftaran dari serangan *Bot*, *Spam*, dan *Email Bombing* tanpa membebani calon siswa dengan *captcha* yang mengganggu.

#### A. Mendapatkan Key dari Cloudflare
1. Kunjungi [Cloudflare Turnstile](https://dash.cloudflare.com/?to=/:account/turnstile).
2. Jika belum punya akun, daftar terlebih dahulu (gratis).
3. Klik **"Add site"**.
4. Isi detail:
   - **Site name**: Contoh: `SPMB`
   - **Domain**: Domain aplikasi Anda, contoh: `spmb.sekolahku.web.id`
   - **Widget Mode**: Pilih **"Managed"** atau **"Invisible"**.
5. Klik **Create**. Salin **Site Key** dan **Secret Key**.

#### B. Integrasikan Key ke Aplikasi
1. Login ke sistem sebagai Administrator.
2. Buka **Pengaturan Aplikasi** (`/administrator/application-settings`).
3. Pada bagian **Cloudflare Turnstile**, masukkan Site Key dan Secret Key.
4. Klik **Simpan Konfigurasi**.

**Selesai!** Formulir registrasi kini terlindungi. Untuk menonaktifkannya, kosongkan kedua kolom dan simpan.

---

## BAGIAN C: PERINTAH CLI (COMMAND LINE)

Sistem menyediakan beberapa perintah *Command Line Interface* melalui `php spark` untuk administrasi teknis:

| Perintah | Deskripsi |
|---|---|
| `php spark dummy/set_super_admin` | Membuat akun administrator default (admin@sekolah.sch.id / 12345) |
| `php spark dummy/set_master_data` | Mengisi data master contoh (cabang, tahun ajaran, periode, jurusan, dll.) |
| `php spark dummy/set_students` | Mengisi data siswa dan registrasi palsu untuk pengujian |
| `php spark dummy/set_settings` | Mengisi pengaturan aplikasi default |

---

## BAGIAN D: MANAJEMEN DATABASE

### Membuat Database Baru
```bash
mysql -u root -p
CREATE DATABASE spmb CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'spmb_user'@'localhost' IDENTIFIED BY 'password_kuat';
GRANT ALL PRIVILEGES ON spmb.* TO 'spmb_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Membuat Tabel
Jalankan file `database_mysql_schema.sql` yang tersedia di direktori utama aplikasi:
```bash
mysql -u spmb_user -p spmb < database_mysql_schema.sql
```

### Struktur Tabel Data
Database menggunakan skema relasional MySQL InnoDB dengan soft-delete pattern:

```sql
CREATE TABLE `branches` (
    `id`              BIGINT UNSIGNED AUTO_INCREMENT,
    `unique_id`       VARCHAR(120),
    `foundation_id`   BIGINT UNSIGNED DEFAULT 0,
    `code`            VARCHAR(50),
    `name`            VARCHAR(255) NOT NULL,
    `education_level` VARCHAR(20),
    `address`         TEXT,
    `phone`           VARCHAR(50),
    `email`           VARCHAR(255),
    `is_deleted`      TINYINT(1) DEFAULT 0,
    `created_at`      DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at`      DATETIME,
    `created_by`      BIGINT UNSIGNED DEFAULT 0,
    `updated_by`      BIGINT UNSIGNED DEFAULT 0,
    `deleted_by`      BIGINT UNSIGNED DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_unique_id` (`unique_id`),
    KEY               `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Semua tabel data master mengikuti pola struktur di atas (id, unique_id, is_deleted, timestamp, dan audit columns). Tidak ada tabel `_log_` — audit dilakukan melalui soft-delete dan kolom *by/*_at/*_by.

### Daftar Tabel Lengkap

| Grup | Tabel |
|------|-------|
| **Master Data** | `foundations`, `branches`, `academic_years`, `entry_grades`, `education_tracks`, `education_programs`, `subjects`, `admission_documents`, `admission_pathways`, `applicant_types`, `previous_schools` |
| **Periode & Offering** | `admission_periods`, `admission_offerings` |
| **Persyaratan Umum** | `general_document_requirements`, `general_subject_grade_requirements`, `general_entrance_exam_scores` |
| **Persyaratan Khusus** | `offering_document_requirements`, `offering_subject_grade_requirements`, `offering_entrance_exam_scores` |
| **Core** | `users`, `registrations`, `registration_subject_grades`, `registration_documents`, `registration_exam_scores` |
| **Sistem** | `application_settings`, `sessions`, `login_attempts` |
| **Geografis** | `provinces`, `districts`, `subdistricts` |

---

## ARSITEKTUR DATA

### Hierarki Master Data
```
Yayasan (Foundation)
└── Sekolah / Cabang (School/Branch)
    ├── Jenjang Kelas (Entry Grade) — Kelas 1, 7, 10
    ├── Program Kelas (Education Track) — Reguler, Unggulan, Internasional
    └── Jurusan (Education Program) — IPA, IPS, TKJ, AKL (opsional, khusus SMA/SMK)

Tahun Ajaran (Academic Year)
└── Periode Pendaftaran (Admission Period) — memiliki biaya pendaftaran global
    └── Offering Pendaftaran (Admission Offering)
        ├── Merujuk pada sekolah, jenjang, program kelas, jurusan, jalur, jenis pendaftar
        ├── Memiliki kuota dan urutan tampilan
        └── Memiliki persyaratan khusus (nilai, ujian, dokumen)
```

### Alur Pendaftaran
```
1. Admin Setup → Data Master → Periode → Offering → Persyaratan
2. Siswa Registrasi → Verifikasi Email → Login → Isi Data Diri
3. Siswa Pilih Program → Input Nilai → Upload Dokumen → Submit
4. Admin Verifikasi → Verifikasi Pembayaran → Input Nilai Ujian → Kelola Status Seleksi
5. Laporan → Statistik & Grafik Real-time
```

---

## FITUR KEAMANAN

| Fitur | Detail |
|---|---|
| **Rate Limiting** | 60 permintaan per 60 detik pada endpoint autentikasi (ThrottleFilter) |
| **Cloudflare Turnstile** | Proteksi bot tak kasat mata pada formulir registrasi (opsional) |
| **Password Policy** | Minimal 8 karakter, maksimal 4096 byte, kombinasi huruf besar/kecil/angka/simbol |
| **Bcrypt Hashing** | *Cost factor* 12 untuk hashing kata sandi |
| **Reset Token Aman** | Token reset password di-hash dengan bcrypt sebelum disimpan di database |
| **Remember Me** | Token *(selector:validator)* dengan bcrypt, cookie httpOnly + sameSite=Lax |
| **Session Security** | Regenerasi session ID setelah login, penyimpanan session di database |
| **Soft Delete** | Semua data mendukung penghapusan lunak (dapat dipulihkan) |
| **XSS Protection** | Encoding JSON dengan flag HEX_TAG, HEX_APOS, HEX_AMP, HEX_QUOT |
| **SQL Injection Prevention** | Query Builder dan parameterized queries di semua operasi database |
| **File Upload Security** | Validasi MIME type, `basename()` untuk cegah path traversal, random filename |
| **CSRF Protection** | Diaktifkan pada semua formulir publik (login, register, lupa password) |

---

*Dibuat untuk ekosistem Manajemen Sekolah Modern menggunakan CodeIgniter 4 dan MySQL InnoDB.*
