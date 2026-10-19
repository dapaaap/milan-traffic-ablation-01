// Tabel Ukuran Hidden (val_MAE)
#figure(
  caption: [Pengaruh Ukuran Hidden terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Ukuran Hidden*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [16], [$257.6 plus.minus 28.0$], [$247.0 plus.minus 5.8$], [$244.3 plus.minus 18.3$], [$216.8 plus.minus 21.2$],
    [32], [$248.9 plus.minus 8.9$], [$218.7 plus.minus 6.6$], [$241.5 plus.minus 20.5$], [$210.2 plus.minus 0.8$],
    [64], [$238.4 plus.minus 16.5$], [$bold(207.2 plus.minus 12.8)$], [$218.1 plus.minus 1.9$], [$198.4 plus.minus 9.2$],
    [128], [$bold(233.8 plus.minus 1.9)$], [$207.7 plus.minus 7.2$], [$bold(207.1 plus.minus 8.4)$], [$bold(188.7 plus.minus 4.2)$],
    table.hline(),
  ),
) <tab:tabel_A2_hidden>
