= Hasil

== Bagian 0 — Baseline Naif dan Acuan

Evaluasi diawali dengan membandingkan empat model pada konfigurasi acuan dengan tiga baseline naif di Duomo (kotak 5060) untuk horizon satu jam. Baseline tersebut adalah nilai terakhir, nilai kemarin ($t-24$), dan nilai minggu lalu ($t-168$). Seluruh nilai model dilaporkan sebagai rata-rata $plus.minus$ simpangan baku dari tiga seed (0, 1, 2) pada @tab:baseline_acuan.

#figure(
  caption: [Baseline naif dan konfigurasi acuan di Duomo ($H=1$ jam, rata-rata $plus.minus$ simpangan baku, 3 seed)],
  placement: top,
  table(
    columns: (1.4fr, 0.6fr, 1.1fr, 1.1fr, 1fr, 1.1fr),
    align: (left, center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Metode / Model*], [*Param*], [*Val MAE*], [*Test MAE*], [*Test MAPE*], [*Natal MAE*]),
    table.hline(stroke: 0.5pt),
    [Naif: nilai terakhir], [0], [662,6], [600,9], [18,4%], [431,2],
    [Naif: kemarin], [0], [595,3], [552,2], [23,8%], [921,5],
    [Naif: minggu lalu], [0], [492,8], [467,6], [19,9%], [1.426,2],
    table.hline(stroke: 0.3pt),
    [*ANN* (Acuan)], [6.497], [248,9 $plus.minus$ 8,9], [309,9 $plus.minus$ 5,9], [11,3 $plus.minus$ 0,8%], [680,1 $plus.minus$ 52,0],
    [*RNN* (Acuan)], [5.305], [206,1 $plus.minus$ 7,4], [229,6 $plus.minus$ 5,1], [8,5 $plus.minus$ 0,3%], [421,2 $plus.minus$ 2,4],
    [*LSTM* (Acuan)], [5.578], [230,5 $plus.minus$ 12,2], [273,6 $plus.minus$ 25,4], [9,1 $plus.minus$ 1,0%], [586,0 $plus.minus$ 56,8],
    [*GRU* (Acuan)], [5.397], [207,5 $plus.minus$ 3,8], [237,2 $plus.minus$ 9,3], [8,0 $plus.minus$ 0,7%], [468,2 $plus.minus$ 21,8],
    table.hline(),
  ),
) <tab:baseline_acuan>

Pada minggu test, baseline terbaik adalah naif minggu lalu (467,6), diikuti naif kemarin (552,2) dan nilai terakhir (600,9). Seluruh model mengungguli baseline tersebut: RNN mencapai test MAE 229,6 $plus.minus$ 5,1 (50,9% lebih rendah), disusul GRU 237,2 $plus.minus$ 9,3, LSTM 273,6 $plus.minus$ 25,4, dan ANN 309,9 $plus.minus$ 5,9. MAPE model berada pada 8,0%--11,3%, jauh di bawah baseline (18,4%--23,8%). Pada minggu Natal, RNN tetap paling tangguh (421,2 $plus.minus$ 2,4) dan sedikit lebih baik dari naif nilai terakhir (431,2), sedangkan ANN (680,1) dan LSTM (586,0) mengalami degradasi terbesar. Pola ini menunjukkan bahwa keunggulan model rekuren muncul baik pada kondisi reguler maupun saat terjadi pergeseran distribusi.

== Bagian A — Ablasi Wajib

Ablasi dilakukan dengan protokol satu faktor pada satu waktu dari konfigurasi acuan (@tab:acuan). Setiap konfigurasi dijalankan dengan tiga seed, dan pemilihan nilai terbaik memakai val MAE; tabel serta gambar pada bagian ini menampilkan test MAE untuk melihat transfer ke data uji.

=== A1. Pengaruh Panjang Jendela Observasi ($W$)

Eksperimen A1 memvariasikan $W in {6, 12, 24, 48, 168}$ jam. Hasil test MAE disajikan pada @tab:tabel_A1_W; sel tebal menandai konfigurasi yang dipilih berdasarkan val MAE.

#figure(
  caption: [Pengaruh panjang jendela $W$ (jam) terhadap test MAE (rata-rata $plus.minus$ SD, 3 seed). Sel tebal = konfigurasi terpilih berdasarkan val MAE.],
  table(
    columns: (1.5fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*$W$ (jam)*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [6], [*269,4 $plus.minus$ 16,8*], [228,6 $plus.minus$ 5,4], [*276,4 $plus.minus$ 14,7*], [249,8 $plus.minus$ 1,4],
    [12], [308,8 $plus.minus$ 11,6], [233,2 $plus.minus$ 11,2], [302,7 $plus.minus$ 17,4], [246,1 $plus.minus$ 13,5],
    [24], [309,9 $plus.minus$ 5,9], [229,6 $plus.minus$ 5,1], [273,6 $plus.minus$ 25,4], [237,2 $plus.minus$ 9,3],
    [48], [333,1 $plus.minus$ 20,2], [*224,5 $plus.minus$ 11,7*], [304,4 $plus.minus$ 27,1], [*237,1 $plus.minus$ 10,6*],
    [168], [402,0 $plus.minus$ 12,5], [233,5 $plus.minus$ 4,8], [292,8 $plus.minus$ 20,0], [237,2 $plus.minus$ 10,6],
    table.hline(),
  ),
) <tab:tabel_A1_W>

ANN sangat sensitif terhadap $W$: test MAE naik dari 269,4 pada $W=6$ menjadi 402,0 pada $W=168$, seiring pertumbuhan parameter dari 2.465 menjadi 38.753. Val MAE juga memilih $W=6$ (211,5 $plus.minus$ 6,2). Sebaliknya, RNN dan GRU relatif stabil karena jumlah parameternya konstan; keduanya optimum pada $W=48$ dengan test MAE 224,5 $plus.minus$ 11,7 dan 237,1 $plus.minus$ 10,6. LSTM memilih $W=6$ berdasarkan val (227,1 $plus.minus$ 4,3), tetapi pada test nilai terendah justru $W=24$ (273,6 $plus.minus$ 25,4), hanya 2,8 lebih rendah dari $W=6$. Perbedaan kecil ini menunjukkan bahwa pemilihan berbasis val tidak selalu transfer sempurna ke test.

=== A2. Pengaruh Ukuran Hidden

Ukuran hidden ${16, 32, 64, 128}$ diuji pada keempat model. Kapasitas 16 unit menyebabkan underfitting (val MAE 216,8--257,6), sedangkan 128 unit memberi val MAE terbaik pada semua model: ANN 233,8 $plus.minus$ 1,9, LSTM 207,1 $plus.minus$ 8,4, dan GRU 188,7 $plus.minus$ 4,2. Pada test, GRU 128 mencapai 220,3 dan LSTM 128 mencapai 245,6. RNN mencapai titik jenuh pada 64 unit (val 207,2 $plus.minus$ 12,8); menaikkannya ke 128 tidak memperbaiki hasil (207,7 $plus.minus$ 7,2). Peningkatan kapasitas juga membengkakkan parameter: LSTM 70.273, GRU 52.737, ANN 38.273, dan RNN 17.665. Dinamika test MAE ditunjukkan pada @fig:ieee_col_A2_hidden.

#figure(
  image("../gambar/ieee_col_A2_hidden.png", width: 90%),
  caption: [Test MAE terhadap ukuran hidden di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A2_hidden>

=== A3. Pengaruh Jumlah Lapisan

Kedalaman ${1, 2, 3}$ lapisan memberi pengaruh berbeda per arsitektur. ANN hampir tidak berubah (val 240,9--248,9), sehingga penambahan lapisan tidak memberi abstraksi berarti. RNN terbaik pada satu lapisan (206,1 $plus.minus$ 7,4) dan memburuk pada tiga lapisan (225,1 $plus.minus$ 12,7). GRU terbaik pada dua lapisan (203,3 $plus.minus$ 9,6) dan sedikit menurun pada tiga lapisan (212,2 $plus.minus$ 15,9). Kasus terburuk terjadi pada LSTM tiga lapisan: val MAE melonjak dari 230,5 menjadi 338,9 $plus.minus$ 16,9 dan test MAE mencapai 412,6, konsisten dengan kesulitan propagasi gradien pada tumpukan gerbang.

=== A4. Pengaruh Learning Rate

Learning rate ${10^(-4), 10^(-3), 10^(-2)}$ menguji stabilitas optimasi Adam. Pada $10^(-4)$, seluruh model menyentuh 300 epoch tanpa early stopping dan mengalami underfitting (val 285,0--399,4). Nilai $10^(-3)$ optimal bagi ANN (248,9), RNN (206,1), dan GRU (207,5). Sebaliknya, LSTM dan GRU bergerbang lebih cepat keluar dari plateau pada $10^(-2)$: LSTM mencapai val 215,9 $plus.minus$ 14,2 (test 225,8) dan GRU test 215,7, sedangkan RNN justru sedikit memburuk (val 226,7). Dengan demikian, laju kecil menghambat konvergensi, sedangkan laju besar hanya menguntungkan model bergerbang. Tren test MAE antar-learning rate ditunjukkan pada @fig:ieee_col_A4_lr.

#figure(
  image("../gambar/ieee_col_A4_lr.png", width: 90%),
  caption: [Test MAE terhadap learning rate di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A4_lr>

=== A5. Pengaruh Kelompok Fitur

Empat kelompok fitur diuji: net, net+call+sms, net+waktu, dan semua fitur. Kelompok net saja memberi val MAE tertinggi untuk RNN (245,2), LSTM (266,2), dan GRU (264,6), dengan test MAE 254,1--284,1. Penambahan call+sms menurunkan val dan test RNN menjadi 224,1 dan 227,6, serta LSTM menjadi 243,7 dan 262,7. Fitur waktu memberi perbaikan val terbesar pada ANN (260,5 menjadi 246,0) dan GRU (264,6 menjadi 213,2); pada test, GRU membaik dari 270,5 menjadi 239,7, tetapi ANN justru memburuk dari 271,8 menjadi 296,4. Kelompok semua fitur memberi val MAE terbaik untuk RNN (206,1), LSTM (230,5), dan GRU (207,5), serta test GRU terbaik (237,2). Tidak ada satu kelompok yang unggul mutlak: fitur waktu dan kanal call/sms sama-sama berguna, dan ANN paling sensitif terhadap penambahan fitur. Perbandingan test MAE keempat kelompok fitur disajikan pada @fig:ieee_col_A5_fitur.

#figure(
  image("../gambar/ieee_col_A5_fitur.png", width: 90%),
  caption: [Test MAE untuk empat kelompok fitur di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A5_fitur>

== Bagian B — Ablasi Pilihan

Dua faktor tambahan diuji dengan tiga seed: dropout (B2) dan horizon peramalan (B6).

=== B2. Dropout

Hipotesis awal: dropout moderat ($p=0,2$) meningkatkan generalisasi, sedangkan $p=0,5$ menyebabkan underfitting. Hasilnya, $p=0,2$ menurunkan test MAE GRU dari 237,2 menjadi 225,0 (Natal 468,2 menjadi 429,7) dan val MAE dari 207,5 menjadi 203,9; LSTM juga membaik pada test (273,6 menjadi 264,6). Namun, ANN memburuk dari 309,9 menjadi 330,3 dan RNN dari 229,6 menjadi 260,3. Pada $p=0,5$, seluruh model memburuk (test MAE ANN 411,6, RNN 260,2, LSTM 289,1, GRU 273,6). Hipotesis hanya sebagian didukung: manfaat dropout terbatas pada model bergerbang, terutama GRU, sedangkan underfitting pada dropout agresif terbukti pada semua model. Perbandingan test MAE antar-tingkat dropout ditunjukkan pada @fig:ieee_col_B2_dropout.

#figure(
  image("../gambar/ieee_col_B2_dropout.png", width: 90%),
  caption: [Test MAE terhadap tingkat dropout pada empat model di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_B2_dropout>

=== B6. Horizon Peramalan

Hipotesis awal: MAE meningkat monoton seiring horizon, keunggulan terhadap baseline mengecil pada horizon panjang, dan model rekuren lebih baik daripada ANN. Hasil test MAE meningkat dari 229,6--309,9 pada $H=1$ menjadi 395,7--433,4 pada $H=6$, lalu 486,4--526,8 pada $H=24$; seluruh model pada $H=24$ kalah dari baseline naif minggu lalu (466,1). Pada $H=24$, model rekuren (486,4--503,3) mengungguli ANN (526,8), meskipun pada $H=6$ ANN justru yang terbaik (395,7). MAE Natal pada $H=24$ memburuk ke 1.101,6--1.199,4. Tren ini ditunjukkan pada @fig:ieee_col_B6_horizon, dan hipotesis didukung sepenuhnya.

#figure(
  image("../gambar/ieee_col_B6_horizon.png", width: 90%),
  caption: [Test MAE terhadap horizon peramalan pada empat model di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_B6_horizon>
