# Hipotesis Eksperimen Bagian B — Ablasi Tambahan

**Workshop Deep Learning — Program Studi Teknik Telekomunikasi, Institut Teknologi Sumatera (ITERA)**

- **Kelompok:**
  - Adif Dafa Raihan (NIM: 124400055) — *Ketua*
  - Cindy Auliya (NIM: 124400045) — *Anggota*
  - Bima Cahya Ramadhan (NIM: 124400001) — *Anggota*
- **Kelas:** RA
- **Lokasi Kelompok:** Kode 1 — Navigli (Darsena), Kotak 4555

---

## 1. Pemilihan Faktor Bagian B

Sesuai panduan studi ablasi, kelompok kami memilih 2 faktor tambahan lanjutan pada **Bagian B** untuk dianalisis secara sistematis pada 4 model (ANN, Simple RNN, LSTM, GRU) dengan 3 random seed:
1. **Faktor B2: `dropout`** $\in \{0.0, 0.2, 0.5\}$
2. **Faktor B6: `horizon`** $\in \{1, 6, 24\}$ (jam)

Kedua faktor ini dipilih sebelum eksekusi pelatihan dijalankan untuk menguji dua dimensi krusial pemodelan deret waktu: **regularisasi terhadap overfitting pada dataset terbatas** dan **kemampuan prediksi multi-langkah (*multi-step forecasting*)**.

---

## 2. Rincian Faktor & Hipotesis Awal

### Faktor 1: `dropout` (Kode: B2)
- **Konfigurasi yang diuji:** `dropout` $\in \{0.0, 0.2, 0.5\}$
- **Konfigurasi tetap (Acuan):** `W=24`, `horizon=1`, `fitur="semua"`, `lr=0.001`, `batch=64`, `optimizer="adam"`, `loss="mse"`, `patience=30`, `max_epochs=300`.
- **Pertanyaan Pemandu:** Apakah regularisasi membantu pada dataset berukuran kecil? Bagaimana dampaknya terhadap generalisasi test dan anomali Natal?

#### Hipotesis:
> **Pemberian dropout moderat ($p = 0.2$) akan meningkatkan performa generalisasi (menurunkan test MAE dan val MAE) dibandingkan tanpa dropout ($p = 0.0$). Sebaliknya, dropout yang terlalu besar ($p = 0.5$) diprediksi akan menyebabkan *underfitting* sehingga meningkatkan error prediksi.**

#### Alasan & Landasan Teoretis:
1. **Ukuran Data Latih Terbatas:** Periode data latih hanya mencakup 4 minggu (11 November – 9 Desember 2013), yang setara dengan 672 jam atau sekitar 648 jendela observasi ($W=24$). Ukuran sampel ini tergolong kecil untuk model deep learning dengan ribuan parameter.
2. **Kecenderungan Overfitting pada Model Dalam:** Hasil ablasi A3 memperlihatkan bahwa model dengan kapasitas lebih besar cenderung mengalami early stopping lebih cepat akibat overfitting pada data latih. Tanpa regularisasi ($p = 0.0$), neuron-neuron rentan mengalami ko-adaptasi kompleks (*complex co-adaptations*) yang hanya menghafal fluktuasi noise acak pada data latih.
3. **Mekanisme Regularisasi Stokastik:** Dropout $p = 0.2$ mematikan 20% unit secara acak selama training, memaksa jaringan mempelajari representasi fitur yang terdistribusi dan redundan (tidak bergantung pada neuron tertentu). Namun jika $p = 0.5$, kapasitas representasi model akan terpotong hingga separuhnya, sehingga model kesulitan menangkap dinamika temporal trafik seluler Milan secara akurat (*underfitting*).

---

### Faktor 2: `horizon` (Kode: B6)
- **Konfigurasi yang diuji:** `horizon` $\in \{1, 6, 24\}$ jam
- **Konfigurasi tetap (Acuan):** `W=24`, `dropout=0.0`, `fitur="semua"`, `lr=0.001`, `batch=64`, `optimizer="adam"`, `loss="mse"`, `patience=30`, `max_epochs=300`.
- **Pertanyaan Pemandu:** Pada horizon berapa model mulai mengalami degradasi performa yang tajam dan bagaimana perbandingannya dengan baseline naif musiman (*yesterday* / *last week*)?

#### Hipotesis:
> **Nilai error (MAE) akan meningkat secara monoton seiring bertambahnya panjang horizon prediksi ($MAE_{H=1} < MAE_{H=6} < MAE_{H=24}$). Pada $H=1$, model neural network akan mengungguli seluruh baseline naif secara signifikan. Namun pada $H=24$, selisih keunggulan model deep learning terhadap baseline naif musiman ("kemarin" dan "minggu lalu") akan mengecil drastis, dan model rekuren (LSTM/GRU) diprediksi mempertahankan akurasi lebih baik daripada ANN.**

#### Alasan & Landasan Teoretis:
1. **Akumulasi Ketidakpastian (*Compounding Uncertainty*):** Prediksi direct multi-step untuk 24 jam ke depan sekaligus memiliki derajat ketidakpastian (*aleatoric uncertainty*) yang berlipat ganda dibanding prediksi 1 jam ke depan ($H=1$). Jam-jam yang semakin jauh di masa depan memiliki korelasi jangka pendek yang semakin rendah dengan jendela observasi terkini ($W=24$).
2. **Kekuatan Baseline Naif Musiman pada Horizon Jangka Panjang:** Aktivitas trafik seluler internet memiliki siklus sirkadian 24 jam yang sangat kuat (jam sibuk siang hari vs jam sepi dini hari) serta pola mingguan (hari kerja vs akhir pekan). Pada horizon pendek ($H=1$), variasi dinamik lokal mendominasi sehingga model terpelajar unggul jauh. Sebaliknya, pada horizon $H=24$, pola makro harian/mingguan menjadi prediktor dominan, sehingga tebakan naif musiman ("kemarin" / *yesterday* dan "minggu lalu" / *last week*) menjadi pembanding yang sangat kuat dan tangguh.
3. **Keunggulan Arsitektur Rekuren pada Multi-Output Temporal:** LSTM dan GRU memiliki mekanisme *gate* untuk mempertahankan *hidden state* representasi dinamika deret waktu, sehingga diproyeksikan lebih adaptif dalam memetakan keluaran vektor 24 jam dibanding ANN yang memperlakukan jendela input murni sebagai vektor spasial statis (*flatten*).

---

## 3. Evaluasi & Temuan Hasil Eksperimen terhadap Hipotesis

Setelah eksperimen dijalankan secara penuh (4 model × 3 seed, `CEPAT = False`), berikut adalah perbandingan antara hasil empiris dengan hipotesis awal:

### 3.1 Evaluasi Faktor B2 (`dropout`)

| Model | Dropout | Epoch | Val MAE (mean ± std) | Test MAE (mean ± std) | Natal MAE (mean ± std) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **ANN** | 0.0 *(acuan)* | 106.3 | **248.9 ± 8.9** | **309.9 ± 5.9** | 680.1 ± 52.0 |
| | 0.2 | 120.7 | 274.6 ± 31.6 | 330.3 ± 46.9 | **626.3 ± 18.3** |
| | 0.5 | 126.3 | 377.7 ± 13.1 | 411.6 ± 8.0 | 677.4 ± 47.9 |
| **RNN** | 0.0 *(acuan)* | 163.7 | **206.1 ± 7.4** | **229.6 ± 5.1** | **421.2 ± 2.4** |
| | 0.2 | 178.3 | 239.5 ± 10.7 | 260.3 ± 13.1 | 458.5 ± 30.1 |
| | 0.5 | 167.3 | 254.8 ± 11.1 | 260.2 ± 6.4 | 438.7 ± 6.7 |
| **LSTM** | 0.0 *(acuan)* | 168.7 | **230.5 ± 12.2** | 273.6 ± 25.4 | **586.0 ± 56.8** |
| | 0.2 | 228.3 | 231.8 ± 9.3 | **264.6 ± 16.6** | 596.0 ± 39.4 |
| | 0.5 | 247.0 | 247.4 ± 6.5 | 289.1 ± 10.3 | 612.8 ± 28.6 |
| **GRU** | 0.0 *(acuan)* | 193.7 | 207.5 ± 3.8 | 237.2 ± 9.3 | 468.2 ± 21.8 |
| | 0.2 | 246.3 | **203.9 ± 5.1** | **225.0 ± 12.8** | **429.7 ± 1.6** |
| | 0.5 | 215.3 | 259.5 ± 29.0 | 273.6 ± 20.5 | 472.4 ± 41.8 |

- **Status Hipotesis:** **Sebagian Benar (Terkonfirmasi pada GRU & LSTM, Tidak Terbukti pada ANN & Simple RNN).**
- **Mengapa:**
  - **Gated Recurrent (GRU & LSTM):** Regularisasi moderat ($p = 0.2$) terbukti berhasil. Pada GRU, Val MAE membaik ($207.5 \rightarrow 203.9$), Test MAE membaik ($237.2 \rightarrow 225.0$), dan Natal MAE membaik ($468.2 \rightarrow 429.7$). Pada LSTM, Test MAE membaik ($273.6 \rightarrow 264.6$) dengan variansi antar seed yang lebih konsisten ($\pm 16.6$ vs $\pm 25.4$). Arsitektur dengan gerbang memiliki kapasitas representasi internal yang cukup tinggi sehingga pemutusan neuron stochastik mampu mencegah *memorization of training noise*.
  - **ANN & Simple RNN:** Regularisasi $p = 0.2$ justru meningkatkan error. Hal ini disebabkan kapasitas dasar ANN (32 hidden unit) dan Simple RNN tidak berlebihan, dan Simple RNN sangat rentan terhadap *vanishing gradient*. Pemutusan koneksi 20% secara acak memperparah instabilitas aliran gradien temporal.
  - **Dropout Agresif ($p = 0.5$):** Benar secara universal. Seluruh model mengalami lonjakan error signifikan (*underfitting*) karena kapasitas representasi model terpangkas hingga 50%.

---

### 3.2 Evaluasi Faktor B6 (`horizon`)

| Model | Horizon (jam) | Epoch | Val MAE (mean ± std) | Test MAE (mean ± std) | Natal MAE (mean ± std) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **ANN** | 1 *(acuan)* | 106.3 | **248.9 ± 8.9** | **309.9 ± 5.9** | **680.1 ± 52.0** |
| | 6 | 120.7 | 337.2 ± 2.4 | 395.7 ± 9.1 | 901.7 ± 23.7 |
| | 24 | 154.3 | 449.0 ± 7.6 | 526.8 ± 16.1 | 1199.4 ± 30.9 |
| **RNN** | 1 *(acuan)* | 163.7 | **206.1 ± 7.4** | **229.6 ± 5.1** | **421.2 ± 2.4** |
| | 6 | 119.3 | 416.6 ± 11.4 | 427.6 ± 12.2 | 953.2 ± 43.2 |
| | 24 | 208.7 | 437.2 ± 3.2 | **486.4 ± 8.1** | **1101.6 ± 17.6** |
| **LSTM** | 1 *(acuan)* | 168.7 | **230.5 ± 12.2** | **273.6 ± 25.4** | **586.0 ± 56.8** |
| | 6 | 210.0 | 392.9 ± 24.5 | 408.3 ± 28.6 | 942.3 ± 40.9 |
| | 24 | 199.7 | 456.9 ± 19.8 | 496.1 ± 10.9 | 1150.5 ± 7.2 |
| **GRU** | 1 *(acuan)* | 193.7 | **207.5 ± 3.8** | **237.2 ± 9.3** | **468.2 ± 21.8** |
| | 6 | 204.7 | 381.1 ± 21.0 | 433.4 ± 26.4 | 962.4 ± 55.7 |
| | 24 | 193.0 | 451.8 ± 11.6 | 503.3 ± 6.5 | 1108.1 ± 33.5 |

*Pembanding Baseline Naif Duomo:*
- $H=1$ Test MAE: Naif Minggu Lalu = **467.6**, Naif Kemarin = **552.2**, Naif Terakhir = **600.9**
- $H=24$ Test MAE: Naif Minggu Lalu = **466.1**, Naif Kemarin = **563.4**, Naif Terakhir = **2769.3**

- **Status Hipotesis:** **BENAR SEPENUHNYA (Sangat Sesuai Prediksi).**
- **Mengapa:**
  - **Monotonisitas Error:** Error MAE meningkat tajam dan konsisten ($H=1 \rightarrow H=6 \rightarrow H=24$) karena akumulasi ketidakpastian (*aleatoric uncertainty*) pada proyeksi multi-langkah ke depan.
  - **Kalah dari Naif Musiman di $H=24$:** Pada $H=1$, semua model deep learning unggul jauh atas baseline naif. Namun pada $H=24$, performa seluruh model (Test MAE 486.4 – 526.8) **kalah oleh baseline naif "minggu lalu" (466.1)**. Hal ini membuktikan bahwa untuk rentang 1 hari penuh, siklus periodisitas mingguan alami deret waktu trafik seluler lebih deterministik daripada prediksi *direct multi-step* jaringan neural tanpa umpan balik autoregresif.
  - **Model Rekuren vs ANN di $H=24$:** Model rekuren (RNN: 486.4, LSTM: 496.1, GRU: 503.3) terbukti mengungguli ANN (526.8), mengonfirmasi bahwa penanganan urutan sekuensial melalui *hidden state* lebih adaptif dibanding *flattening* linear statis pada output berdimensi besar.
