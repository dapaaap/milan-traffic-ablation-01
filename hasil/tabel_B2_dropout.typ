// Tabel Dropout Rate (val_MAE)
#figure(
  caption: [Pengaruh Dropout Rate terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Dropout Rate*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [0.0], [$bold(248.9 plus.minus 8.9)$], [$bold(206.1 plus.minus 7.4)$], [$bold(230.5 plus.minus 12.2)$], [$207.5 plus.minus 3.8$],
    [0.2], [$274.6 plus.minus 31.6$], [$239.5 plus.minus 10.7$], [$231.8 plus.minus 9.3$], [$bold(203.9 plus.minus 5.1)$],
    [0.5], [$377.7 plus.minus 13.1$], [$254.8 plus.minus 11.1$], [$247.4 plus.minus 6.5$], [$259.5 plus.minus 29.0$],
    table.hline(),
  ),
) <tab:tabel_B2_dropout>
