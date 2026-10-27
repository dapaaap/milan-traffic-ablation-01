== Bagian C — Konfigurasi Terbaik

Konfigurasi terbaik tiap model dipilih hanya dari val MAE, lalu dievaluasi pada minggu test dan Natal. Kombinasi terpilih adalah ANN dengan $W=6$, hidden 128, 1 lapisan, dan fitur `net+waktu` (4.097 parameter); RNN dengan $W=48$ (5.305 parameter); LSTM dengan $W=6$, hidden 128, dan $lr=10^(-2)$ (70.273 parameter); serta GRU dengan $W=48$, hidden 128, 2 lapisan, dan dropout 0,2 (151.809 parameter). Hasil lengkapnya disajikan pada @tab:tabel_C_terbaik_vs_acuan dan @fig:ieee_col_C_terbaik_vs_acuan.

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
  caption: [Perbandingan test MAE antara konfigurasi acuan dan terbaik di Duomo (rata-rata $plus.minus$ SD, 3 seed).],
) <fig:ieee_col_C_terbaik_vs_acuan>

Penyetelan menurunkan test MAE ANN menjadi 288,1 $plus.minus$ 15,6 (turun 7,0%), RNN menjadi 224,5 $plus.minus$ 11,7 (turun 2,2%), dan LSTM menjadi 225,3 $plus.minus$ 4,0 (turun 17,7%). LSTM juga mencatat MAPE terbaik (7,3 $plus.minus$ 0,7%). GRU terbaik justru mengalami degradasi pada test (239,7 versus 237,2) dan Natal (497,6 versus 468,2), meskipun val MAE lebih rendah (203,6 versus 207,5); pertumbuhan parameter menjadi 151.809 memicu overfitting. RNN terbaik menjadi model paling akurat di Duomo, dan pada Natal RNN terbaik mencatat 404,5 $plus.minus$ 9,9, lebih baik dari seluruh baseline. Semua konfigurasi tetap mengungguli baseline naif minggu lalu (467,6).

== Bagian D — Uji Generalisasi

Uji generalisasi dilakukan pada Navigli (Darsena), kotak 4555 kode 1, dengan konfigurasi acuan dan terbaik yang sama (@tab:tabel_D_generalisasi dan @fig:ieee_col_D_generalisasi). Navigli adalah kawasan hiburan malam dengan lonjakan trafik pada pukul 20.00--03.00 dan akhir pekan, berbeda dari pola perkantoran Duomo.

#figure(
  caption: [Evaluasi generalisasi di Navigli, kotak 4555 ($H=1$ jam, rata-rata $plus.minus$ SD, 3 seed).],
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

Urutan model berubah total. Di Duomo, urutan test MAE acuan adalah RNN (229,6) < GRU (237,2) < LSTM (273,6) < ANN (309,9); di Navigli urutannya GRU (190,8) < RNN (193,0) < ANN (222,3) < LSTM (247,3). Setelah penyetelan, ANN terbaik menjadi model nomor satu di Navigli (191,1 $plus.minus$ 1,9), disusul LSTM (210,4), RNN (211,7), dan GRU (223,1). Konfigurasi terbaik RNN dan GRU yang memakai $W=48$ justru memburuk di Navigli, sedangkan ANN dan LSTM yang memakai $W=6$ membaik. Jendela pendek lebih sesuai untuk dinamika nightlife yang impulsif; jendela 48 jam membawa histori hari kerja yang tidak relevan sehingga mengaburkan lonjakan akhir pekan. Pada Natal, naif nilai terakhir (177,7) menjadi pembanding terkuat karena aktivitas malam surut dan relatif datar, sementara model deep learning cenderung memprediksi lonjakan yang tidak terjadi.

= Pembahasan

Hasil menunjukkan bahwa keunggulan arsitektur tidak universal, tetapi bergantung pada sifat temporal kawasan. Di Duomo yang relatif stasioner dan mengikuti ritme kerja mingguan, hidden state rekuren menangkap dependensi jangka panjang secara efisien. Di Navigli yang impulsif, memori panjang justru menjadi beban; ANN dengan jendela pendek dan fitur waktu deterministik lebih adaptif.

Faktor paling berpengaruh adalah ukuran hidden dan learning rate. Kapasitas 16 unit underfit, sedangkan 128 unit menurunkan error secara konsisten tetapi memperbesar parameter hingga 70.273 (LSTM) dan 52.737 (GRU). Learning rate $10^(-4)$ gagal konvergen, sedangkan $10^(-2)$ hanya menguntungkan model bergerbang. Panjang jendela kritis bagi ANN karena parameter tumbuh dari 2.465 menjadi 38.753; kedalaman LSTM tiga lapis juga katastrofik (val 338,9; test 412,6). Sebaliknya, kedalaman ANN dan penambahan call/sms pada ANN memberi perubahan kecil.

Perbedaan antar-model umumnya lebih besar daripada variasi antar-seed. Selisih RNN dan ANN acuan di Duomo mencapai 80,3 poin, jauh di atas simpangan baku seed (5,1--25,4). Namun, model berkapasitas besar seperti LSTM di Navigli ($plus.minus$ 54,3) dan ANN di Navigli ($plus.minus$ 27,4) memiliki variansi lebar, sehingga evaluasi multi-seed tetap diperlukan. Keterbatasan studi meliputi cakupan dua kotak di Milan, 56 hari data, satu pembagian kronologis, dan tidak adanya sampel libur panjang pada data latih.

= Kesimpulan

Studi ablasi ini menunjukkan bahwa RNN, LSTM, dan GRU mengungguli ANN dan baseline naif di Duomo, dengan test MAE acuan RNN 229,6 $plus.minus$ 5,1 dibandingkan ANN 309,9 $plus.minus$ 5,9 dan naif minggu lalu 467,6. Penyetelan berbasis val MAE menurunkan error LSTM menjadi 225,3 $plus.minus$ 4,0 dan RNN menjadi 224,5 $plus.minus$ 11,7, tetapi GRU terbaik (151.809 parameter) overfit dan sedikit memburuk pada test (239,7). Di Navigli, urutan model berbalik: ANN terbaik dengan $W=6$ menjadi yang paling akurat (191,1 $plus.minus$ 1,9). Temuan ini menegaskan bahwa pemilihan arsitektur dan hyperparameter harus mempertimbangkan karakter temporal lokasi, serta regularisasi diperlukan agar kapasitas besar tidak menghafal pola validasi.

#block(breakable: false)[
  #heading(numbering: none)[Kontribusi Anggota]
  #table(
    columns: (auto, 1fr),
    stroke: none,
    [Adif Dafa Raihan], [Kerangka proyek dan README, eksperimen Bagian 0 dan A1, pelatihan Bagian C/D, tabel pemilihan faktor, Abstrak, Pendahuluan, Metode, analisis A5/B2/B6, verifikasi angka, dan integrasi laporan.],
    [Cindy Auliya], [Hipotesis dan evaluasi Bagian B, eksperimen A3, A4, B2, dan B6, serta analisis hasil Bagian 0 dan A1--A4.],
    [Bima Cahya Ramadhan], [Eksperimen A2 dan A5, evaluasi Bagian C/D, grafik dan tabel IEEE, serta penulisan Bagian C, Bagian D, Pembahasan, dan Kesimpulan.],
  )
]

#heading(numbering: none)[Pernyataan Penggunaan AI]
Alat AI yang kami gunakan adalah Antigravity CLI, Copilot CLI, OpenCode CLI, Gemini (model LLM), Copilot (model LLM), dan DeepSeek (model). Alat-alat tersebut digunakan untuk membantu penulisan kode eksperimen, analisis awal, dan penyuntingan bahasa laporan. Seluruh rancangan eksperimen, eksekusi pelatihan, dan angka yang dilaporkan berasal dari run kelompok sendiri yang tersimpan pada `hasil/ablasi.csv`; setiap keluaran AI kami periksa ulang terhadap data tersebut. AI tidak dipakai untuk menghasilkan atau mengubah angka hasil.

Laporan ini disusun dan dikompilasi menggunakan Typst.
