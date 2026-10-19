#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

= Hasil

== Bagian 0 — Baseline Naif dan Acuan
#petunjuk[Bandingkan baseline naif (last value, yesterday, last week) dengan konfigurasi acuan pada lokasi Duomo. Sajikan metrik rata-rata dan simpangan baku dari tiga seed.]

== Bagian A — Ablasi Wajib
#petunjuk[Laporkan faktor A1–A5: panjang jendela, hidden units, jumlah lapisan, learning rate, dan fitur. Untuk setiap faktor, tuliskan rentang nilai, hasil utama, serta interpretasi singkat. Rujuk grafik dan tabel yang relevan dari folder hasil/.]

#figure(
  caption: [Templat hasil ablasi: test MAE rata-rata ± simpangan baku dari tiga seed. Ganti nilai contoh dengan hasil eksperimen.],
  placement: top,
  table(
    columns: 5,
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*$W$ (jam)*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [6], [--], [--], [--], [--],
    [24], [--], [--], [--], [--],
    [168], [--], [--], [--], [--],
    table.hline(),
  ),
) <tab:hasil-ablasi>

== Bagian B — Ablasi Pilihan
#petunjuk[Jelaskan dua faktor tambahan pilihan kelompok (misalnya dropout dan horizon), hipotesis sebelum eksperimen, hasil pengukuran, dan apakah hasil mendukung hipotesis.]
