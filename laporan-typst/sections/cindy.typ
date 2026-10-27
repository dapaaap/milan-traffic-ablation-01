#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

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

Eksperimen A1 menguji pengaruh panjang konteks historis masukan dengan memvariasikan $W in {6, 12, 24, 48, 168}$ jam (mencakup rentang dari seperempat hari hingga satu minggu penuh). Hasil pengukuran _validation_ MAE disajikan pada @tab:tabel_A1_W, dan tren perbandingannya diilustrasikan pada @fig:ieee_col_A1_W.

#figure(
  caption: [Pengaruh panjang jendela $W$ (jam) terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed)],
  table(
    columns: (1.5fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*$W$ (jam)*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [6], [*211,5 $plus.minus$ 6,2*], [215,5 $plus.minus$ 4,1], [*227,1 $plus.minus$ 4,3*], [212,6 $plus.minus$ 11,5],
    [12], [238,5 $plus.minus$ 4,5], [206,7 $plus.minus$ 6,2], [235,6 $plus.minus$ 2,0], [208,9 $plus.minus$ 10,4],
    [24], [248,9 $plus.minus$ 8,9], [206,1 $plus.minus$ 7,4], [230,5 $plus.minus$ 12,2], [207,5 $plus.minus$ 3,8],
    [48], [262,6 $plus.minus$ 3,8], [*200,1 $plus.minus$ 5,3*], [249,1 $plus.minus$ 21,8], [*206,7 $plus.minus$ 5,0*],
    [168], [298,2 $plus.minus$ 18,2], [204,8 $plus.minus$ 10,2], [241,4 $plus.minus$ 8,1], [206,7 $plus.minus$ 5,1],
    table.hline(),
  ),
) <tab:tabel_A1_W>

#figure(
  image("../gambar/ieee_col_A1_W.png", width: 90%),
  caption: [Pengaruh panjang jendela $W$ terhadap performa model di Duomo.],
) <fig:ieee_col_A1_W>

Dari hasil eksperimen terungkap dua pola perilaku yang sangat kontras:
1. *Degradasi Monotonik pada Feedforward ANN:* ANN memperlihatkan sensitivitas negatif yang tajam terhadap bertambahnya panjang jendela. Val MAE terendah ANN diraih pada $W = 6$ jam ($211,5 plus.minus 6,2$; test MAE 269,4), lalu membengkak seiring kenaikan $W$ hingga puncaknya pada $W = 168$ jam ($298,2 plus.minus 18,2$; test MAE 402,0). Karena ANN meratakan matriks jendela observasi, penambahan panjang jendela melipatgandakan jumlah parameter secara drastis (dari 2.465 parameter pada $W=6$ melonjak ke 38.753 parameter pada $W=168$ dengan input layer berdimensi $168 times 7 = 1.176$). Akibatnya, pada sampel data latih yang terbatas (672 sampel), ANN terjerumus ke dalam fenomena _curse of dimensionality_ dan _overfitting_ yang parah.
2. *Ketahanan Jangka Panjang pada Model Rekuren:* Sebaliknya, model rekuren memiliki parameter yang konstan terhadap dimensi waktu ($O(1)$ terhadap $W$, yakni RNN tetap 5.305 dan GRU 5.397 parameter). Simple RNN dan GRU mencapai titik optimum pada jendela multi-hari $W = 48$ jam (2 hari penuh), dengan val MAE masing-masing sebesar *$200,1 plus.minus 5,3$* (test MAE 224,5) dan *$206,7 plus.minus 5,0$* (test MAE 237,1). Pada jendela satu minggu penuh ($W = 168$), performa RNN ($204,8 plus.minus 10,2$) dan GRU ($206,7 plus.minus 5,1$) tetap sangat stabil dan tidak mengalami lonjakan error seperti ANN. Hal ini membuktikan keunggulan intrinsik mekanisme pemrosesan sekuensial rekuren dalam memfilter sinyal deret waktu panjang tanpa membebani kompleksitas bobot.
3. *Perilaku LSTM:* LSTM mencapai val MAE optimal pada jendela pendek $W = 6$ jam ($227,1 plus.minus 4,3$). Pada jendela yang lebih panjang ($W=48$), variansi hasil LSTM meningkat cukup lebar ($plus.minus 21,8$) akibat kesulitan algoritma optimasi dalam menyeimbangkan gradien tiga pasang gerbang pada sekuens panjang tanpa koneksi residual.

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
  caption: [Pengaruh variasi ukuran hidden terhadap val MAE.],
) <fig:ieee_col_A2_hidden>

#figure(
  image("../gambar/ieee_col_A2_param.png", width: 90%),
  caption: [Pertumbuhan parameter model terhadap ukuran hidden.],
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
  caption: [Pengaruh variasi jumlah lapisan terhadap performa model.],
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
  caption: [Pengaruh variasi learning rate terhadap performa model.],
) <fig:ieee_col_A4_lr>

Hasil komparasi laju pembelajaran menunjukkan dinamika optimasi sebagai berikut:
1. *Kegagalan Konvergensi pada Laju Terlalu Kecil ($lr = 10^(-4)$):* Pada nilai $10^(-4)$, seluruh model (ANN, RNN, LSTM, GRU) menyentuh batas maksimum 300 epoch tanpa sekalipun memicu _early stopping_ (rata-rata epoch tepat 300,0). Langkah pembaruan bobot yang terlampau lambat mengakibatkan model mengalami _severe underfitting_ dan gagal mencapai lembah fungsi rugi dalam anggaran komputasi yang diberikan, sehingga val MAE melonjak sangat tinggi (LSTM $399,4 plus.minus 25,0$; GRU $398,4 plus.minus 8,6$; ANN $295,3$; RNN $285,0$).
2. *Keseimbangan Ideal pada Nilai Acuan ($lr = 10^(-3)$):* Nilai acuan $10^(-3)$ merupakan konfigurasi optimal bagi ANN ($248,9 plus.minus 8,9$), RNN ($206,1 plus.minus 7,4$), dan GRU ($207,5 plus.minus 3,8$). Pada nilai ini, mekanisme adaptif Adam berhasil memandu model menuju konvergensi stabil sebelum dihentikan oleh _early stopping_ secara efisien pada epoch 106--194.
3. *Kecepatan Konvergensi dan Keunggulan pada Model Bergerbang ($lr = 10^(-2)$):* Pada laju besar $10^(-2)$, seluruh arsitektur berkonvergensi secara sangat kilat, di mana _early stopping_ menghentikan pelatihan hanya dalam 61--68 epoch. Menariknya, $lr = 10^(-2)$ menjadi konfigurasi terbaik bagi LSTM dengan penurunan val MAE signifikan ke level *$215,9 plus.minus 14,2$* (test MAE 225,8) serta mempertahankan performa prima pada GRU ($208,2 plus.minus 5,6$; test MAE 215,7). Ukuran langkah gradien yang lebih besar membantu mekanisme gerbang nonlinier sigmoid dan tanh keluar dengan cepat dari plateau jenuh pada awal inisialisasi bobot. Namun untuk Simple RNN tanpa gerbang, laju besar ini memicu sedikit instabilitas dan osilasi di sekitar kurva optimum sehingga val MAE sedikit terdegradasi ke $226,7 plus.minus 6,7$.

=== A5. Pengaruh Kelompok Fitur Masukan
#petunjuk[Laporkan faktor A5: net, net+call+sms, net+waktu, semua fitur. Tuliskan perbandingan val MAE dan interpretasi dampaknya.]

== Bagian B — Ablasi Pilihan
#petunjuk[Jelaskan dua faktor tambahan pilihan kelompok (misalnya dropout dan horizon), hipotesis sebelum eksperimen, hasil pengukuran, dan apakah hasil mendukung hipotesis.]
