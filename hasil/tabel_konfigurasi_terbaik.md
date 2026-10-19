# Tabel Ringkasan Konfigurasi Terbaik per Model

> **Kriteria Seleksi:** Pemilihan dilakukan murni berdasarkan nilai **val MAE terendah** pada eksperimen Bagian A (A1–A5) dan Bagian B (B2, B6) tanpa melibatkan metrik evaluasi test set. Untuk faktor `horizon`, nilai tetap dipertahankan pada 1 jam agar peramalan sebanding dengan acuan standar (direct 1-step ahead).

| Model | Faktor | Nilai Acuan | Val MAE Acuan | Nilai Terbaik | Val MAE Terbaik | Δ Val MAE | Status Perubahan | Alasan Pemilihan |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---|
| **ANN** | `W` | `24` | 248.86 ± 8.85 | **`6`** | **211.47 ± 6.22** | +37.39 | Berubah (Lebih Baik) | Terbaik. Meminimalkan dimensionalitas input linear (6x7=42 vs 24x7=168), secara signifikan mencegah over-parametrisasi dan overfitting pada 672 sampel latih (val MAE 211.5 vs acuan 248.9). |
| **ANN** | `hidden` | `32` | 248.86 ± 8.85 | **`128`** | **233.79 ± 1.89** | +15.07 | Berubah (Lebih Baik) | Terbaik. Memberikan kapasitas non-linear terluas dengan val MAE terendah (233.8) dan simpangan baku paling stabil (±1.89). |
| **ANN** | `layers` | `2` | 248.86 ± 8.85 | **`1`** | **240.91 ± 7.52** | +7.95 | Berubah (Lebih Baik) | Terbaik. Arsitektur dangkal (1 hidden layer) membatasi penumpukan parameter, menghasilkan val MAE terendah (240.9) pada data latih terbatas. |
| **ANN** | `lr` | `0.001` | 248.86 ± 8.85 | **`0.001`** | **248.86 ± 8.85** | +0.00 | Tetap Sesuai Acuan | Terbaik. Konvergensi optimal dan seimbang, mencapai val MAE terendah (248.9). |
| **ANN** | `fitur` | `semua` | 248.86 ± 8.85 | **`net+waktu`** | **246.00 ± 9.79** | +2.86 | Berubah (Lebih Baik) | Terbaik. Memberikan sinyal periodisitas sirkadian dan mingguan yang kuat tanpa derau fluktuasi panggilan/SMS pada input flattened (val MAE 246.0). |
| **ANN** | `dropout` | `0.0` | 248.86 ± 8.85 | **`0.0`** | **248.86 ± 8.85** | +0.00 | Tetap Sesuai Acuan | Terbaik. Tanpa dropout mempertahankan seluruh koneksi representasi padat terpadu, menghasilkan val MAE terendah (248.9). |
| **ANN** | `horizon` | `1` | 248.86 ± 8.85 | **`1`** | **248.86 ± 8.85** | +0.00 | Tetap Sesuai Acuan | Terbaik. Val MAE terendah (248.9) tanpa penumpukan ketidakpastian multi-langkah; dipertahankan agar evaluasi sebanding dengan acuan. |
| **RNN** | `W` | `24` | 206.12 ± 7.44 | **`48`** | **200.07 ± 5.27** | +6.05 | Berubah (Lebih Baik) | Terbaik. Memberikan konteks 2 siklus sirkadian harian penuh bagi Simple RNN tanpa memperparah vanishing gradient (val MAE 200.1 ± 5.3). |
| **RNN** | `hidden` | `68` | 206.12 ± 7.44 | **`64`** | **207.17 ± 12.80** | -1.05 | Tetap Sesuai Acuan | Terbaik pada grid A2. Menghasilkan val MAE terendah di antara kandidat grid (207.2 ± 12.8), sangat konsisten dengan acuan khusus RNN (hidden=68, val MAE 206.1). |
| **RNN** | `layers` | `1` | 206.12 ± 7.44 | **`1`** | **206.12 ± 7.44** | +0.00 | Tetap Sesuai Acuan | Terbaik. Struktur 1 lapisan rekuren tunggal meminimalkan kendala vanishing gradient pada Simple RNN (val MAE 206.1). |
| **RNN** | `lr` | `0.001` | 206.12 ± 7.44 | **`0.001`** | **206.12 ± 7.44** | +0.00 | Tetap Sesuai Acuan | Terbaik. Titik konvergensi optimal yang stabil dan seimbang antar seed (val MAE 206.1). |
| **RNN** | `fitur` | `semua` | 206.12 ± 7.44 | **`semua`** | **206.12 ± 7.44** | +0.00 | Tetap Sesuai Acuan | Terbaik. Pemrosesan sekuensial memungkinkan RNN menyerap sinergi seluruh 7 fitur multimodal secara optimal tanpa inflasi parameter (val MAE 206.1). |
| **RNN** | `dropout` | `0.0` | 206.12 ± 7.44 | **`0.0`** | **206.12 ± 7.44** | +0.00 | Tetap Sesuai Acuan | Terbaik. Tanpa dropout menjaga kestabilan transmisi memori temporal jangka pendek Simple RNN (val MAE 206.1). |
| **RNN** | `horizon` | `1` | 206.12 ± 7.44 | **`1`** | **206.12 ± 7.44** | +0.00 | Tetap Sesuai Acuan | Terbaik. Val MAE terendah (206.1) dan menjadi acuan evaluasi standar 1 langkah ke depan. |
| **LSTM** | `W` | `24` | 230.47 ± 12.20 | **`6`** | **227.09 ± 4.26** | +3.37 | Berubah (Lebih Baik) | Terbaik. Menghasilkan val MAE terendah (227.1) dan variansi terkecil (±4.26); gerbang LSTM fokus pada dinamika lokal terbersih tanpa noise historis panjang. |
| **LSTM** | `hidden` | `33` | 230.47 ± 12.20 | **`128`** | **207.13 ± 8.44** | +23.34 | Berubah (Lebih Baik) | Terbaik. Memori cell state besar dan diskriminasi gerbang 3 cabang memangkas val MAE ke 207.1 (±8.4). |
| **LSTM** | `layers` | `1` | 230.47 ± 12.20 | **`1`** | **230.47 ± 12.20** | +0.00 | Tetap Sesuai Acuan | Terbaik. Lapisan tunggal menghasilkan val MAE paling rendah (230.5). |
| **LSTM** | `lr` | `0.001` | 230.47 ± 12.20 | **`0.01`** | **215.89 ± 14.21** | +14.58 | Berubah (Lebih Baik) | Terbaik. Mempercepat pelatihan melalui parameter gerbang yang banyak, meloloskan optimasi dari dataran loss lebih cepat (val MAE 215.9 ± 14.2). |
| **LSTM** | `fitur` | `semua` | 230.47 ± 12.20 | **`semua`** | **230.47 ± 12.20** | +0.00 | Tetap Sesuai Acuan | Terbaik. Gerbang input dan forget LSTM secara adaptif menyaring seluruh 7 fitur multimodal (val MAE 230.5). |
| **LSTM** | `dropout` | `0.0` | 230.47 ± 12.20 | **`0.0`** | **230.47 ± 12.20** | +0.00 | Tetap Sesuai Acuan | Terbaik. Menghasilkan rata-rata val MAE terendah (230.5 vs 231.8 pada p=0.2). |
| **LSTM** | `horizon` | `1` | 230.47 ± 12.20 | **`1`** | **230.47 ± 12.20** | +0.00 | Tetap Sesuai Acuan | Terbaik. Val MAE terendah (230.5); evaluasi standar direct 1-step ahead. |
| **GRU** | `W` | `24` | 207.54 ± 3.77 | **`48`** | **206.75 ± 5.04** | +0.79 | Berubah (Lebih Baik) | Terbaik. Menangkap siklus dua harian penuh dengan val MAE terendah (206.75 ± 5.04, 206.7469 vs W=168 206.7485). |
| **GRU** | `hidden` | `38` | 207.54 ± 3.77 | **`128`** | **188.65 ± 4.24** | +18.89 | Berubah (Lebih Baik) | Terbaik. Val MAE terendah dari seluruh model dan faktor (188.7 ± 4.2); efisiensi 2 gerbang GRU memaksimalkan kapasitas besar tanpa overfitting. |
| **GRU** | `layers` | `1` | 207.54 ± 3.77 | **`2`** | **203.31 ± 9.56** | +4.23 | Berubah (Lebih Baik) | Terbaik. Arsitektur 2 lapis bertumpuk berhasil membangun representasi fitur hierarkis tingkat tinggi (val MAE 203.3 ± 9.6). |
| **GRU** | `lr` | `0.001` | 207.54 ± 3.77 | **`0.001`** | **207.54 ± 3.77** | +0.00 | Tetap Sesuai Acuan | Terbaik. Titik optimal dengan deviasi standar paling rapat dan stabil (val MAE 207.5 ± 3.8). |
| **GRU** | `fitur` | `semua` | 207.54 ± 3.77 | **`semua`** | **207.54 ± 3.77** | +0.00 | Tetap Sesuai Acuan | Terbaik. Integrasi seluruh 7 dimensi multimodal memberikan akurasi validasi terbaik (val MAE 207.5 ± 3.8). |
| **GRU** | `dropout` | `0.0` | 207.54 ± 3.77 | **`0.2`** | **203.92 ± 5.10** | +3.62 | Berubah (Lebih Baik) | Terbaik. Dropout moderat 0.2 sukses meregularisasi gerbang rekuren GRU sehingga mencegah ko-adaptasi neuron (val MAE 203.9 ± 5.1). |
| **GRU** | `horizon` | `1` | 207.54 ± 3.77 | **`1`** | **207.54 ± 3.77** | +0.00 | Tetap Sesuai Acuan | Terbaik. Val MAE terendah (207.5) dan sebanding dengan tugas peramalan acuan. |


## Rekomendasi Format Dictionary `TERBAIK` untuk Bagian C:

```python
TERBAIK = {
    "ANN": {"W": 6, "hidden": 128, "layers": 1, "fitur": "net+waktu"},
    "RNN": {"W": 48},
    "LSTM": {"W": 6, "hidden": 128, "lr": 0.01},
    "GRU": {"W": 48, "hidden": 128, "layers": 2, "dropout": 0.2},
}
```
