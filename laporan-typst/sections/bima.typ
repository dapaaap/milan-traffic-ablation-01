#let petunjuk(isi) = text(fill: gray.darken(20%))[[#isi]]

== Bagian C — Konfigurasi Terbaik
#petunjuk[Pilih konfigurasi terbaik tiap model berdasarkan validation MAE. Bandingkan performa pada minggu test dan periode Natal dengan konfigurasi acuan serta baseline naif.]

== Bagian D — Uji Generalisasi
#petunjuk[Bandingkan konfigurasi acuan dan terbaik pada lokasi kelompok Navigli (Darsena), kotak 4555 (kode 1). Bahas perubahan urutan performa model dan kaitannya dengan pola trafik lokasi.]

= Pembahasan
#petunjuk[Jelaskan mengapa hasil terjadi, faktor yang paling dan paling tidak berpengaruh, besarnya variasi antar-seed dibanding perbedaan model, dan keterbatasan studi.]

= Kesimpulan
#petunjuk[Tulis 3–5 kalimat yang menjawab tujuan studi dan merangkum temuan utama menggunakan angka hasil eksperimen.]

#heading(numbering: none)[Kontribusi Anggota]
#table(
  columns: (auto, 1fr),
  stroke: none,
  [Adif Dafa Raihan], petunjuk[Isi kontribusi aktual, misalnya pendahuluan, metode, atau eksperimen.],
  [Cindy Auliya], petunjuk[Isi kontribusi aktual, misalnya analisis hasil Bagian 0, A, dan B.],
  [Bima Cahya Ramadhan], petunjuk[Isi kontribusi aktual, misalnya analisis Bagian C dan D, pembahasan, atau kesimpulan.],
)

#heading(numbering: none)[Pernyataan Penggunaan AI]
Kami menggunakan bantuan asisten AI, antara lain OpenCode, untuk membantu penulisan kode eksperimen, analisis awal, dan penyuntingan bahasa laporan. Seluruh rancangan eksperimen, eksekusi pelatihan, dan angka yang dilaporkan berasal dari run kelompok sendiri yang tersimpan pada `hasil/ablasi.csv`; setiap keluaran AI kami periksa ulang terhadap data tersebut. AI tidak dipakai untuk menghasilkan atau mengubah angka hasil.

// Daftar pustaka dengan judul “Referensi” dihasilkan oleh charged-ieee.
