// Tabel Jumlah Lapisan (val_MAE)
#figure(
  caption: [Pengaruh Jumlah Lapisan terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Jumlah Lapisan*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [1], [$bold(240.9 plus.minus 7.5)$], [$bold(206.1 plus.minus 7.4)$], [$bold(230.5 plus.minus 12.2)$], [$207.5 plus.minus 3.8$],
    [2], [$248.9 plus.minus 8.9$], [$207.3 plus.minus 9.1$], [$254.8 plus.minus 14.5$], [$bold(203.3 plus.minus 9.6)$],
    [3], [$244.9 plus.minus 5.4$], [$225.1 plus.minus 12.7$], [$338.9 plus.minus 16.9$], [$212.2 plus.minus 15.9$],
    table.hline(),
  ),
) <tab:tabel_A3_layers>
