#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

= Pendahuluan
#petunjuk[Jelaskan kebutuhan peramalan trafik per sel, alasan membandingkan ANN dengan model sekuensial, dan tujuan studi ablasi. Akhiri dengan 2–3 kontribusi laporan. Rujuk RNN, LSTM @hochreiter1997lstm, dan GRU @cho2014gru.]

= Data dan Metode

== Dataset
#petunjuk[Jelaskan sumber dan periode data Telecom Italia @barlacchi2015milan serta versi agregasi per jam @zhang2021fedda. Sebutkan fitur yang digunakan, kotak Duomo (5060), dan lokasi kelompok: Navigli (Darsena), kotak 4555 (kode 1).]

#figure(
  image("../gambar/peta_lokasi_tugas.png", width: 85%),
  caption: [Rata-rata aktivitas internet per kotak di Milan. Lingkaran kuning menunjukkan lokasi tugas; lingkaran toska menunjukkan Duomo.],
  placement: top,
) <fig:peta>

== Pembagian Data dan Praproses
#petunjuk[Jelaskan pembagian temporal train, validasi, test, dan Natal; standardisasi tanpa kebocoran data; serta windowing. Terangkan mengapa deret waktu tidak diacak.]

== Model dan Konfigurasi Acuan
#petunjuk[Uraikan ANN, RNN, LSTM, dan GRU secara ringkas. Konfigurasi berikut adalah nilai acuan yang perlu diverifikasi terhadap eksperimen.]

#figure(
  caption: [Konfigurasi acuan],
  placement: top,
  table(
    columns: 2,
    align: left,
    stroke: none,
    table.hline(),
    table.header([*Hyperparameter*], [*Nilai acuan*]),
    table.hline(stroke: 0.5pt),
    [Panjang jendela $W$], [24 jam],
    [Horizon], [1 jam],
    [Ukuran hidden], [ANN 32, RNN 68, LSTM 33, GRU 38],
    [Jumlah lapisan], [ANN 2, rekuren 1],
    [Fitur], [net, call, sms, jam, hari (7)],
    [Optimizer, _learning rate_], [Adam, $10^(-3)$],
    [_Batch size_], [64],
    [_Early stopping_], [_patience_ 30, maks. 300 epoch],
    table.hline(),
  ),
) <tab:acuan>

== Protokol Ablasi dan Evaluasi
#petunjuk[Jelaskan bahwa satu faktor diubah setiap kali; daftar nilai faktor A1–A5 dan dua faktor B; tiga random seed per konfigurasi; metrik MAE, RMSE, dan MAPE pada skala asli; pemilihan model dengan validation MAE; serta perangkat dan waktu pelatihan.]
