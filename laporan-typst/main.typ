// Laporan tugas Workshop Deep Learning — format IEEE conference.
// Compile dari folder ini dengan: typst compile main.typ main.pdf
#import "@preview/charged-ieee:0.1.4": ieee

#set text(lang: "id")
#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

#show: ieee.with(
  title: [Studi Ablasi RNN, LSTM, dan GRU dibandingkan ANN untuk Prediksi Trafik Seluler Kota Milan],
  abstract: [
    #petunjuk[150–200 kata. Ringkas masalah prediksi trafik per jam, dataset Telecom Italia dan lokasi penelitian, rancangan ablasi dengan tiga seed, hasil utama beserta angka, dan kesimpulan.]
  ],
  authors: (
    (name: "Adif Dafa Raihan", department: [NIM 124400055], organization: [Teknik Telekomunikasi, ITERA], email: "adif.124400055@student.itera.ac.id"),
    (name: "Cindy Auliya", department: [NIM 124400045], organization: [Teknik Telekomunikasi, ITERA], email: "cindy.124400045@student.itera.ac.id"),
    (name: "Bima Cahya Ramadhan", department: [NIM 124400001], organization: [Teknik Telekomunikasi, ITERA], email: "bima.124400001@student.itera.ac.id"),
  ),
  index-terms: ("prediksi trafik seluler", "RNN", "LSTM", "GRU", "studi ablasi"),
  bibliography: bibliography("references.bib", title: [Referensi]),
  figure-supplement: [Gambar],
)

#include "sections/adif.typ"
#include "sections/cindy.typ"
#include "sections/bima.typ"
