# SPMB — Sistem Penerimaan Murid Baru

> **Platform PPDB Online Modern untuk Yayasan & Sekolah Multi-Level**
>
> Version 1.0.0 | Framework: CodeIgniter 4 | PHP ^8.5 | PostgreSQL 15

---

## Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Keunggulan Teknis](#keunggulan-teknis)
  - [1. Teknologi Modern & Aman](#1-teknologi-modern--aman)
  - [2. Keamanan Berlapis](#2-keamanan-berlapis)
  - [3. Arsitektur Super Fleksibel](#3-arsitektur-super-fleksibel)
  - [4. Fitur Lengkap Siap Pakai](#4-fitur-lengkap-siap-pakai)
  - [5. Tanpa Build Tool — Ringan & Cepat](#5-tanpa-build-tool--ringan--cepat)
  - [6. Siap Production](#6-siap-production)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Kesiapan Deploy](#kesiapan-deploy)

---

## Fitur Utama

### Manajemen Sekolah Multi-Level
Dukung satu yayasan dengan banyak sekolah dari berbagai jenjang dalam satu sistem:

| Jenjang | Dukungan |
|---------|----------|
| TK / RA | ✅ |
| SD / MI | ✅ |
| SMP / MTs | ✅ |
| SMA / MA | ✅ |
| SMK | ✅ |

### Pendaftaran Online Multi-Step
Formulir pendaftaran bertahap dengan progress bar:

1. Data Pribadi
2. Alamat
3. Data Orang Tua
4. Data Wali
5. Asal Sekolah
6. Upload Dokumen
7. Input Nilai Rapor
8. Pilihan Program
9. Konfirmasi & Cetak PDF

### Manajemen Administrasi
| Modul | Deskripsi |
|-------|-----------|
| Tahun Ajaran | Kelola tahun ajaran, tanggal mulai/selesai |
| Gelombang Pendaftaran | Periode dengan batas waktu & jadwal pengumuman |
| Jalur Masuk | Undangan, Ujian Tulis, Pindahan, dll. |
| Jenjang & Kelas | Kelas 1, 7, 10 — disesuaikan per sekolah |
| Program/Jurusan | IPA/IPS (SMA), Program Keahlian (SMK), Peminatan (MA) |
| Jalur Kelas | Reguler, Internasional, Bilingual, Tahfidz, Unggulan |
| Penawaran | Kombinasi sekolah + kelas + jalur + program + kuota + biaya |
| Persyaratan | Umum sistem + spesifik per penawaran (nilai, dokumen, skor) |

### Dashboard & Laporan
- Statistik real-time jumlah pendaftar
- Grafik tren pendaftaran (Chart.js)
- Program studi paling populer
- Pendaftar hari ini
- Laporan statistik penerimaan dengan filter
- Export data peserta didik diterima

### Pembayaran
- Upload bukti transfer
- Workflow verifikasi pembayaran
- Status pembayaran terintegrasi

### Keamanan & Otentikasi
- 3 level peran: **Admin**, **Operator**, **Siswa**
- Registrasi dengan verifikasi email
- Login dengan proteksi brute-force
- Fitur "Remember Me" token-based
- Reset password via email
- Cloudflare Turnstile anti-bot

### Database & Audit
- **Audit trail otomatis** — semua perubahan data tercatat
- **Soft delete** — data tidak pernah hilang
- **Log tabel** — riwayat perubahan per baris data

---

## Keunggulan Teknis

### 1. Teknologi Modern & Aman

| Aspek | Detail |
|-------|--------|
| **PHP** | `^8.5` — performa tinggi, type safety, fitur bahasa terkini |
| **Database** | **PostgreSQL 15** — reliability & fitur enterprise-grade |
| **Framework** | CodeIgniter 4 v4.7.3 — ringan, cepat, ekosistem luas |
| **Container** | Docker + docker-compose siap pakai |

> **Mengapa PostgreSQL?** Sistem dibangun di atas PostgreSQL dengan JSONB — memberikan fleksibilitas database NoSQL dalam relational engine. Data bisa berubah bentuk tanpa migrasi, tanpa downtime.

### 2. Keamanan Berlapis

```
┌─────────────────────────────────────────┐
│  Cloudflare Turnstile (anti-bot)        │
├─────────────────────────────────────────┤
│  Rate Limiting (ThrottleFilter)         │
│   → 3 request/menit per route auth      │
├─────────────────────────────────────────┤
│  Brute-Force Protection                 │
│   → 5 gagal login = lockout 15 menit    │
├─────────────────────────────────────────┤
│  CSRF Protection                        │
│   → Cookie-based token randomization    │
├─────────────────────────────────────────┤
│  Bcrypt Cost Factor 12                  │
│   → Hashing password level enterprise   │
├─────────────────────────────────────────┤
│  Force HTTPS Global                     │
├─────────────────────────────────────────┤
│  Session Fixation Prevention            │
└─────────────────────────────────────────┘
```

### 3. Arsitektur Super Fleksibel

**JSONB-First Architecture**

Tidak seperti sistem PPDB lain yang kaku dengan kolom tetap, SPMB menggunakan **JSONB** sebagai penyimpan utama data bisnis. Artinya:

- ✅ **Tambah field baru** — tanpa migrasi database, cukup tambah di kode
- ✅ **Zero downtime** — tidak perlu `ALTER TABLE` yang mengunci produksi
- ✅ **Multi-level dalam satu sistem** — data TK berbeda dengan SMK, semua ditampung JSONB
- ✅ **GIN Index** — query JSONB tetap cepat meski data membesar
- ✅ **Polymorphic entities** — 1 tabel `entities` untuk semua master data (sekolah, tahun ajaran, program, jalur kelas)

**Setiap tabel memiliki skema seragam:**
```
id (BIGSERIAL) | unique_id (VARCHAR) | data (JSONB)
created_at | updated_at | deleted_at | restored_at | modified_at
created_by | updated_by | deleted_by | restored_by
is_deleted (BOOLEAN)
```

Ditambah **trigger PostgreSQL** `timestamp_changer()` yang secara otomatis memperbarui `modified_at` setiap ada perubahan — tanpa perlu kode aplikasi.

### 4. Fitur Lengkap Siap Pakai

| Kebutuhan | Status |
|-----------|--------|
| Pendaftaran online multi-step | ✅ |
| Manajemen gelombang & kuota | ✅ |
| Upload dokumen (PDF/JPG) | ✅ |
| Input nilai rapor | ✅ |
| Cetak formulir PDF (TCPDF) | ✅ |
| Dashboard admin real-time | ✅ |
| Role-based access control | ✅ |
| Multi-sekolah 1 instalasi | ✅ |
| Laporan statistik | ✅ |
| Manajemen peserta diterima | ✅ |
| Verifikasi pembayaran | ✅ |
| Data geografis (provinsi/kab/kec) | ✅ |
| Pengaturan aplikasi (SMTP, logo, dll) | ✅ |

### 5. Tanpa Build Tool — Ringan & Cepat

> **Zero frontend build pipeline.** Tidak perlu Webpack, Vite, Gulp, atau Node.js di production.

| Teknologi | Peruntukan |
|-----------|-----------|
| **CoreUI** (Bootstrap 5) | Admin dashboard — responsif, profesional, siap mobile |
| **Tailwind CSS** (CDN) | Landing page publik — modern, ringan |
| **Alpine.js** (CDN) | Interaktivitas SPA-like tanpa framework berat |
| **Chart.js** (CDN) | Grafik dashboard real-time |
| **Tom Select** (CDN) | Komponen autocomplete/select canggih |
| **TCPDF** | Generate PDF formulir pendaftaran |

**Dampak untuk operasional:**
- 🚀 **Muat halaman cepat** — tanpa bundle JS besar
- 🔧 **Mudah dikustomisasi** — cukup edit CSS/JS langsung
- ☁️ **Deploy di mana saja** — shared hosting pun bisa

### 6. Siap Production

**Infrastruktur:**
- Dockerfile (`php:8.5-apache`) + docker-compose (`PostgreSQL 15 Alpine`)
- Database session — aman untuk horizontal scaling
- Logger bawaan (file-based)
- SMTP terintegrasi untuk email transaksional

**Pengaturan aplikasi via admin panel:**
- Nama & alamat institusi
- Logo & favicon
- Konfigurasi SMTP
- Cloudflare Turnstile keys
- Password default admin: `admin@university.ac.id`

---

## Arsitektur Sistem

```
┌───────────────────────────────────────────────────────────┐
│                    PUBLIC (Alpine.js)                      │
│  Landing Page | Registrasi | Login | Forgot Password      │
└────────────────────────┬──────────────────────────────────┘
                         │
┌────────────────────────▼──────────────────────────────────┐
│              CODEIGNITER 4 (PHP ^8.5)                      │
│                                                           │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ Controllers  │  │   Filters    │  │   Libraries      │ │
│  │  - Admin (28)│  │  - AuthFilter│  │  - Auth          │ │
│  │  - Public (9)│  │  - Throttle  │  │  - Remember      │ │
│  │  - Student(12)│ │               │  │  - PDF (TCPDF)   │ │
│  └──────┬───────┘  └──────────────┘  └──────────────────┘ │
│         │                                                   │
│  ┌──────▼───────┐  ┌──────────────┐                       │
│  │   Models     │  │   Services   │                       │
│  │  - BaseModel │  │  PasswordSvc │                       │
│  │  - QBase     │  └──────────────┘                       │
│  │  - QBaseUnique│                                         │
│  └──────┬───────┘                                         │
└─────────┼─────────────────────────────────────────────────┘
          │
┌─────────▼─────────────────────────────────────────────────┐
│              POSTGRESQL 15 (JSONB)                         │
│                                                           │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │  users       │  │  registrations│  │  entities        │ │
│  │  (auth/data) │  │  (pendaftaran)│  │  (polymorphic)  │ │
│  ├─────────────┤  ├──────────────┤  ├──────────────────┤ │
│  │  settings    │  │  sessions     │  │  login_attempts  │ │
│  │  (config)    │  │  (db session) │  │  (security)     │ │
│  └─────────────┘  └──────────────┘  └──────────────────┘ │
│                                                           │
│  ┌──────────────────────────────────────────────────────┐ │
│  │  _log_<table> — Audit Trail (trigger-based)          │ │
│  └──────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────┘
```

---

## Kesiapan Deploy

### Persyaratan Minimum
| Komponen | Spesifikasi |
|----------|-------------|
| PHP | 8.5+ |
| Database | PostgreSQL 15 |
| Web Server | Apache (dengan mod_rewrite) |
| RAM | 512 MB (minimum) |
| Storage | 1 GB + kapasitas upload |

### Deploy dengan Docker (Rekomendasi)
```bash
git clone <repository>
cd spmb.rector.id
cp env.docker .env
# edit .env sesuai konfigurasi
docker compose up -d
```

### Deploy Manual
```bash
composer install --no-dev
# Konfigurasi .env, database, dan web server
```

---

> **SPMB** — Solusi PPDB Online Modern, Aman, dan Fleksibel untuk Yayasan Pendidikan Indonesia.
>
> Dibangun dengan ❤️ menggunakan CodeIgniter 4 + PostgreSQL.
