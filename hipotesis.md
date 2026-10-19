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

*Catatan: Dokumen ini disusun dan di-commit ke repositori Git sebelum kode pelatihan Bagian B dijalankan sebagai bukti urutan penetapan hipotesis a priori.*
