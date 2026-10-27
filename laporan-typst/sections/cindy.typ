= Hasil

== Bagian 0 — Baseline Naif dan Model Acuan

Evaluasi diawali dengan membandingkan performa model deep learning pada konfigurasi acuan terhadap tiga metode baseline naif tanpa parameter di lokasi Duomo (kotak 5060) dengan horizon peramalan satu jam ($H = 1$). Tiga baseline naif yang diuji mencakup:
1. *Naif nilai terakhir* (_persistence_, $hat(y)_(t) = y_(t-1)$), yang mengasumsikan trafik satu jam ke depan identik dengan nilai satu jam sebelumnya;
2. *Naif kemarin* ($hat(y)_(t) = y_(t-24)$), yang memanfaatkan siklus harian (sirkadian 24 jam); serta
3. *Naif minggu lalu* ($hat(y)_(t) = y_(t-168)$), yang memproyeksikan aktivitas trafik pada jam yang sama di hari yang sama pada minggu sebelumnya.

Hasil komparasi kinerja baseline naif dan empat arsitektur deep learning acuan (ANN, RNN, LSTM, GRU) disajikan pada @tab:baseline_acuan. Seluruh nilai model acuan dilaporkan sebagai rata-rata $plus.minus$ simpangan baku dari tiga _random seed_ (0, 1, 2).

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

=== Performa pada Kondisi Reguler (Minggu Test)

Pada periode evaluasi normal (minggu test 16--22 Desember 2013), metode baseline naif menunjukkan bahwa trafik seluler memiliki ketergantungan musiman yang kuat. Baseline naif minggu lalu menjadi metode nirparameter terkuat dengan test MAE 467,6, mengungguli naif kemarin (552,2) dan naif nilai terakhir (600,9). Hal ini mengonfirmasi bahwa pola hari kerja versus akhir pekan berulang secara reguler pada skala mingguan di pusat perkantoran Duomo.

Kendati demikian, seluruh model deep learning mampu mengungguli baseline naif terbaik secara signifikan. Model ANN acuan menurunkan test MAE menjadi 309,9 $plus.minus$ 5,9 (turun 33,7% dari naif minggu lalu). Ketiga arsitektur rekuren menunjukkan keunggulan yang lebih tajam: LSTM mencapai test MAE 273,6 $plus.minus$ 25,4 (turun 41,5%), GRU mencapai 237,2 $plus.minus$ 9,3 (turun 49,3%), dan Simple RNN mencatatkan kesalahan terendah sebesar 229,6 $plus.minus$ 5,1 (turun 50,9%). Keunggulan telak model rekuren dibanding ANN membuktikan bahwa mekanisme memori sekuensial langkah demi langkah jauh lebih efektif menangkap lintasan temporal dibanding sekadar meratakan matriks jendela observasi $W times 7$ menjadi satu vektor input pada feedforward ANN.

=== Analisis MAPE (_Mean Absolute Percentage Error_)

Metrik MAPE memberikan gambaran kesalahan relatif terhadap fluktuasi magnitudo trafik asli. Pada metode naif, MAPE berkisar antara 18,4% (nilai terakhir) hingga 23,8% (kemarin). Naif kemarin mengalami persentase kesalahan tertinggi karena pergeseran fasa jam antarhari sering memicu error relatif besar pada jam-jam sepi (dini hari).

Sebaliknya, seluruh model deep learning memangkas batas MAPE ke kisaran 8,0%--11,3%. GRU menghasilkan test MAPE paling presisi yaitu *8,0 $plus.minus$ 0,7%*, diikuti oleh RNN (8,5 $plus.minus$ 0,3%), LSTM (9,1 $plus.minus$ 1,0%), dan ANN (11,3 $plus.minus$ 0,8%). Keunggulan GRU pada metrik persentase mengindikasikan bahwa struktur gerbang _reset_ dan _update_ miliknya sangat adaptif dalam menjaga proporsi simpangan yang stabil di seluruh kontur kurva beban, baik pada saat trafik mencapai lembah di malam hari maupun puncak pada jam sibuk siang hari.

=== Perilaku pada Anomali Minggu Natal

Minggu Natal (23--29 Desember 2013) menjadi pengujian ekstrem atas ketahanan model terhadap pergeseran distribusi temporal (_distribution drift_). Karena kawasan Duomo merupakan pusat perkantoran, perbankan, dan komersial, perayaan malam dan hari Natal (24--26 Desember) memicu penurunan aktivitas kerja yang sangat tajam dibanding hari kerja normal.

Perubahan pola struktural ini menyebabkan baseline naif berbasis kalender mengalami kehancuran katastropik:
1. *Naif minggu lalu* runtuh total dengan lonjakan MAE lebih dari 200% menjadi *1.426,2* (MAPE melonjak mendekati 97%). Metode ini salah memproyeksikan beban kerja padat dari minggu sebelumnya ke hari libur perayaan Natal.
2. *Naif kemarin* turut mengalami degradasi parah hingga MAE *921,5* (MAPE 42,2%) saat transisi hari normal ke hari libur berlangsung.
3. Sebaliknya, *naif nilai terakhir* justru membaik menjadi MAE *431,2* (lebih rendah dibanding performa test regulernya 600,9). Ketika aktivitas masyarakat surut dan pola trafik bertahan pada level rendah yang datar, persistensi sesaat ($t-1$) tidak terjebak oleh asumsi musiman mingguan yang keliru.

Bagi model deep learning, tidak adanya sampel hari libur dalam data latih (11 November--8 Desember) menyebabkan seluruh model mengalami kenaikan error. Namun, arsitektur rekuren memperlihatkan daya tahan yang jauh lebih tinggi daripada ANN:
- *Simple RNN (Acuan)* menjadi model paling tangguh dengan Natal MAE terendah sebesar *421,2 $plus.minus$ 2,4* (bahkan mengungguli seluruh baseline naif, termasuk naif nilai terakhir 431,2, serta memiliki variansi antar-seed terkecil $plus.minus 2,4$).
- *GRU (Acuan)* menyusul di peringkat kedua dengan Natal MAE *468,2 $plus.minus$ 21,8*.
- Sebaliknya, *LSTM* (586,0 $plus.minus$ 56,8) dan *ANN* (680,1 $plus.minus$ 52,0) menderita degradasi drastis. Tingginya lonjakan error pada ANN disebabkan oleh ketergantungannya pada bobot statis fitur kalender (hari dalam seminggu) yang memaksakan keluaran trafik tinggi pada hari Selasa--Kamis kalender, padahal realitas aktivitas perkantoran Duomo sedang tutup total untuk libur akhir tahun.

== Bagian A — Ablasi Wajib

Pada bagian ini, dilakukan studi ablasi terkontrol menggunakan protokol _one-factor-at-a-time_ (OFAT). Setiap subbagian (A1 hingga A5) hanya memvariasikan tepat satu faktor hiperparameter secara terisolasi, sementara seluruh faktor lainnya dibekukan pada nilai konfigurasi acuan (@tab:acuan), yaitu $W = 24$ jam, horizon $H = 1$ jam, ukuran hidden acuan (ANN 32, RNN 68, LSTM 33, GRU 38), kedalaman acuan (ANN 2 lapis, rekuren 1 lapis), kelompok fitur lengkap (7 fitur), optimizer Adam dengan _learning rate_ $10^(-3)$, dan _batch size_ 64. Setiap eksperimen dijalankan secara independen pada tiga _random seed_ (0, 1, 2) untuk memisahkan dampak arsitektural dari variasi stokastik inisialisasi bobot dan pengacakan batch. Pemilihan konfigurasi terbaik didasarkan murni pada metrik _validation_ MAE guna menghindari kebocoran informasi uji (_test data leakage_).

=== A1. Pengaruh Panjang Jendela Observasi ($W$)

Eksperimen A1 menguji pengaruh panjang konteks historis masukan dengan memvariasikan $W in {6, 12, 24, 48, 168}$ jam (mencakup rentang dari seperempat hari hingga satu minggu penuh). Hasil pengukuran *test* MAE disajikan pada @tab:tabel_A1_W; sel tebal menandai konfigurasi yang terpilih berdasarkan val MAE. Tren perbandingannya diilustrasikan pada @fig:ieee_col_A1_W.

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

#figure(
  image("../gambar/ieee_col_A1_W.png", width: 90%),
  caption: [Test MAE terhadap panjang jendela $W$ untuk empat model di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A1_W>

Dari hasil eksperimen terungkap tiga pola perilaku:
1. *Degradasi Monotonik pada Feedforward ANN:* Test MAE terendah ANN diraih pada $W = 6$ jam (269,4 $plus.minus$ 16,8) dan membengkak hingga 402,0 $plus.minus$ 12,5 pada $W = 168$ jam. Val MAE juga memilih $W=6$ (211,5 $plus.minus$ 6,2). Karena ANN meratakan matriks jendela observasi, penambahan panjang jendela melipatgandakan jumlah parameter secara drastis, dari 2.465 parameter pada $W=6$ menjadi 38.753 parameter pada $W=168$ (input layer berdimensi $168 times 7 = 1.176$). Pada 672 sampel latih, kondisi ini memicu _curse of dimensionality_ dan overfitting.
2. *Ketahanan Jangka Panjang pada Model Rekuren:* Model rekuren memiliki jumlah parameter yang konstan terhadap $W$ (RNN 5.305 dan GRU 5.397). Simple RNN dan GRU mencapai val MAE terbaik pada $W = 48$ jam, masing-masing 200,1 $plus.minus$ 5,3 dan 206,7 $plus.minus$ 5,0, dengan test MAE 224,5 $plus.minus$ 11,7 dan 237,1 $plus.minus$ 10,6. Pada $W = 168$, test MAE RNN (233,5 $plus.minus$ 4,8) dan GRU (237,2 $plus.minus$ 10,6) tetap stabil. Ini menunjukkan keunggulan pemrosesan sekuensial dalam memfilter sinyal deret panjang tanpa menambah kompleksitas bobot.
3. *Perilaku LSTM:* LSTM mencapai val MAE optimal pada $W = 6$ jam (227,1 $plus.minus$ 4,3), tetapi test MAE-nya 276,4 $plus.minus$ 14,7. Pada test, nilai terendah justru diperoleh $W=24$ (273,6 $plus.minus$ 25,4), hanya berbeda 2,8 dari $W=6$. Pada $W=48$, variansi LSTM melebar hingga $plus.minus$ 27,1 akibat kesulitan optimasi tiga pasang gerbang pada sekuens panjang. Perbedaan kecil ini menunjukkan bahwa pemilihan berbasis val tidak selalu transfer sempurna ke test.

=== A2. Pengaruh Ukuran Lapisan Tersembunyi (_Hidden Units_)

Eksperimen A2 mengevaluasi kapasitas representasi dengan memvariasikan dimensi hidden state $in {16, 32, 64, 128}$. Hasil val MAE dirangkum pada @tab:tabel_A2_hidden, sedangkan visualisasi dinamika performa dan dampaknya terhadap jumlah parameter disajikan pada @fig:ieee_col_A2_hidden dan @fig:ieee_col_A2_param.

#figure(
  caption: [Pengaruh ukuran hidden terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed)],
  table(
    columns: (1.5fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Ukuran Hidden*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [16], [257,6 $plus.minus$ 28,0], [247,0 $plus.minus$ 5,8], [244,3 $plus.minus$ 18,3], [216,8 $plus.minus$ 21,2],
    [32], [248,9 $plus.minus$ 8,9], [218,7 $plus.minus$ 6,6], [241,5 $plus.minus$ 20,5], [210,2 $plus.minus$ 0,8],
    [64], [238,4 $plus.minus$ 16,5], [*207,2 $plus.minus$ 12,8*], [218,1 $plus.minus$ 1,9], [198,4 $plus.minus$ 9,2],
    [128], [*233,8 $plus.minus$ 1,9*], [207,7 $plus.minus$ 7,2], [*207,1 $plus.minus$ 8,4*], [*188,7 $plus.minus$ 4,2*],
    table.hline(),
  ),
) <tab:tabel_A2_hidden>

#figure(
  image("../gambar/ieee_col_A2_hidden.png", width: 90%),
  caption: [Test MAE terhadap ukuran hidden di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A2_hidden>

#figure(
  image("../gambar/ieee_col_A2_param.png", width: 90%),
  caption: [Jumlah parameter model terhadap ukuran hidden untuk empat arsitektur.],
) <fig:ieee_col_A2_param>

Dampak kapasitas terhadap performa dan kompleksitas komputasi model dapat dianalisis sebagai berikut:
1. *Underfitting pada Kapasitas Rendah:* Ukuran hidden 16 menghasilkan kesalahan tertinggi pada seluruh model (val MAE ANN 257,6; RNN 247,0; LSTM 244,3; GRU 216,8). Kapasitas memori 16 unit terbukti terlalu sempit untuk mengekstraksi dinamika multivariat gabungan dari 7 fitur masukan.
2. *Penskalaan Kuadratik Parameter:* Jumlah parameter sel rekuren bertumbuh secara kuadratik terhadap ukuran hidden ($O(h^2)$). Pada hidden 128, parameter LSTM melonjak drastis hingga 70.273 parameter, GRU mencapai 52.737 parameter, ANN 38.273 parameter, dan Simple RNN 17.665 parameter.
3. *Keuntungan Kapasitas Besar dan Titik Jenuh:* Peningkatan hidden hingga 128 secara konsisten menurunkan val MAE pada semua arsitektur. GRU 128 mencetak skor validasi terendah di seluruh studi ablasi (*$188,7 plus.minus 4,2$*; test MAE 220,3), diikuti LSTM 128 (*$207,1 plus.minus 8,4$*; test MAE 245,6), dan ANN 128 (*$233,8 plus.minus 1,9$*). Pada RNN, ukuran 64 unit ($207,2 plus.minus 12,8$) sudah mencapai titik jenuh, di mana pelipatgandaan ke 128 unit tidak memberikan penurunan error yang signifikan ($207,7 plus.minus 7,2$). Kendati kapasitas 128 unit memberi representasi non-linear yang sangat ekspresif, pembengkakan parameter ini meningkatkan risiko overfitting jika tanpa regularisasi.

=== A3. Pengaruh Kedalaman Lapisan (_Number of Layers_)

Eksperimen A3 menguji kedalaman hierarki representasi dengan memvariasikan jumlah lapisan tersembunyi $in {1, 2, 3}$. Hasil pengukuran disajikan pada @tab:tabel_A3_layers dan @fig:ieee_col_A3_layers.

#figure(
  caption: [Pengaruh jumlah lapisan terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed)],
  table(
    columns: (1.5fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Jumlah Lapisan*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [1], [*240,9 $plus.minus$ 7,5*], [*206,1 $plus.minus$ 7,4*], [*230,5 $plus.minus$ 12,2*], [207,5 $plus.minus$ 3,8],
    [2], [248,9 $plus.minus$ 8,9], [207,3 $plus.minus$ 9,1], [254,8 $plus.minus$ 14,5], [*203,3 $plus.minus$ 9,6*],
    [3], [244,9 $plus.minus$ 5,4], [225,1 $plus.minus$ 12,7], [338,9 $plus.minus$ 16,9], [212,2 $plus.minus$ 15,9],
    table.hline(),
  ),
) <tab:tabel_A3_layers>

#figure(
  image("../gambar/ieee_col_A3_layers.png", width: 90%),
  caption: [Test MAE terhadap jumlah lapisan di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A3_layers>

Temuan krusial dari variasi kedalaman meliputi:
1. *Stabilitas Arsitektur Dangkal pada Feedforward ANN:* Penambahan lapisan ANN dari 1 ke 2 dan 3 lapis menghasilkan rentang val MAE yang hampir identik ($240,9$ hingga $248,9$). Karena deret waktu ini berpusat pada target univariat tunggal, penumpukan lapisan feedforward tidak memberikan abstraksi hierarkis tambahan yang bermakna.
2. *Optimum Dangkal pada RNN dan GRU:* Simple RNN mencapai performa terbaik pada 1 lapisan rekuren ($206,1 plus.minus 7,4$), dan mulai mengalami peningkatan galat pada 3 lapisan ($225,1 plus.minus 12,7$). GRU meraih hasil terbaik pada 2 lapisan ($203,3 plus.minus 9,6$), sebelum terdegradasi pada 3 lapisan ($212,2 plus.minus 15,9$).
3. *Kasus Ekstrem Kegagalan LSTM Tiga Lapis:* Fenomena paling mencolok terjadi pada arsitektur LSTM, di mana penambahan kedalaman menjadi 3 lapisan memicu degradasi performa yang katastropik. Val MAE LSTM melonjak drastis dari *$230,5 plus.minus 12,2$* (1 lapis) menjadi *$338,9 plus.minus 16,9$* (3 lapis), sementara Test MAE anjlok ke level *412,6*. Fenomena ini disebabkan oleh hambatan propagasi balik gradien (_vanishing gradients_) yang berlipat ganda saat melintasi tiga tumpukan gerbang rekuren tanpa jalur koneksi _skip-connection_ / residual. Dikombinasikan dengan ukuran dataset latih yang terbatas (672 jam), model 3-lapis LSTM terjebak dalam minimum lokal yang buruk. Hal ini membuktikan bahwa untuk peramalan trafik seluler berskala data moderat, model rekuren berarsitektur dangkal (1--2 lapis) jauh lebih unggul dan mudah dilatih dibanding jaringan dalam (_deep recurrent networks_).

=== A4. Pengaruh Laju Pembelajaran (_Learning Rate_)

Eksperimen A4 menguji stabilitas dan kecepatan konvergensi terhadap learning rate optimizer Adam dengan variasi $lr in {10^(-4), 10^(-3), 10^(-2)}$. Hasil val MAE dirangkum pada @tab:tabel_A4_lr, dan dinamika performa divisualisasikan pada @fig:ieee_col_A4_lr.

#figure(
  caption: [Pengaruh learning rate terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed)],
  table(
    columns: (1.5fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Learning Rate*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [$10^(-4)$], [295,3 $plus.minus$ 4,6], [285,0 $plus.minus$ 13,7], [399,4 $plus.minus$ 25,0], [398,4 $plus.minus$ 8,6],
    [$10^(-3)$], [*248,9 $plus.minus$ 8,9*], [*206,1 $plus.minus$ 7,4*], [230,5 $plus.minus$ 12,2], [*207,5 $plus.minus$ 3,8*],
    [$10^(-2)$], [261,8 $plus.minus$ 16,6], [226,7 $plus.minus$ 6,7], [*215,9 $plus.minus$ 14,2*], [208,2 $plus.minus$ 5,6],
    table.hline(),
  ),
) <tab:tabel_A4_lr>

#figure(
  image("../gambar/ieee_col_A4_lr.png", width: 90%),
  caption: [Test MAE terhadap learning rate di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A4_lr>

Hasil komparasi laju pembelajaran menunjukkan dinamika optimasi sebagai berikut:
1. *Kegagalan Konvergensi pada Laju Terlalu Kecil ($lr = 10^(-4)$):* Pada nilai $10^(-4)$, seluruh model (ANN, RNN, LSTM, GRU) menyentuh batas maksimum 300 epoch tanpa sekalipun memicu _early stopping_ (rata-rata epoch tepat 300,0). Langkah pembaruan bobot yang terlampau lambat mengakibatkan model mengalami _severe underfitting_ dan gagal mencapai lembah fungsi rugi dalam anggaran komputasi yang diberikan, sehingga val MAE melonjak sangat tinggi (LSTM $399,4 plus.minus 25,0$; GRU $398,4 plus.minus 8,6$; ANN $295,3$; RNN $285,0$).
2. *Keseimbangan Ideal pada Nilai Acuan ($lr = 10^(-3)$):* Nilai acuan $10^(-3)$ merupakan konfigurasi optimal bagi ANN ($248,9 plus.minus 8,9$), RNN ($206,1 plus.minus 7,4$), dan GRU ($207,5 plus.minus 3,8$). Pada nilai ini, mekanisme adaptif Adam berhasil memandu model menuju konvergensi stabil sebelum dihentikan oleh _early stopping_ secara efisien pada rata-rata epoch 106--194.
3. *Kecepatan Konvergensi dan Keunggulan pada Model Bergerbang ($lr = 10^(-2)$):* Pada laju besar $10^(-2)$, seluruh arsitektur berkonvergensi secara sangat kilat, di mana _early stopping_ menghentikan pelatihan hanya dalam rata-rata 62--68 epoch. Menariknya, $lr = 10^(-2)$ menjadi konfigurasi terbaik bagi LSTM dengan penurunan val MAE signifikan ke level *$215,9 plus.minus 14,2$* (test MAE 225,8) serta mempertahankan performa prima pada GRU ($208,2 plus.minus 5,6$; test MAE 215,7). Ukuran langkah gradien yang lebih besar membantu mekanisme gerbang nonlinier sigmoid dan tanh keluar dengan cepat dari plateau jenuh pada awal inisialisasi bobot. Namun untuk Simple RNN tanpa gerbang, laju besar ini memicu sedikit instabilitas dan osilasi di sekitar kurva optimum sehingga val MAE sedikit terdegradasi ke $226,7 plus.minus 6,7$.

=== A5. Pengaruh Kelompok Fitur Masukan

Eksperimen A5 memvariasikan komposisi fitur masukan: net saja, net+call+sms, net+waktu, dan semua fitur. Hasil val MAE dirangkum pada @tab:tabel_A5_fitur, sedangkan test MAE divisualisasikan pada @fig:ieee_col_A5_fitur.

#figure(
  caption: [Pengaruh kelompok fitur terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed). Sel tebal = nilai terbaik per model.],
  table(
    columns: (1.7fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Kelompok Fitur*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [net], [260,5 $plus.minus$ 7,0], [245,2 $plus.minus$ 5,8], [266,2 $plus.minus$ 5,7], [264,6 $plus.minus$ 7,0],
    [net+call+sms], [259,9 $plus.minus$ 5,2], [224,1 $plus.minus$ 2,3], [243,7 $plus.minus$ 7,1], [231,8 $plus.minus$ 12,6],
    [net+waktu], [*246,0 $plus.minus$ 9,8*], [223,0 $plus.minus$ 9,5], [231,1 $plus.minus$ 4,3], [213,2 $plus.minus$ 18,2],
    [semua], [248,9 $plus.minus$ 8,9], [*206,1 $plus.minus$ 7,4*], [*230,5 $plus.minus$ 12,2*], [*207,5 $plus.minus$ 3,8*],
    table.hline(),
  ),
) <tab:tabel_A5_fitur>

#figure(
  image("../gambar/ieee_col_A5_fitur.png", width: 90%),
  caption: [Test MAE untuk empat kelompok fitur di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_A5_fitur>

Empat temuan utama dari variasi fitur:
1. *Target univariat tidak memadai.* Kelompok net saja memberi val MAE tertinggi untuk RNN (245,2), LSTM (266,2), dan GRU (264,6). Pada test, net saja menghasilkan MAE RNN 254,1, LSTM 284,1, dan GRU 270,5, lebih tinggi daripada kombinasi yang menyertakan kanal lain.
2. *Kanal call dan sms konsisten membantu RNN dan LSTM.* Penambahan call+sms menurunkan val MAE RNN dari 245,2 menjadi 224,1 dan LSTM dari 266,2 menjadi 243,7. Pada test, penurunan yang setara terlihat dari 254,1 menjadi 227,6 (RNN) dan 284,1 menjadi 262,7 (LSTM).
3. *Fitur waktu memberi perbaikan val terbesar pada ANN dan GRU.* Kelompok net+waktu menurunkan val MAE ANN dari 260,5 menjadi 246,0 dan GRU dari 264,6 menjadi 213,2. Pada test, GRU membaik dari 270,5 menjadi 239,7, tetapi ANN justru memburuk dari 271,8 menjadi 296,4. Untuk ANN, nilai test terbaik diperoleh dengan net saja (271,8), sedangkan val terbaiknya dengan net+waktu, indikasi overfit pada fitur tambahan.
4. *Kombinasi semua fitur paling konsisten untuk model rekuren.* Kelompok semua fitur memberi val MAE terbaik untuk RNN (206,1), LSTM (230,5), dan GRU (207,5). Pada test, GRU tetap terbaik dengan semua fitur (237,2), sedangkan RNN dan LSTM sedikit lebih baik dengan net+call+sms (227,6 dan 262,7).

Secara keseluruhan tidak ada satu kelompok fitur yang unggul mutlak. Fitur waktu dan kanal call/sms sama-sama berguna, dan kombinasi semua fitur paling konsisten untuk model rekuren; ANN lebih sensitif terhadap penambahan fitur.

== Bagian B — Ablasi Pilihan

Bagian ini menguji dua faktor tambahan yang dipilih sebelum eksperimen dijalankan, yaitu dropout (B2) dan horizon peramalan (B6). Keduanya diuji pada empat model dengan tiga random seed, sementara faktor lain dipertahankan pada konfigurasi acuan.

=== B2. Dropout

*Hipotesis.* Dropout moderat ($p = 0,2$) meningkatkan generalisasi dibandingkan tanpa dropout ($p = 0$), sedangkan dropout agresif ($p = 0,5$) menyebabkan underfitting dan menaikkan error.

#figure(
  image("../gambar/ieee_col_B2_dropout.png", width: 90%),
  caption: [Test MAE terhadap tingkat dropout pada empat model di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_B2_dropout>

*Hasil.* Dropout 0,2 menurunkan test MAE GRU dari 237,2 menjadi 225,0 (Natal 468,2 menjadi 429,7) dan LSTM dari 273,6 menjadi 264,6. Val MAE GRU juga membaik dari 207,5 menjadi 203,9. Sebaliknya, ANN memburuk dari 309,9 menjadi 330,3 dan RNN dari 229,6 menjadi 260,3. Dropout 0,5 menaikkan error seluruh model, dengan test MAE ANN 411,6, RNN 260,2, LSTM 289,1, dan GRU 273,6. Hasil lengkap terlihat pada @fig:ieee_col_B2_dropout.

*Status hipotesis.* Sebagian didukung. Manfaat dropout moderat hanya muncul pada model bergerbang, terutama GRU; klaim bahwa dropout selalu meningkatkan generalisasi tidak terbukti. Sebaliknya, underfitting pada $p = 0,5$ terbukti pada semua model.

=== B6. Horizon Peramalan

*Hipotesis.* MAE meningkat monoton seiring bertambahnya horizon ($H=1 < H=6 < H=24$). Pada $H=1$, model neural network mengungguli baseline naif; pada $H=24$, keunggulannya mengecil, dan model rekuren diprediksi lebih baik daripada ANN.

#figure(
  image("../gambar/ieee_col_B6_horizon.png", width: 90%),
  caption: [Test MAE terhadap horizon peramalan pada empat model di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_B6_horizon>

*Hasil.* Test MAE meningkat monoton pada semua model. Pada $H=1$, nilai berkisar 229,6--309,9 dan seluruh model mengungguli baseline naif terbaik (467,6). Pada $H=6$, ANN 395,7, RNN 427,6, LSTM 408,3, dan GRU 433,4. Pada $H=24$, ANN 526,8, RNN 486,4, LSTM 496,1, dan GRU 503,3; seluruh model justru kalah dari baseline naif minggu lalu (466,1). Pada horizon ini model rekuren mengungguli ANN, meskipun pada $H=6$ ANN masih yang terbaik. MAE Natal pada $H=24$ memburuk ke rentang 1.101,6--1.199,4. Tren lengkapnya ditunjukkan pada @fig:ieee_col_B6_horizon.

*Status hipotesis.* Didukung sepenuhnya untuk monotonisitas dan memburuknya keunggulan pada horizon panjang. Prediksi bahwa model rekuren mengungguli ANN juga terkonfirmasi pada $H=24$, tetapi tidak pada $H=6$.
