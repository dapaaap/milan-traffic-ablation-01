// Laporan tugas Workshop Deep Learning — format IEEE conference.
// Compile dari folder ini dengan: typst compile main.typ main.pdf
#import "@preview/charged-ieee:0.1.4": ieee

#set text(lang: "id")
#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

#show: ieee.with(
  title: [Studi Ablasi RNN, LSTM, dan GRU dibandingkan ANN untuk Prediksi Trafik Seluler Kota Milan],
  abstract: [
    Pertumbuhan trafik internet seluler menuntut operator meramalkan beban setiap sel secara akurat agar kapasitas dan energi jaringan dialokasikan secara efisien. Penelitian ini membandingkan ANN dengan RNN, LSTM, dan GRU untuk prediksi trafik per jam pada dataset Telecom Italia Big Data Challenge di Milan, dengan lokasi utama Duomo (kotak 5060) dan uji generalisasi di Navigli (kotak 4555). Kami melakukan studi ablasi terkontrol dengan mengubah satu faktor setiap kali, yaitu panjang jendela, ukuran hidden, jumlah lapisan, learning rate, kelompok fitur, dropout, dan horizon, masing-masing dengan tiga random seed. Konfigurasi dipilih hanya berdasarkan val MAE, lalu diuji pada minggu test dan periode Natal. Pada konfigurasi acuan, RNN memberikan test MAE terbaik (229,6 $plus.minus$ 5,1) dan mengungguli baseline naif minggu lalu (467,6), sedangkan ANN terlemah di antara empat model (309,9 $plus.minus$ 5,9). Penyetelan menurunkan MAE RNN menjadi 224,5 dan LSTM dari 273,6 menjadi 225,3, tetapi konfigurasi terbaik GRU justru memburuk (239,7 versus 237,2) karena overfit. Di Navigli urutan berubah dan ANN menjadi terbaik (191,1 $plus.minus$ 1,9). Hasil ini menunjukkan bahwa keunggulan model sekuensial bergantung pada lokasi dan bahwa pemilihan hyperparameter berbasis validasi tidak selalu menjamin perbaikan pada data uji.
  ],
  authors: (
    (name: "Adif Dafa Raihan", department: [NIM 124400055], organization: [Teknik Telekomunikasi, ITERA], email: "adif.124400055@student.itera.ac.id"),
    (name: "Cindy Auliya", department: [NIM 124400045], organization: [Teknik Telekomunikasi, ITERA], email: "cindy.124400045@student.itera.ac.id"),
    (name: "Bima Cahya Ramadhan", department: [NIM 124400001], organization: [Teknik Telekomunikasi, ITERA], email: "bima.124400001@student.itera.ac.id"),
  ),
  index-terms: ("prediksi trafik seluler", "RNN", "LSTM", "GRU", "studi ablasi"),
  bibliography: bibliography("references.bib", title: [Referensi]),
  figure-supplement: [Fig.],
)

#include "sections/adif.typ"
#include "sections/cindy.typ"
#include "sections/bima.typ"
