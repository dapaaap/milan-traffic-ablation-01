# Tabel Pemilihan Faktor Ablasi (A1–A5 & Bagian B) Berdasarkan Val MAE

> **Catatan Metodologi:** Seluruh pemilihan nilai optimal dilakukan **hanya berdasarkan rata-rata `val_MAE`** (3 random seed) pada data validasi Duomo. **Tidak ada angka test maupun Natal yang digunakan** dalam proses seleksi ini guna menjamin objektivitas dan mencegah kebocoran data (*data leakage*).

## Model: ANN

| Bagian | Faktor | Nilai Kandidat | Val MAE (mean ± std) | Status | Alasan Pemilihan |
|:---:|:---:|:---:|:---:|:---:|:---|
| A1 | `W` | `6` | **211.47 ± 6.22** | **TERPILIH (TERBAIK)** | Terbaik. Meminimalkan dimensionalitas input linear (6x7=42 vs 24x7=168), secara signifikan mencegah over-parametrisasi dan overfitting pada 672 sampel latih (val MAE 211.5 vs acuan 248.9). |
| A1 | `W` | `12` | 238.54 ± 4.54 | Kandidat | Error validasi meningkat dibanding W=6 seiring bertambahnya bobot koneksi lapisan input (val MAE 238.5). |
| A1 | `W` | `24` | 248.86 ± 8.85 | Kandidat | Konfigurasi acuan. Pembengkakan dimensi input mulai memicu memorisasi derau data latih (val MAE 248.9). |
| A1 | `W` | `48` | 262.61 ± 3.81 | Kandidat | Peningkatan parameter input memperburuk error validasi secara konsisten (val MAE 262.6). |
| A1 | `W` | `168` | 298.17 ± 18.17 | Kandidat | Parameter lapisan pertama membengkak ekstrem, memicu overfitting parah pada data validasi (val MAE 298.2). |
| A2 | `hidden` | `16` | 257.62 ± 27.98 | Kandidat | Kapasitas representasi terlalu sempit untuk memetakan dinamika korelasi lintas-fitur (val MAE 257.6). |
| A2 | `hidden` | `32` | 248.86 ± 8.85 | Kandidat | Konfigurasi acuan. Kapasitas representasi non-linear masih suboptimal (val MAE 248.9). |
| A2 | `hidden` | `64` | 238.41 ± 16.51 | Kandidat | Peningkatan kapasitas menurunkan error validasi ke 238.4, namun masih di bawah hidden=128. |
| A2 | `hidden` | `128` | **233.79 ± 1.89** | **TERPILIH (TERBAIK)** | Terbaik. Memberikan kapasitas non-linear terluas dengan val MAE terendah (233.8) dan simpangan baku paling stabil (±1.89). |
| A3 | `layers` | `1` | **240.91 ± 7.52** | **TERPILIH (TERBAIK)** | Terbaik. Arsitektur dangkal (1 hidden layer) membatasi penumpukan parameter, menghasilkan val MAE terendah (240.9) pada data latih terbatas. |
| A3 | `layers` | `2` | 248.86 ± 8.85 | Kandidat | Konfigurasi acuan. Val MAE 248.9, lebih tinggi dibanding 1 lapisan. |
| A3 | `layers` | `3` | 244.88 ± 5.38 | Kandidat | Arsitektur 3 lapis memicu overfitting dan perambatan gradien yang terdistorsi (val MAE 244.9). |
| A4 | `lr` | `0.0001` | 295.25 ± 4.64 | Kandidat | Laju pembelajaran terlalu kecil, konvergensi lambat dan tertahan sebelum mencapai minimum loss (val MAE 295.3). |
| A4 | `lr` | `0.001` | **248.86 ± 8.85** | **TERPILIH (TERBAIK)** | Terbaik. Konvergensi optimal dan seimbang, mencapai val MAE terendah (248.9). |
| A4 | `lr` | `0.01` | 261.76 ± 16.64 | Kandidat | Laju pembelajaran terlalu besar memicu osilasi di sekitar lembah fungsi loss (val MAE 261.8). |
| A5 | `fitur` | `net` | 260.45 ± 6.99 | Kandidat | Hanya fitur univariat internet tanpa indikator waktu maupun saluran komunikasi (val MAE 260.5). |
| A5 | `fitur` | `net+call+sms` | 259.90 ± 5.19 | Kandidat | Penambahan trafik panggilan dan SMS tanpa penanda waktu belum optimal pada representasi flattened (val MAE 259.9). |
| A5 | `fitur` | `net+waktu` | **246.00 ± 9.79** | **TERPILIH (TERBAIK)** | Terbaik. Memberikan sinyal periodisitas sirkadian dan mingguan yang kuat tanpa derau fluktuasi panggilan/SMS pada input flattened (val MAE 246.0). |
| A5 | `fitur` | `semua` | 248.86 ± 8.85 | Kandidat | Konfigurasi acuan. Penambahan call/sms sedikit menambah sensitivitas terhadap derau pada model flattened (val MAE 248.9). |
| B2 | `dropout` | `0.0` | **248.86 ± 8.85** | **TERPILIH (TERBAIK)** | Terbaik. Tanpa dropout mempertahankan seluruh koneksi representasi padat terpadu, menghasilkan val MAE terendah (248.9). |
| B2 | `dropout` | `0.2` | 274.60 ± 31.64 | Kandidat | Dropout 0.2 memutus koneksi acak pada arsitektur padat terbatas sehingga memicu underfitting (val MAE 274.6). |
| B2 | `dropout` | `0.5` | 377.68 ± 13.05 | Kandidat | Dropout 0.5 memotong separuh kapasitas representasi sehingga error validasi melonjak drastis (val MAE 377.7). |
| B6 | `horizon` | `1` | **248.86 ± 8.85** | **TERPILIH (TERBAIK)** | Terbaik. Val MAE terendah (248.9) tanpa penumpukan ketidakpastian multi-langkah; dipertahankan agar evaluasi sebanding dengan acuan. |
| B6 | `horizon` | `6` | 337.19 ± 2.44 | Kandidat | Error validasi meningkat tajam akibat akumulasi ketidakpastian peramalan multi-output (val MAE 337.2). |
| B6 | `horizon` | `24` | 448.99 ± 7.60 | Kandidat | Degradasi akurasi signifikan pada peramalan langsung 24 jam ke depan sekaligus (val MAE 449.0). |

---

## Model: RNN

| Bagian | Faktor | Nilai Kandidat | Val MAE (mean ± std) | Status | Alasan Pemilihan |
|:---:|:---:|:---:|:---:|:---:|:---|
| A1 | `W` | `6` | 215.48 ± 4.09 | Kandidat | Konteks 6 jam terlalu pendek untuk mencakup satu siklus sirkadian 24 jam penuh (val MAE 215.5). |
| A1 | `W` | `12` | 206.74 ± 6.16 | Kandidat | Konteks setengah hari belum mencukupi periodisitas sirkadian (val MAE 206.7). |
| A1 | `W` | `24` | 206.12 ± 7.44 | Kandidat | Konfigurasi acuan. Mencakup tepat 1 siklus harian dengan val MAE 206.1. |
| A1 | `W` | `48` | **200.07 ± 5.27** | **TERPILIH (TERBAIK)** | Terbaik. Memberikan konteks 2 siklus sirkadian harian penuh bagi Simple RNN tanpa memperparah vanishing gradient (val MAE 200.1 ± 5.3). |
| A1 | `W` | `168` | 204.85 ± 10.21 | Kandidat | Konteks 1 minggu penuh mulai mengalami degradasi akibat pelenyapan gradien temporal pada Simple RNN (val MAE 204.9). |
| A2 | `hidden` | `16` | 246.98 ± 5.81 | Kandidat | Ruang status tersembunyi terlalu sempit untuk memproses sekuens temporal secara efektif (val MAE 247.0). |
| A2 | `hidden` | `32` | 218.66 ± 6.56 | Kandidat | Kapasitas representasi masih kurang memadai untuk dinamika multivariat (val MAE 218.7). |
| A2 | `hidden` | `64` | **207.17 ± 12.80** | **TERPILIH (TERBAIK)** | Terbaik pada grid A2. Menghasilkan val MAE terendah di antara kandidat grid (207.2 ± 12.8), sangat konsisten dengan acuan khusus RNN (hidden=68, val MAE 206.1). |
| A2 | `hidden` | `128` | 207.66 ± 7.20 | Kandidat | Kapasitas besar mulai mengalami sedikit kejenuhan/overfitting pada Simple RNN (val MAE 207.7). |
| A3 | `layers` | `1` | **206.12 ± 7.44** | **TERPILIH (TERBAIK)** | Terbaik. Struktur 1 lapisan rekuren tunggal meminimalkan kendala vanishing gradient pada Simple RNN (val MAE 206.1). |
| A3 | `layers` | `2` | 207.28 ± 9.09 | Kandidat | Penumpukan lapisan rekuren memperpanjang jalur perambatan balik gradien tanpa perbaikan performa (val MAE 207.3). |
| A3 | `layers` | `3` | 225.08 ± 12.69 | Kandidat | Vanishing gradient parah pada 3 lapisan Simple RNN meningkatkan error validasi secara nyata (val MAE 225.1). |
| A4 | `lr` | `0.0001` | 285.03 ± 13.71 | Kandidat | Laju pembelajaran terlalu kecil, konvergensi lambat dan terhenti sebelum optimal (val MAE 285.0). |
| A4 | `lr` | `0.001` | **206.12 ± 7.44** | **TERPILIH (TERBAIK)** | Terbaik. Titik konvergensi optimal yang stabil dan seimbang antar seed (val MAE 206.1). |
| A4 | `lr` | `0.01` | 226.71 ± 6.74 | Kandidat | Laju pembelajaran terlalu besar memicu lonjakan gradien dan instabilitas pembaruan bobot transisi (val MAE 226.7). |
| A5 | `fitur` | `net` | 245.24 ± 5.80 | Kandidat | Hanya sinyal univariat tanpa informasi eksogen pendukung (val MAE 245.2). |
| A5 | `fitur` | `net+call+sms` | 224.08 ± 2.33 | Kandidat | Tambahan trafik telekomunikasi menurunkan error, namun belum memiliki penanda waktu eksplisit (val MAE 224.1). |
| A5 | `fitur` | `net+waktu` | 223.00 ± 9.53 | Kandidat | Penanda waktu membantu rekurensi mengenali fase jam dan hari secara berkala (val MAE 223.0). |
| A5 | `fitur` | `semua` | **206.12 ± 7.44** | **TERPILIH (TERBAIK)** | Terbaik. Pemrosesan sekuensial memungkinkan RNN menyerap sinergi seluruh 7 fitur multimodal secara optimal tanpa inflasi parameter (val MAE 206.1). |
| B2 | `dropout` | `0.0` | **206.12 ± 7.44** | **TERPILIH (TERBAIK)** | Terbaik. Tanpa dropout menjaga kestabilan transmisi memori temporal jangka pendek Simple RNN (val MAE 206.1). |
| B2 | `dropout` | `0.2` | 239.53 ± 10.71 | Kandidat | Dropout mengganggu transmisi state rekuren antar langkah waktu sehingga menaikkan error validasi (val MAE 239.5). |
| B2 | `dropout` | `0.5` | 254.78 ± 11.06 | Kandidat | Pemutusan 50% unit rekuren merusak kontinuitas state deret waktu secara fatal (val MAE 254.8). |
| B6 | `horizon` | `1` | **206.12 ± 7.44** | **TERPILIH (TERBAIK)** | Terbaik. Val MAE terendah (206.1) dan menjadi acuan evaluasi standar 1 langkah ke depan. |
| B6 | `horizon` | `6` | 416.59 ± 11.42 | Kandidat | Error peramalan meningkat drastis pada proyeksi 6 jam ke depan (val MAE 416.6). |
| B6 | `horizon` | `24` | 437.17 ± 3.20 | Kandidat | Degradasi performa tajam pada peramalan langsung multi-langkah 24 jam (val MAE 437.2). |

---

## Model: LSTM

| Bagian | Faktor | Nilai Kandidat | Val MAE (mean ± std) | Status | Alasan Pemilihan |
|:---:|:---:|:---:|:---:|:---:|:---|
| A1 | `W` | `6` | **227.09 ± 4.26** | **TERPILIH (TERBAIK)** | Terbaik. Menghasilkan val MAE terendah (227.1) dan variansi terkecil (±4.26); gerbang LSTM fokus pada dinamika lokal terbersih tanpa noise historis panjang. |
| A1 | `W` | `12` | 235.63 ± 2.00 | Kandidat | Konteks 12 jam memiliki error sedikit lebih tinggi dibanding jendela pendek (val MAE 235.6). |
| A1 | `W` | `24` | 230.47 ± 12.20 | Kandidat | Konfigurasi acuan (val MAE 230.5). |
| A1 | `W` | `48` | 249.06 ± 21.82 | Kandidat | Peningkatan panjang urutan menambah akumulasi derau sekuensial pada pembaruan cell state (val MAE 249.1). |
| A1 | `W` | `168` | 241.38 ± 8.12 | Kandidat | Urutan seminggu penuh meningkatkan ketidakstabilan optimasi parameter gerbang pada data latih kecil (val MAE 241.4). |
| A2 | `hidden` | `16` | 244.28 ± 18.26 | Kandidat | Kapasitas gerbang dan cell state terlalu sempit untuk dinamika trafik kompleks (val MAE 244.3). |
| A2 | `hidden` | `32` | 241.47 ± 20.54 | Kandidat | Kapasitas masih terbatas, setara acuan hidden=33 (val MAE 241.5). |
| A2 | `hidden` | `64` | 218.11 ± 1.88 | Kandidat | Peningkatan performa signifikan dengan val MAE membaik ke 218.1. |
| A2 | `hidden` | `128` | **207.13 ± 8.44** | **TERPILIH (TERBAIK)** | Terbaik. Memori cell state besar dan diskriminasi gerbang 3 cabang memangkas val MAE ke 207.1 (±8.4). |
| A3 | `layers` | `1` | **230.47 ± 12.20** | **TERPILIH (TERBAIK)** | Terbaik. Lapisan tunggal menghasilkan val MAE paling rendah (230.5). |
| A3 | `layers` | `2` | 254.79 ± 14.48 | Kandidat | Penumpukan 2 lapisan LSTM menggandakan parameter gerbang secara masif, memicu overfitting pada sampel kecil (val MAE 254.8). |
| A3 | `layers` | `3` | 338.89 ± 16.89 | Kandidat | Overfitting ekstrem terjadi pada 3 lapisan dengan lonjakan error drastis (val MAE 338.9). |
| A4 | `lr` | `0.0001` | 399.37 ± 25.04 | Kandidat | Sangat lambat; optimasi parameter gerbang yang kompleks tertahan sebelum konvergen (val MAE 399.4). |
| A4 | `lr` | `0.001` | 230.47 ± 12.20 | Kandidat | Konfigurasi acuan (val MAE 230.5). |
| A4 | `lr` | `0.01` | **215.89 ± 14.21** | **TERPILIH (TERBAIK)** | Terbaik. Mempercepat pelatihan melalui parameter gerbang yang banyak, meloloskan optimasi dari dataran loss lebih cepat (val MAE 215.9 ± 14.2). |
| A5 | `fitur` | `net` | 266.18 ± 5.74 | Kandidat | Hanya fitur univariat (val MAE 266.2). |
| A5 | `fitur` | `net+call+sms` | 243.65 ± 7.08 | Kandidat | Penurunan error yang baik tetapi belum memanfaatkan pola siklus jam/hari (val MAE 243.7). |
| A5 | `fitur` | `net+waktu` | 231.13 ± 4.27 | Kandidat | Pola waktu sangat membantu gerbang forget menyaring siklus sirkadian (val MAE 231.1). |
| A5 | `fitur` | `semua` | **230.47 ± 12.20** | **TERPILIH (TERBAIK)** | Terbaik. Gerbang input dan forget LSTM secara adaptif menyaring seluruh 7 fitur multimodal (val MAE 230.5). |
| B2 | `dropout` | `0.0` | **230.47 ± 12.20** | **TERPILIH (TERBAIK)** | Terbaik. Menghasilkan rata-rata val MAE terendah (230.5 vs 231.8 pada p=0.2). |
| B2 | `dropout` | `0.2` | 231.84 ± 9.28 | Kandidat | Regularisasi moderat kompetitif dengan dispersi rapat (val MAE 231.8 ± 9.3), namun rata-ratanya sedikit di atas p=0.0. |
| B2 | `dropout` | `0.5` | 247.39 ± 6.51 | Kandidat | Dropout berlebih merusak retensi cell state dan memicu underfitting (val MAE 247.4). |
| B6 | `horizon` | `1` | **230.47 ± 12.20** | **TERPILIH (TERBAIK)** | Terbaik. Val MAE terendah (230.5); evaluasi standar direct 1-step ahead. |
| B6 | `horizon` | `6` | 392.88 ± 24.49 | Kandidat | Error multi-step meningkat drastis akibat akumulasi ketidakpastian (val MAE 392.9). |
| B6 | `horizon` | `24` | 456.93 ± 19.83 | Kandidat | Akumulasi ketidakpastian sangat tinggi pada proyeksi 24 langkah ke depan (val MAE 456.9). |

---

## Model: GRU

| Bagian | Faktor | Nilai Kandidat | Val MAE (mean ± std) | Status | Alasan Pemilihan |
|:---:|:---:|:---:|:---:|:---:|:---|
| A1 | `W` | `6` | 212.58 ± 11.46 | Kandidat | Konteks 6 jam belum memanfaatkan ketahanan memori jangka panjang gerbang reset/update (val MAE 212.6). |
| A1 | `W` | `12` | 208.88 ± 10.43 | Kandidat | Perbaikan bertahap seiring bertambahnya rentang observasi (val MAE 208.9). |
| A1 | `W` | `24` | 207.54 ± 3.77 | Kandidat | Konfigurasi acuan (val MAE 207.5 ± 3.8). |
| A1 | `W` | `48` | **206.75 ± 5.04** | **TERPILIH (TERBAIK)** | Terbaik. Menangkap siklus dua harian penuh dengan val MAE terendah (206.75 ± 5.04, 206.7469 vs W=168 206.7485). |
| A1 | `W` | `168` | 206.75 ± 5.06 | Kandidat | Performa hampir identik dengan W=48 (val MAE 206.75 ± 5.06), namun W=48 lebih efisien komputasinya. |
| A2 | `hidden` | `16` | 216.77 ± 21.23 | Kandidat | Kapasitas terbatas untuk menangkap interaksi multi-langkah (val MAE 216.8). |
| A2 | `hidden` | `32` | 210.21 ± 0.78 | Kandidat | Mendekati acuan (hidden=38), val MAE 210.2. |
| A2 | `hidden` | `64` | 198.40 ± 9.18 | Kandidat | Perbaikan tajam dengan val MAE turun ke 198.4. |
| A2 | `hidden` | `128` | **188.65 ± 4.24** | **TERPILIH (TERBAIK)** | Terbaik. Val MAE terendah dari seluruh model dan faktor (188.7 ± 4.2); efisiensi 2 gerbang GRU memaksimalkan kapasitas besar tanpa overfitting. |
| A3 | `layers` | `1` | 207.54 ± 3.77 | Kandidat | Konfigurasi acuan (val MAE 207.5). |
| A3 | `layers` | `2` | **203.31 ± 9.56** | **TERPILIH (TERBAIK)** | Terbaik. Arsitektur 2 lapis bertumpuk berhasil membangun representasi fitur hierarkis tingkat tinggi (val MAE 203.3 ± 9.6). |
| A3 | `layers` | `3` | 212.23 ± 15.89 | Kandidat | Mulai mengalami kejenuhan dan sedikit overfitting pada lapisan ke-3 (val MAE 212.2). |
| A4 | `lr` | `0.0001` | 398.40 ± 8.64 | Kandidat | Sangat lambat konvergen sebelum batas toleransi early stopping (val MAE 398.4). |
| A4 | `lr` | `0.001` | **207.54 ± 3.77** | **TERPILIH (TERBAIK)** | Terbaik. Titik optimal dengan deviasi standar paling rapat dan stabil (val MAE 207.5 ± 3.8). |
| A4 | `lr` | `0.01` | 208.16 ± 5.64 | Kandidat | Performa kompetitif (val MAE 208.2), namun sedikit lebih tinggi error-nya dibanding lr=0.001. |
| A5 | `fitur` | `net` | 264.63 ± 7.03 | Kandidat | Hanya fitur univariat internet (val MAE 264.6). |
| A5 | `fitur` | `net+call+sms` | 231.79 ± 12.55 | Kandidat | Peningkatan performa signifikan dari data panggilan/SMS (val MAE 231.8). |
| A5 | `fitur` | `net+waktu` | 213.18 ± 18.24 | Kandidat | Fitur waktu menurunkan error secara drastis (val MAE 213.2). |
| A5 | `fitur` | `semua` | **207.54 ± 3.77** | **TERPILIH (TERBAIK)** | Terbaik. Integrasi seluruh 7 dimensi multimodal memberikan akurasi validasi terbaik (val MAE 207.5 ± 3.8). |
| B2 | `dropout` | `0.0` | 207.54 ± 3.77 | Kandidat | Konfigurasi acuan (val MAE 207.5). |
| B2 | `dropout` | `0.2` | **203.92 ± 5.10** | **TERPILIH (TERBAIK)** | Terbaik. Dropout moderat 0.2 sukses meregularisasi gerbang rekuren GRU sehingga mencegah ko-adaptasi neuron (val MAE 203.9 ± 5.1). |
| B2 | `dropout` | `0.5` | 259.51 ± 29.00 | Kandidat | Dropout terlalu besar menyebabkan underfitting (val MAE 259.5). |
| B6 | `horizon` | `1` | **207.54 ± 3.77** | **TERPILIH (TERBAIK)** | Terbaik. Val MAE terendah (207.5) dan sebanding dengan tugas peramalan acuan. |
| B6 | `horizon` | `6` | 381.06 ± 20.96 | Kandidat | Error multi-step meningkat drastis (val MAE 381.1). |
| B6 | `horizon` | `24` | 451.81 ± 11.58 | Kandidat | Error meningkat tajam pada prediksi 24 jam ke depan (val MAE 451.8). |

---

