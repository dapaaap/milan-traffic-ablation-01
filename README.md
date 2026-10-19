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

*Catatan: Ringkasan angka dan temuan final akan diperbarui setelah seluruh iterasi eksperimen selesai dijalankan.*

- **Perangkat yang dipakai:** [Akan diisi setelah pelatihan, contoh: Laptop CPU Intel i5 / Google Colab T4 GPU]
- **Total waktu pelatihan:** [x] menit

| Model | Konfigurasi | Val MAE (mean ± std) | Test MAE (mean ± std) | Test MAPE (%) | Natal MAE |
|---|---|---|---|---|---|
| ANN | Acuan / Terbaik | - | - | - | - |
| RNN | Acuan / Terbaik | - | - | - | - |
| LSTM | Acuan / Terbaik | - | - | - | - |
| GRU | Acuan / Terbaik | - | - | - | - |

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
