# Analisis Generalisasi Bagian D: Duomo vs Navigli (Kode 1)

**Lokasi Kelompok:** Kode 1 — Navigli (Darsena), Kotak 4555  
**Lokasi Evaluasi Awal:** Duomo, Kotak 5060  

---

## 1. Tabel Perbandingan Lengkap Acuan vs Terbaik di Navigli

| Model | Konfigurasi | Parameter | Val MAE (mean ± std) | Test MAE (mean ± std) | Test MAPE (%) | Natal MAE (mean ± std) | Status di Navigli |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---|
| **ANN** | Acuan | 6,497 | 166.6 ± 5.3 | **222.3 ± 27.4** | 8.9 ± 1.1 | 664.5 ± 190.8 | Baseline Acuan |
| **ANN** | Terbaik | 4,097 | 138.4 ± 1.7 | **191.1 ± 1.9** | 7.9 ± 0.1 | 607.7 ± 56.1 | **Sangat Unggul** (Test MAE membaik tajam) |
| **RNN** | Acuan | 5,305 | 147.3 ± 4.9 | **193.0 ± 9.7** | 7.8 ± 0.3 | 534.7 ± 148.9 | Baseline Acuan |
| **RNN** | Terbaik | 5,305 | 148.7 ± 7.7 | **211.7 ± 24.3** | 8.7 ± 1.0 | 649.2 ± 92.5 | **Degradasi** (Test MAE melemah) |
| **LSTM** | Acuan | 5,578 | 164.3 ± 9.3 | **247.3 ± 54.3** | 10.0 ± 2.7 | 950.8 ± 110.9 | Baseline Acuan |
| **LSTM** | Terbaik | 70,273 | 147.2 ± 4.2 | **210.4 ± 7.7** | 8.5 ± 0.5 | 738.4 ± 41.9 | **Sangat Unggul** (Test MAE membaik tajam) |
| **GRU** | Acuan | 5,397 | 149.0 ± 6.0 | **190.8 ± 6.8** | 7.8 ± 0.2 | 496.4 ± 50.9 | Baseline Acuan |
| **GRU** | Terbaik | 151,809 | 132.5 ± 2.1 | **223.1 ± 17.0** | 9.6 ± 0.7 | 753.7 ± 49.8 | **Degradasi** (Test MAE melemah) |

*Pembanding Baseline Naif di Navigli (H=1):*
- **Minggu Test (16–22 Des):** Naif Nilai Terakhir = **272.0**, Naif Kemarin = **342.3**, Naif Minggu Lalu = **471.4**
- **Minggu Natal (23–29 Des):** Naif Nilai Terakhir = **177.7**, Naif Kemarin = **273.2**, Naif Minggu Lalu = **1107.3**

---

## 2. Perbandingan Head-to-Head: Duomo vs Navigli (Test MAE)

| Model | Duomo (Acuan) | Duomo (Terbaik) | Navigli (Acuan) | Navigli (Terbaik) | Perilaku Generalisasi |
| :---: | :---: | :---: | :---: | :---: | :---|
| **ANN** | 309.9 ± 5.9 | 288.1 ± 15.6 | 222.3 ± 27.4 | **191.1 ± 1.9** | **Sangat Konsisten:** Terbaik selalu unggul jauh atas acuan; bahkan di Navigli menjadi **Model Terbaik #1** |
| **RNN** | 229.6 ± 5.1 | 224.5 ± 11.7 | 193.0 ± 9.7 | 211.7 ± 24.3 | **Tidak Konsisten:** Di Duomo W=48 membaik, di Navigli W=48 kalah dari W=24 |
| **LSTM** | 273.6 ± 25.4 | 225.3 ± 4.0 | 247.3 ± 54.3 | 210.4 ± 7.7 | **Sangat Konsisten:** Peningkatan akurasi besar dan variansi sangat rapat |
| **GRU** | 237.2 ± 9.3 | 239.7 ± 9.9 | 190.8 ± 6.8 | 223.1 ± 17.0 | **Konsisten Mengalami Degradasi:** Kapasitas raksasa (151k param) overfit di validasi, melemah di test/Natal |

---

## 3. Analisis Urutan Model (Model Ranking)

- **Di Duomo (Pusat Bisnis):**
  - Urutan Acuan: RNN (229.6) < GRU (237.2) < LSTM (273.6) < ANN (309.9)
  - Urutan Terbaik: RNN (224.5) < LSTM (225.3) < GRU (239.7) < ANN (288.1)
  - *Karakteristik Duomo:* Model rekuren mendominasi; ANN selalu berada di posisi paling buncit.
- **Di Navigli (Pusat Kanal & Hiburan Malam):**
  - Urutan Acuan: GRU (190.8) < RNN (193.0) < ANN (222.3) < LSTM (247.3)
  - Urutan Terbaik: **ANN (191.1)** < **LSTM (210.4)** < RNN (211.7) < GRU (223.1)
  - *Perubahan Signifikan:* **Urutan model berubah total!** ANN melesat dari posisi paling belakang di Duomo menjadi **model nomor satu** di Navigli, mengungguli seluruh model rekuren.

---

## 4. Karakteristik Kawasan Navigli (Darsena): Kanal dan Hiburan Malam

1. **Pola Aktivitas Malam & Akhir Pekan:**
   - Navigli adalah distrik *nightlife* yang dipenuhi kanal bersejarah, kafe, bar, dan restoran di sekitar cekungan Darsena.
   - Jika Duomo didominasi oleh jam kerja siang hari (Senin–Jumat pukul 08.00–18.00), Navigli memiliki lonjakan trafik internet yang sangat tajam pada **malam hingga dini hari (pukul 20.00–03.00)** serta **akhir pekan (Jumat malam hingga Minggu)**.
2. **Keunggulan Jendela Pendek (W=6) vs Kelemahan Jendela Panjang (W=48):**
   - Dinamika pengunjung hiburan malam bersifat impulsif dan situasional. Jendela observasi panjang ($W=48$ jam pada RNN dan GRU) membawa informasi masa lalu yang tidak relevan (misal kondisi Rabu malam yang sepi mengaburkan lonjakan Jumat malam).
   - Sebaliknya, model dengan $W=6$ jam (ANN dan LSTM) hanya membaca dinamika 6 jam terakhir (*recent surge* sesaat sebelum kehidupan malam dimulai), sehingga responsif dan bebas dari distorsi histori 2 hari sebelumnya.
3. **Mengapa ANN Menjadi Model Terbaik di Navigli?**
   - Fitur periodik `net+waktu` memberikan penanda fase jam dan hari secara deterministik tanpa dipusingkan rekurensi state jangka panjang. Dikombinasikan dengan 1 hidden layer (128 unit) dan $W=6$, ANN mampu melakukan pemetaan langsung yang kuat dan bebas dari distorsi urutan memori temporal.
4. **Perilaku di Minggu Natal (23–29 Desember):**
   - Di minggu Natal, bar dan kawasan kanal Navigli mengalami perubahan pola drastis karena warga berlibur di rumah.
   - Baseline naif "nilai terakhir" menghasilkan error rendah (177.7) karena aktivitas tetap datar, sementara model deep learning yang terbiasa melihat pola malam reguler memprediksi lonjakan yang tidak terjadi.
