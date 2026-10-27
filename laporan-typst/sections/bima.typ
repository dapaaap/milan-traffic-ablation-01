== Bagian C — Konfigurasi Terbaik

Berdasarkan hasil studi ablasi individual pada Bagian A dan B, konfigurasi terbaik untuk masing-masing arsitektur dipilih secara ketat hanya menggunakan metrik *validation MAE* terendah (@tab:tabel_C_terbaik_vs_acuan). Pemilihan berbasis validasi ini merefleksikan praktik perancangan model di dunia nyata untuk menghindari kebocoran data uji (*test leakage*). Horizon peramalan tetap dipertahankan $H = 1$ jam agar evaluasi tetap setara secara langsung dengan konfigurasi acuan standar. 

Parameter terbaik yang digabungkan per model meliputi:
- *ANN Terbaik:* Jendela pendek $W = 6$ jam, 1 lapisan tersembunyi dengan kapasitas besar (128 unit), dan kelompok fitur `net+waktu`. Kombinasi ini memangkas jumlah parameter menjadi 4.097 (turun 36,9% dari acuan 6.497) sekaligus mengeliminasi derau fluktuasi panggilan/SMS pada matriks masukan yang diratakan.
- *RNN Terbaik:* Jendela observasi diperpanjang menjadi $W = 48$ jam (2 siklus sirkadian 24 jam penuh), mempertahankan kapasitas acuan (hidden 68 unit, 1 lapisan, 5.305 parameter), dengan seluruh 7 fitur multimodal.
- *LSTM Terbaik:* Jendela lokal pendek $W = 6$ jam, kapasitas memori besar (hidden 128 unit), 1 lapisan, dan _learning rate_ lebih agresif $lr = 10^(-2)$ untuk mempercepat pelolosan dari plateau gerbang non-linear. Jumlah parameter meningkat menjadi 70.273.
- *GRU Terbaik:* Jendela $W = 48$ jam, 2 lapisan bertumpuk dengan kapasitas 128 unit, serta regulasi dropout moderat $p = 0,2$ pada seluruh 7 fitur masukan, dengan total 151.809 parameter.

#figure(
  caption: [Perbandingan performa konfigurasi acuan dan terbaik di Duomo ($H=1$ jam, rata-rata $plus.minus$ SD, 3 seed). Sel tebal = nilai test terbaik per model.],
  placement: top,
  table(
    columns: (1fr, 1.2fr, 1.1fr, 1.3fr, 1.3fr, 1.2fr, 1.3fr),
    align: (center, center, center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Model*], [*Konfigurasi*], [*Param*], [*Val MAE*], [*Test MAE*], [*Test MAPE*], [*Natal MAE*]),
    table.hline(stroke: 0.5pt),
    [ANN], [Acuan], [6.497], [248,9 $plus.minus$ 8,9], [309,9 $plus.minus$ 5,9], [11,3 $plus.minus$ 0,8%], [680,1 $plus.minus$ 52,0],
    [ANN], [*Terbaik*], [4.097], [230,1 $plus.minus$ 14,8], [*288,1 $plus.minus$ 15,6*], [9,6 $plus.minus$ 0,6%], [617,7 $plus.minus$ 36,0],
    table.hline(stroke: 0.3pt),
    [RNN], [Acuan], [5.305], [206,1 $plus.minus$ 7,4], [229,6 $plus.minus$ 5,1], [8,5 $plus.minus$ 0,3%], [421,2 $plus.minus$ 2,4],
    [RNN], [*Terbaik*], [5.305], [200,1 $plus.minus$ 5,3], [*224,5 $plus.minus$ 11,7*], [8,2 $plus.minus$ 0,8%], [404,5 $plus.minus$ 9,9],
    table.hline(stroke: 0.3pt),
    [LSTM], [Acuan], [5.578], [230,5 $plus.minus$ 12,2], [273,6 $plus.minus$ 25,4], [9,1 $plus.minus$ 1,0%], [586,0 $plus.minus$ 56,8],
    [LSTM], [*Terbaik*], [70.273], [221,3 $plus.minus$ 6,9], [*225,3 $plus.minus$ 4,0*], [7,3 $plus.minus$ 0,7%], [454,5 $plus.minus$ 36,4],
    table.hline(stroke: 0.3pt),
    [GRU], [Acuan], [5.397], [207,5 $plus.minus$ 3,8], [*237,2 $plus.minus$ 9,3*], [8,0 $plus.minus$ 0,7%], [*468,2 $plus.minus$ 21,8*],
    [GRU], [Terbaik], [151.809], [203,6 $plus.minus$ 7,3], [239,7 $plus.minus$ 9,9], [7,9 $plus.minus$ 0,4%], [497,6 $plus.minus$ 16,8],
    table.hline(),
  ),
) <tab:tabel_C_terbaik_vs_acuan>

#figure(
  image("../gambar/ieee_col_C_terbaik_vs_acuan.png", width: 90%),
  caption: [Perbandingan Test MAE antara konfigurasi acuan dan terbaik di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_C_terbaik_vs_acuan>

Hasil evaluasi pada @tab:tabel_C_terbaik_vs_acuan dan @fig:ieee_col_C_terbaik_vs_acuan menunjukkan beberapa dinamika penting:
1. *Peningkatan Signifikan pada Mayoritas Model:* Penyetelan gabungan sukses meningkatkan performa generalisasi pada 3 dari 4 arsitektur. Test MAE ANN terpangkas 21,8 poin menjadi 288,1 $plus.minus$ 15,6 (turun 7,0%), RNN turun menjadi 224,5 $plus.minus$ 11,7 (turun 2,2%), dan lonjakan paling dramatis dicapai oleh LSTM yang memangkas galat sebesar 48,3 poin dari 273,6 menjadi 225,3 $plus.minus$ 4,0 (turun 17,7%). LSTM terbaik juga mencatatkan simpangan baku antar-seed paling konsisten ($plus.minus 4,0$) serta MAPE paling presisi di antara seluruh model (*7,3 $plus.minus$ 0,7%*).
2. *Dominasi Terhadap Baseline Naif:* Seluruh konfigurasi acuan maupun terbaik mengungguli baseline naif terbaik minggu lalu (467,6) dengan margin error lebih dari 50% pada minggu uji reguler.
3. *Ketahanan Anomali Periode Natal:* Simple RNN terbaik memperlihatkan daya adaptasi tertinggi terhadap pergeseran distribusi libur akhir tahun, mencatatkan Natal MAE terendah sebesar *404,5 $plus.minus$ 9,9*, mengungguli seluruh baseline naif (naif nilai terakhir 431,2; naif kemarin 921,5; naif minggu lalu 1.426,2).
4. *Kasus Overfitting GRU Kapasitas Ekstrem:* Berbeda dari model lainnya, konfigurasi terbaik GRU justru mengalami degradasi tipis pada data uji reguler (test MAE 239,7 vs acuan 237,2) dan periode Natal (497,6 vs acuan 468,2), kendati val MAE-nya berhasil membaik (203,6 vs 207,5). Pertumbuhan parameter yang melonjak 28 kali lipat (151.809 vs 5.397) akibat penumpukan 2 lapisan rekuren 128 unit memicu penghafalan pola lokal pada set validasi yang tidak tergeneralisasi sempurna ke distribusi data uji masa depan.

== Bagian D — Uji Generalisasi

Pengujian generalisasi spasial dilakukan dengan mengevaluasi langsung konfigurasi acuan dan konfigurasi terbaik pada lokasi kelompok, yaitu Navigli (Darsena), kotak 4555 dengan kode lokasi 1 (@tab:tabel_D_generalisasi). Perbandingan test MAE kedua konfigurasi dirangkum pada @fig:ieee_col_D_generalisasi, sedangkan karakteristik pola aktivitasnya ditunjukkan pada @fig:D_pola_lokasi. Wilayah Navigli memiliki karakteristik tata ruang yang sangat kontras dibandingkan kawasan pusat perkantoran Duomo.

#figure(
  caption: [Evaluasi generalisasi di Navigli, kotak 4555 ($H=1$ jam, rata-rata $plus.minus$ SD, 3 seed)],
  placement: top,
  table(
    columns: (1fr, 1.2fr, 1.1fr, 1.3fr, 1.3fr, 1.2fr, 1.3fr),
    align: (center, center, center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Model*], [*Konfigurasi*], [*Param*], [*Val MAE*], [*Test MAE*], [*Test MAPE*], [*Natal MAE*]),
    table.hline(stroke: 0.5pt),
    [ANN], [Acuan], [6.497], [166,6 $plus.minus$ 5,3], [222,3 $plus.minus$ 27,4], [8,9 $plus.minus$ 1,1%], [664,5 $plus.minus$ 190,8],
    [ANN], [*Terbaik*], [4.097], [138,4 $plus.minus$ 1,7], [*191,1 $plus.minus$ 1,9*], [7,9 $plus.minus$ 0,1%], [607,7 $plus.minus$ 56,1],
    table.hline(stroke: 0.3pt),
    [RNN], [Acuan], [5.305], [147,3 $plus.minus$ 4,9], [*193,0 $plus.minus$ 9,7*], [7,8 $plus.minus$ 0,3%], [534,7 $plus.minus$ 148,9],
    [RNN], [Terbaik], [5.305], [148,7 $plus.minus$ 7,7], [211,7 $plus.minus$ 24,3], [8,7 $plus.minus$ 1,0%], [649,2 $plus.minus$ 92,5],
    table.hline(stroke: 0.3pt),
    [LSTM], [Acuan], [5.578], [164,3 $plus.minus$ 9,3], [247,3 $plus.minus$ 54,3], [10,0 $plus.minus$ 2,7%], [950,8 $plus.minus$ 110,9],
    [LSTM], [*Terbaik*], [70.273], [147,2 $plus.minus$ 4,2], [*210,4 $plus.minus$ 7,7*], [8,5 $plus.minus$ 0,5%], [738,4 $plus.minus$ 41,9],
    table.hline(stroke: 0.3pt),
    [GRU], [Acuan], [5.397], [149,0 $plus.minus$ 6,0], [*190,8 $plus.minus$ 6,8*], [7,8 $plus.minus$ 0,2%], [496,4 $plus.minus$ 50,9],
    [GRU], [Terbaik], [151.809], [132,5 $plus.minus$ 2,1], [223,1 $plus.minus$ 17,0], [9,6 $plus.minus$ 0,7%], [753,7 $plus.minus$ 49,8],
    table.hline(),
  ),
) <tab:tabel_D_generalisasi>

#figure(
  image("../gambar/ieee_col_D_generalisasi.png", width: 90%),
  caption: [Test MAE konfigurasi acuan dan terbaik di Navigli (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_D_generalisasi>

#figure(
  image("../gambar/D_pola_lokasi.png", width: 90%),
  caption: [Perbandingan pola aktivitas internet seluler per jam antara Duomo (kotak 5060) dan Navigli (kotak 4555).],
) <fig:D_pola_lokasi>

=== Pembalikan Peringkat Model (_Model Ranking Inversion_)

Perbandingan lintas lokasi menyingkap fenomena struktural yang sangat fundamental:
1. *Urutan Model di Duomo (Pusat Bisnis):*
   - Model acuan: $text("RNN") (229,6) < text("GRU") (237,2) < text("LSTM") (273,6) < text("ANN") (309,9)$.
   - Model terbaik: $text("RNN") (224,5) < text("LSTM") (225,3) < text("GRU") (239,7) < text("ANN") (288,1)$.
   - Di kawasan perkantoran Duomo, seluruh varian rekuren mengungguli ANN secara mutlak, di mana ANN selalu menempati peringkat terbawah.
2. *Urutan Model di Navigli (Kawasan Hiburan Malam):*
   - Model acuan: $text("GRU") (190,8) < text("RNN") (193,0) < text("ANN") (222,3) < text("LSTM") (247,3)$.
   - Model terbaik: $bold(text("ANN") (191,1)) < bold(text("LSTM") (210,4)) < text("RNN") (211,7) < text("GRU") (223,1)$.
   - Terjadi pembalikan peringkat model secara total (*complete ranking reversal*). Model feedforward ANN yang berkinerja paling buruk di Duomo melesat menjadi *model nomor satu* paling akurat di Navigli dengan Test MAE 191,1 $plus.minus$ 1,9 dan simpangan baku paling stabil, melampaui seluruh arsitektur rekuren.

=== Keterkaitan dengan Karakteristik Pola Trafik Spasial

Perubahan hierarki performa ini berhubungan erat dengan karakter fisis dan ritme sosial kawasan Navigli (Darsena):
1. *Karakter Aktivitas Malam dan Akhir Pekan:* Navigli merupakan pusat rekreasi kanal dan kehidupan malam (_nightlife_) yang dipenuhi kafe, bistro, bar, dan kelab malam. Sementara kurva beban Duomo didominasi oleh jam kerja teratur (Senin--Jumat, pukul 08.00--18.00) dengan puncak siang hari, kurva Navigli dicirikan oleh lonjakan impulsif pada malam hingga dini hari (pukul 20.00--03.00) serta akhir pekan (Jumat malam hingga Minggu) sebagaimana diilustrasikan pada @fig:D_pola_lokasi.
2. *Efektivitas Konteks Pendek ($W = 6$) vs Distorsi Histori Panjang ($W = 48$):* Dinamika kerumunan hiburan malam bersifat sesaat, cepat berubah, dan didorong oleh mobilitas pengunjung situasional. Konfigurasi terbaik ANN dan LSTM sama-sama mengadopsi jendela pendek $W = 6$ jam. Jendela 6 jam hanya membaca eskalasi beban terdekat sesaat sebelum puncak malam dimulai (_recent trend_), sehingga sangat tanggap dan bebas dari residu memori dua hari sebelumnya. Sebaliknya, model dengan $W = 48$ jam (RNN dan GRU terbaik) membawa deretan memori 48 jam yang justru mengaburkan anomali impulsif akhir pekan dengan riwayat hari kerja pertengahan minggu yang relatif sepi, sehingga Test MAE keduanya terdegradasi di Navigli (RNN memburuk ke 211,7 dan GRU ke 223,1).
3. *Keunggulan Pemetaan Deterministik ANN:* Kombinasi 1 lapisan tersembunyi (128 unit) dengan fitur `net+waktu` memberikan sinyal penanda fase jam dan hari secara kontinu tanpa akumulasi ketergantungan sekuensial rekuren yang rentan terdistorsi oleh lonjakan tiba-tiba. ANN secara murni memetakan pola lokal temporal dengan variansi paling sempit ($plus.minus 1,9$).
4. *Perilaku Anomali Minggu Natal di Navigli:* Pada minggu perayaan Natal (23--29 Desember), denyut kehidupan malam kanal padam karena warga merayakan libur secara privat di kediaman masing-masing. Baseline naif nilai terakhir menjadi metode terkuat di Navigli (Natal MAE 177,7) karena trafik berada pada level rendah yang datar. Sebaliknya, model deep learning yang terbiasa mempelajari lonjakan akhir pekan reguler menghasilkan prediksi berlebih (*over-estimation*).

= Pembahasan

== Mengapa Hasil Terjadi

Studi ini mengungkap bahwa keunggulan arsitektur deep learning dalam peramalan deret waktu seluler tidak bersifat universal, melainkan merupakan fungsi interaksi antara mekanisme memori model dan sifat stokastik dari dinamika temporal-spasial kawasan. Pada kawasan perkantoran teratur seperti Duomo, relasi temporal bersifat stasioner dan berulang secara berkala mengikuti ritme kerja mingguan, sehingga mekanisme propagasi hidden state langkah demi langkah pada RNN, LSTM, dan GRU sangat efisien dalam menyerap dependensi jangka panjang tanpa meledakkan dimensi bobot. Sebaliknya, pada wilayah dengan dinamika impulsif seperti Navigli, ketergantungan memori masa lalu yang terlampau panjang justru menjadi beban induktif (_inductive bias_) yang merugikan. Jaringan feedforward dengan jendela pendek dan fitur pengkodean waktu deterministik terbukti lebih adaptif terhadap pola lonjakan non-stasioner lokal.

== Faktor Paling dan Paling Tidak Berpengaruh

Analisis sensitivitas dari rangkaian ablasi OFAT mengidentifikasi hierarki pengaruh hiperparameter sebagai berikut:
1. *Faktor Paling Berpengaruh:*
   - *Ukuran Hidden Unit (A2) dan Learning Rate (A4):* Keduanya menjadi penentu utama kestabilan optimasi. Ukuran hidden menggeser model secara drastis dari zona _underfitting_ parah pada 16 unit (val MAE $>240$) menuju saturasi representasi pada 64--128 unit. Sementara itu, _learning rate_ $10^(-4)$ mengakibatkan kegagalan konvergensi total di seluruh model (stuck di 300 epoch tanpa pemicuan early stopping). Sebaliknya, laju besar $10^(-2)$ mempercepat konvergensi model bergerbang (LSTM dan GRU) hingga di bawah 70 epoch, namun memicu osilasi ketidakstabilan pada Simple RNN.
   - *Panjang Jendela $W$ (A1):* Berpengaruh sangat kritis terhadap arsitektur feedforward. Perataan matriks $W times 7$ pada ANN memicu penskalaan parameter linear yang melipatgandakan bobot dari 2.465 ($W=6$) ke 38.753 ($W=168$), menyebabkan overfitting parah. Sebaliknya, model rekuren memiliki parameter konstan terhadap $W$ dan memperlihatkan ketahanan luar biasa terhadap variasi panjang konteks historis.
   - *Kedalaman Layer LSTM (A3):* Penambahan lapisan dari 1 ke 3 pada LSTM memicu degradasi katastropik (val MAE melonjak dari 230,5 ke 338,9) akibat resistensi gradien yang lenyap (_vanishing gradients_) saat melintasi tumpukan 3 pasang gerbang rekuren pada volume sampel latih moderat tanpa koneksi pintas (_residual connections_).
2. *Faktor Paling Tidak Berpengaruh:*
   - *Kedalaman Lapisan ANN (A3):* Penambahan lapisan dari 1, 2, hingga 3 lapis pada ANN menghasilkan rentang val MAE yang hampir identik ($240,9$ hingga $248,9$). Karena tugas peramalan berfokus pada pemetaan proyeksi univariat, kedalaman jaringan feedforward tidak memberikan abstraksi representasi hierarkis tambahan yang berarti.
   - *Penambahan Kanal Panggilan dan SMS pada ANN (A5):* Penggabungan multivariat `call` dan `sms` hanya menggeser val MAE ANN sebesar 0,6 poin (260,5 ke 259,9). Bagi feedforward ANN, derau fluktuasi panggilan/SMS tidak mampu disaring seefektif mekanisme gerbang pada model rekuren.

== Variasi Antar-Seed vs Perbedaan Antar-Model

Perbandingan statistik menunjukkan bahwa signifikansi keunggulan arsitektural bergantung pada konteks evaluasi:
- Pada kondisi konfigurasi acuan di Duomo, margin perbedaan performa antar-arsitektur (misal selisih antara acuan RNN 229,6 dan acuan ANN 309,9 sebesar 80,3 poin) jauh lebih masif dibanding rentang deviasi standar stokastik inisialisasi bobot antar-seed ($plus.minus 5,1$ hingga $plus.minus 25,4$). Hal ini membuktikan bahwa dominasi keunggulan arsitektur rekuren atas ANN di kawasan bisnis berulang merupakan keunggulan struktural nyata, bukan kebetulan acak inisialisasi parameter.
- Namun, pada arsitektur yang berkapasitas sangat besar atau memiliki tumpukan lapisan yang dalam (seperti LSTM acuan $plus.minus 25,4$, LSTM di Navigli $plus.minus 54,3$, atau ANN di Navigli $plus.minus 27,4$), variansi inisialisasi stokastik melebar secara signifikan. Kondisi ini menegaskan bahwa pelaporan hasil peramalan deret waktu berbasis deep learning mutlak membutuhkan protokol evaluasi multi-seed untuk menghindari kesimpulan prematur berbasis eksekusi tunggal.

== Keterbatasan Studi

Studi ini memiliki sejumlah keterbatasan yang perlu dicatat untuk pengembangan ke depan:
1. *Cakupan Geografis dan Temporal Terbatas:* Eksperimen hanya mengevaluasi dua kotak seluler di Kota Milan dengan rentang waktu 56 hari (4 minggu data latih atau 672 observasi per jam). Karakteristik musiman tahunan tidak tercakup dalam dataset.
2. *Protokol Pemisahan Waktu Tunggal:* Evaluasi mengandalkan pembagian kronologis satu kali (*single chronological train/val/test split*), bukan skema validasi silang temporal bergulir (*rolling-origin / walk-forward evaluation*), sehingga rentan terhadap keunikan dinamika cuaca atau event lokal pada minggu uji tertentu.
3. *Ketiadaan Sampel Liburan Panjang pada Data Latih:* Data latih (November--awal Desember) sepenuhnya terdiri dari hari kerja dan akhir pekan reguler tanpa hari libur nasional. Akibatnya, seluruh model deep learning tidak memiliki memori pola libur panjang dan menderita pergeseran distribusi drastis pada minggu perayaan Natal.

= Kesimpulan

Studi ablasi terkontrol ini membuktikan bahwa arsitektur rekuren (RNN, LSTM, dan GRU) secara konsisten mengungguli feedforward ANN dan baseline naif di kawasan bisnis Duomo, dengan test MAE acuan Simple RNN mencapai 229,6 $plus.minus$ 5,1 dibandingkan ANN 309,9 $plus.minus$ 5,9 dan baseline naif minggu lalu 467,6. Melalui penyesuaian hyperparameter berbasis val MAE, integrasi konfigurasi terbaik berhasil memangkas error LSTM menjadi 225,3 $plus.minus$ 4,0 (MAPE terbaik 7,3%) dan RNN menjadi 224,5 $plus.minus$ 11,7; namun model dengan kapasitas raksasa seperti GRU terbaik (151.809 parameter) mengalami overfitting yang sedikit mendegradasi performa uji menjadi 239,7 $plus.minus$ 9,9. Uji generalisasi di kawasan hiburan malam Navigli membalikkan urutan performa secara total, di mana model ANN terbaik dengan jendela pendek ($W=6$) melesat menjadi model terbaik nomor satu (test MAE 191,1 $plus.minus$ 1,9), mengungguli seluruh varian rekuren. Temuan ini menegaskan bahwa keunggulan arsitektur deep learning sangat bergantung pada pola temporal spasial lokasi, serta pemilihan hyperparameter berbasis validasi memerlukan regularisasi yang memadai agar tidak terjebak dalam penghafalan pola lokal.

#heading(numbering: none)[Kontribusi Anggota]
#table(
  columns: (auto, 1fr),
  stroke: none,
  [Adif Dafa Raihan], [Kerangka proyek dan README, eksperimen Bagian 0 dan A1, pelatihan Bagian C/D, tabel pemilihan faktor, Abstrak, Pendahuluan, Metode, analisis A5/B2/B6, verifikasi angka, dan integrasi laporan.],
  [Cindy Auliya], [Hipotesis dan evaluasi Bagian B, eksperimen A3, A4, B2, dan B6, serta analisis hasil Bagian 0 dan A1--A4.],
  [Bima Cahya Ramadhan], [Eksperimen A2 dan A5, evaluasi Bagian C/D, grafik dan tabel IEEE, serta penulisan Bagian C, Bagian D, Pembahasan, dan Kesimpulan.],
)

#heading(numbering: none)[Pernyataan Penggunaan AI]
Alat AI yang kami gunakan adalah Antigravity CLI, Copilot CLI, OpenCode CLI, Gemini (model LLM), Copilot (model LLM), dan DeepSeek (model). Alat-alat tersebut digunakan untuk membantu penulisan kode eksperimen, analisis awal, dan penyuntingan bahasa laporan. Seluruh rancangan eksperimen, eksekusi pelatihan, dan angka yang dilaporkan berasal dari run kelompok sendiri yang tersimpan pada `hasil/ablasi.csv`; setiap keluaran AI kami periksa ulang terhadap data tersebut. AI tidak dipakai untuk menghasilkan atau mengubah angka hasil.
