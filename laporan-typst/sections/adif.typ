= Pendahuluan

Pertumbuhan trafik data seluler menuntut operator meramalkan permintaan tiap sel secara akurat untuk alokasi kapasitas, efisiensi energi, dan kualitas layanan. Peramalan yang terlalu rendah menyebabkan kongesti, sedangkan peramalan yang terlalu tinggi membuang kapasitas. Karena trafik mengikuti ritme harian, mingguan, dan karakter kawasan, model perlu menangkap dependensi temporal, bukan hanya hubungan antarfitur pada satu waktu.

ANN meratakan jendela observasi sehingga urutan waktu hilang. Recurrent neural network (RNN) mempertahankan hidden state, tetapi rentan terhadap vanishing gradient. Long short-term memory (LSTM) menambahkan gerbang input, forget, dan output serta cell state @hochreiter1997lstm, sedangkan gated recurrent unit (GRU) menyederhanakannya menjadi gerbang reset dan update @cho2014gru. Keunggulan model sekuensial tidak otomatis karena bergantung pada panjang jendela, kapasitas hidden, kedalaman, learning rate, fitur, regularisasi, dan horizon. Studi ablasi yang mengubah satu faktor setiap kali memisahkan pengaruh faktor tersebut dari variasi antar-seed.

Kontribusi laporan ini ada tiga. Pertama, ablasi terkontrol lima faktor utama (panjang jendela, ukuran hidden, jumlah lapisan, learning rate, kelompok fitur) dan dua faktor tambahan (dropout, horizon) pada empat model dengan tiga seed di Duomo. Kedua, pemilihan konfigurasi hanya dari val MAE, lalu evaluasi pada minggu test dan Natal bersama baseline naif. Ketiga, uji generalisasi konfigurasi acuan dan terbaik di Navigli (kotak 4555, kode 1).

= Data dan Metode

== Dataset

Data berasal dari Telecom Italia Big Data Challenge @barlacchi2015milan yang mencakup aktivitas jaringan di Kota Milan, Italia. Kami memakai versi agregasi per jam @zhang2021fedda untuk periode 4 November--29 Desember 2013, sehingga setiap lokasi memiliki 1.344 observasi atau 56 hari. Setiap catatan memuat tiga kanal trafik, yaitu internet (net), panggilan (call), dan SMS (sms). Fitur masukan berjumlah tujuh: net, call, sms, serta empat fitur waktu berupa sinus dan kosinus jam (jam_sin, jam_cos) dan hari (hari_sin, hari_cos). Fitur waktu merepresentasikan periodisitas sirkadian dan mingguan secara kontinu. Target peramalan adalah net satu jam ke depan. Lokasi utama penelitian adalah kotak Duomo 5060, sedangkan lokasi kelompok untuk uji generalisasi adalah Navigli (Darsena), kotak 4555 dengan kode lokasi 1.

== Pembagian Data dan Praproses

Pembagian data dilakukan secara kronologis: train 11 November--8 Desember 2013 (672 jam), validasi 9--15 Desember, test 16--22 Desember, dan periode Natal 23--29 Desember. Minggu pertama, 4--10 November, hanya menjadi konteks jendela bagi sampel awal. Pembagian ini memisahkan masa depan dari masa lalu sehingga tidak ada informasi test yang bocor ke pelatihan.

Standardisasi z-score dihitung dari rata-rata dan simpangan baku data sebelum 9 Desember, yaitu data latih beserta minggu konteks. Statistik tersebut kemudian diterapkan pada validasi, test, dan Natal. Jendela masukan dibentuk dengan panjang $W = 24$ jam dan horizon $H = 1$ jam, sehingga terdapat 672 jendela latih. Sebuah jendela dimasukkan ke split berdasarkan waktu targetnya, bukan waktu awal jendela. Prediksi dikembalikan ke skala asli sebelum metrik dihitung.

Deret waktu tidak diacak pada tahap pembagian karena pengacakan akan mencampur masa lalu dan masa depan serta merusak urutan yang menjadi objek peramalan. Pengacakan hanya dilakukan pada urutan mini-batch selama pelatihan; setiap jendela tetap mempertahankan urutan internalnya.

== Model dan Konfigurasi Acuan

ANN meratakan jendela $W times 7$ menjadi vektor dan memetakannya melalui dua lapisan tersembunyi berukuran 32 dengan aktivasi ReLU. RNN sederhana memakai hidden state 68, LSTM memakai hidden state 33 dengan tiga gerbang dan cell state @hochreiter1997lstm, sedangkan GRU memakai hidden state 38 dengan dua gerbang @cho2014gru. Pada ketiga model rekuren, keluaran diambil dari hidden state langkah terakhir, lalu dilewatkan satu lapisan linear.

Semua model dilatih dengan loss MSE dan optimizer Adam (learning rate $10^(-3)$), batch 64, serta early stopping pada val MSE dengan patience 30 dan maksimum 300 epoch. Bobot terbaik dipilih dari epoch dengan val MSE terendah. Pelatihan diimplementasikan dengan PyTorch @paszke2019pytorch. Konfigurasi acuan dirangkum pada @tab:acuan.

#figure(
  caption: [Konfigurasi acuan dan jumlah parameter],
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
    [Fitur], [net, call, sms, jam (sin/cos), hari (sin/cos) --- 7 fitur],
    [Jumlah parameter], [ANN 6.497, RNN 5.305, LSTM 5.578, GRU 5.397],
    [Optimizer, _learning rate_], [Adam, $10^(-3)$],
    [_Batch size_], [64],
    [_Early stopping_], [_patience_ 30, maks. 300 epoch],
    table.hline(),
  ),
) <tab:acuan>

== Protokol Ablasi dan Evaluasi

Setiap eksperimen mengubah satu faktor dari konfigurasi acuan. Faktor A1 menguji $W in {6, 12, 24, 48, 168}$ jam; A2 ukuran hidden ${16, 32, 64, 128}$; A3 jumlah lapisan ${1, 2, 3}$; A4 learning rate ${10^(-4), 10^(-3), 10^(-2)}$; dan A5 kelompok fitur {net, net+call+sms, net+waktu, semua}. Faktor tambahan adalah B2 dropout {0; 0,2; 0,5} dan B6 horizon {1, 6, 24} jam. Setiap konfigurasi dilatih dengan tiga seed (0, 1, 2) dan dilaporkan sebagai rata-rata $plus.minus$ simpangan baku.

Evaluasi memakai MAE, RMSE, dan MAPE pada skala asli; MAE menjadi metrik utama. Pemilihan konfigurasi terbaik hanya memakai val MAE, sedangkan data test dan Natal dipakai untuk evaluasi akhir. Seluruh pelatihan dijalankan pada CPU dengan PyTorch; 270 pelatihan unik (348 catatan run karena beberapa konfigurasi acuan dipakai ulang) memerlukan total 92,6 menit.
