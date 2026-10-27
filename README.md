# Studi Ablasi RNN, LSTM, GRU vs ANN untuk Prediksi Trafik Seluler Milan

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/dapaaap/milan-traffic-ablation-01/blob/main/tugas_ablasi.ipynb)

Tugas Workshop Deep Learning — Program Studi Teknik Telekomunikasi, Institut Teknologi Sumatera (ITERA).

---

## Ringkasan Proyek

Proyek ini bertujuan untuk mengevaluasi dan membandingkan kinerja model jaringan saraf berulang (*Recurrent Neural Networks*): **Simple RNN**, **LSTM** (*Long Short-Term Memory*), dan **GRU** (*Gated Recurrent Unit*) terhadap model dasar **ANN** (*Artificial Neural Network*) dalam memprediksi deret waktu aktivitas internet seluler per jam di Kota Milan menggunakan dataset *Telecom Italia Big Data Challenge*.

Melalui pendekatan **studi ablasi terkontrol** (*controlled ablation study*), eksperimen dilakukan secara sistematis dengan mengubah satu faktor/hyperparameter dalam satu waktu dari konfigurasi acuan (*baseline*). Evaluasi performa divalidasi menggunakan rata-rata 3 random seed untuk memastikan keandalan statistik. Rangkaian pengujian terbagi menjadi:

- **Bagian 0 — Konfigurasi Acuan & Baseline Naif:** Evaluasi model acuan terhadap pembanding naif (*last value*, *yesterday*, *last week*).
- **Bagian A — Ablasi 5 Faktor Utama:** Analisis dampak panjang jendela observasi $W$ (6–168 jam), kapasitas unit tersembunyi (*hidden units* 16–128), kedalaman layer (1–3 lapis), *learning rate* ($10^{-4}$–$10^{-2}$), dan variasi kelompok fitur (*net*, *call*, *sms*, serta fitur periodisitas waktu).
- **Bagian B — Ablasi Faktor Tambahan:** Eksplorasi faktor lanjutan pilihan kelompok (misal: *batch size*, *dropout*, *optimizer*, fungsi *loss*, *patience early stopping*, *horizon*, atau *gradient clipping*).
- **Bagian C — Konfigurasi Terbaik:** Mengintegrasikan kombinasi hyperparameter optimal berdasarkan metrik rata-rata **val MAE** untuk masing-masing model, lalu diuji pada minggu pengujian (*test*) dan periode anomali libur Natal.
- **Bagian D — Uji Generalisasi:** Menguji ketahanan transfer dan adaptabilitas konfigurasi acuan dan konfigurasi terbaik pada lokasi kelompok: **Navigli (Darsena), Kotak 4555 (Kode Lokasi: 1)**.

---

## Kelompok

| Peran | Nama | NIM |
|---|---|---|
| Ketua | Adif Dafa Raihan | 124400055 |
| Anggota | Cindy Auliya | 124400045 |
| Anggota | Bima Cahya Ramadhan | 124400001 |

- **Kelas:** RA
- **Lokasi Kelompok:** Kode 1 — Navigli (Darsena), Kotak 4555 (digit terakhir NIM terkecil: 1)
- **Laporan:** [`laporan-latex/main.pdf`](laporan-latex/) atau [`laporan-typst/main.pdf`](laporan-typst/)

---

## Cara Menjalankan

Eksperimen dapat direproduksi baik secara lokal menggunakan environment manager `uv` maupun di Google Colab.

### Opsi 1: Menjalankan Secara Lokal (Menggunakan `uv`)

1. **Clone repositori:**
   ```bash
   git clone https://github.com/dapaaap/milan-traffic-ablation-01.git
   cd milan-traffic-ablation-01
   ```

2. **Sinkronisasi dependensi:**
   Pastikan package manager `uv` telah terpasang di sistem ([panduan instalasi uv](https://github.com/astral-sh/uv)). Jalankan perintah:
   ```bash
   uv sync
   ```
   Perintah ini akan membuat virtual environment `.venv` dan memasang seluruh pustaka yang diperlukan (PyTorch, pandas, numpy, matplotlib, jupyterlab, ipykernel) secara konsisten sesuai `pyproject.toml` dan `uv.lock`.

3. **Jalankan Jupyter Lab / Notebook:**
   ```bash
   uv run jupyter lab
   # atau: uv run jupyter notebook
   ```

4. **Eksekusi Eksperimen:**
   - Buka notebook `tugas_ablasi.ipynb`.
   - Pastikan variabel `LOKASI_KELOMPOK = 1` sudah terisi sesuai kode lokasi Navigli (kotak 4555).
   - Jalankan sel secara berurutan. Seluruh catatan training dan metrik akan otomatis tersimpan di `hasil/ablasi.csv`.

---

### Opsi 2: Menjalankan di Google Colab

1. **Buka Notebook di Colab:**
   Klik badge [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/dapaaap/milan-traffic-ablation-01/blob/main/tugas_ablasi.ipynb) atau buka [Google Colab](https://colab.research.google.com/) dan impor repository `dapaaap/milan-traffic-ablation-01`.

2. **Clone Dataset & Setup Direktori:**
   Di sel pertama notebook atau terminal Colab, jalankan perintah berikut untuk memuat folder `data/` dan struktur direktori proyek:
   ```python
   !git clone https://github.com/dapaaap/milan-traffic-ablation-01.git
   %cd milan-traffic-ablation-01
   ```

3. **Pilih Akselerator Hardware (GPU):**
   Masuk ke menu **Runtime** > **Change runtime type**, lalu pilih **T4 GPU** (opsional namun disarankan untuk mempercepat training) atau CPU.

4. **Jalankan Notebook:**
   - Periksa sel konfigurasi awal (`LOKASI_KELOMPOK = 1`).
   - Eksekusi semua sel (**Runtime** > **Run all**).
   - Semua artefak, grafik per faktor, dan log performa akan otomatis disimpan di folder `hasil/`.

---

## Ringkasan Hasil

Seluruh eksperimen dijalankan dengan PyTorch 2.14.1 pada CPU. Terdapat 348 catatan run, yang berasal dari 270 pelatihan unik karena beberapa konfigurasi acuan dipakai ulang di bagian lain.

- **Perangkat yang dipakai:** CPU (PyTorch 2.14.1+cpu)
- **Total waktu pelatihan:** ±92,6 menit untuk 270 pelatihan unik (348 catatan run)

Konfigurasi terbaik dipilih hanya berdasarkan val MAE, lalu diuji pada minggu test dan periode Natal di Duomo. Tabel berikut membandingkan konfigurasi acuan dan terbaik (rata-rata ± simpangan baku, 3 seed).

| Model | Konfigurasi | Val MAE (mean ± std) | Test MAE (mean ± std) | Test MAPE (%) | Natal MAE |
|---|---|---|---|---|---|
| ANN | Acuan | 248,9 ± 8,9 | 309,9 ± 5,9 | 11,3 ± 0,8 | 680,1 ± 52,0 |
| ANN | **Terbaik** | 230,1 ± 14,8 | **288,1 ± 15,6** | 9,6 ± 0,6 | 617,7 ± 36,0 |
| RNN | Acuan | 206,1 ± 7,4 | 229,6 ± 5,1 | 8,5 ± 0,3 | 421,2 ± 2,4 |
| RNN | **Terbaik** | 200,1 ± 5,3 | **224,5 ± 11,7** | 8,2 ± 0,8 | 404,5 ± 9,9 |
| LSTM | Acuan | 230,5 ± 12,2 | 273,6 ± 25,4 | 9,1 ± 1,0 | 586,0 ± 56,8 |
| LSTM | **Terbaik** | 221,3 ± 6,9 | **225,3 ± 4,0** | 7,3 ± 0,7 | 454,5 ± 36,4 |
| GRU | Acuan | 207,5 ± 3,8 | **237,2 ± 9,3** | 8,0 ± 0,7 | **468,2 ± 21,8** |
| GRU | Terbaik | 203,6 ± 7,3 | 239,7 ± 9,9 | 7,9 ± 0,4 | 497,6 ± 16,8 |

Test MAE terendah di Duomo dicapai oleh RNN terbaik (224,5 ± 11,7). Konfigurasi terbaik GRU memiliki val MAE lebih rendah (203,6 vs 207,5) tetapi test dan Natal MAE lebih buruk dari acuan, indikasi overfitting. Pada uji generalisasi di Navigli, ANN terbaik menjadi model paling akurat dengan test MAE 191,1 ± 1,9.

---

## Struktur Direktori

```
dlw-tugas/
├── data/
│   ├── milano_duomo_5060.csv           # Data trafik per jam area Duomo (kotak 5060)
│   └── milano_tugas_10_lokasi.csv      # Data 10 lokasi tugas (termasuk Navigli kotak 4555)
├── hasil/                              # CSV seluruh run (ablasi.csv), tabel ringkasan, grafik (dihasilkan otomatis)
├── laporan-latex/                      # Sumber template laporan IEEE (LaTeX) + PDF
├── laporan-typst/                      # Sumber template laporan IEEE (Typst) + PDF
├── tugas_ablasi.ipynb                  # Notebook utama eksperimen ablasi
├── pyproject.toml                      # Definisi paket dan dependensi proyek
├── uv.lock                             # Lockfile dependensi uv
└── README.md                           # Dokumentasi proyek
```

---

## Data

Dataset berasal dari **Telecom Italia Big Data Challenge** (Barlacchi dkk., 2015, *Scientific Data*, lisensi ODbL), dengan agregasi per jam dari Zhang dkk. (INFOCOM 2021). Dataset disiapkan oleh pengajar workshop di repositori [mctosima/dl-workshop](https://github.com/mctosima/dl-workshop).
