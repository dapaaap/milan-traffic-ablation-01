// Tabel Learning Rate (val_MAE)
#figure(
  caption: [Pengaruh Learning Rate terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Learning Rate*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [0.0001], [$295.3 plus.minus 4.6$], [$285.0 plus.minus 13.7$], [$399.4 plus.minus 25.0$], [$398.4 plus.minus 8.6$],
    [0.001], [$bold(248.9 plus.minus 8.9)$], [$bold(206.1 plus.minus 7.4)$], [$230.5 plus.minus 12.2$], [$bold(207.5 plus.minus 3.8)$],
    [0.01], [$261.8 plus.minus 16.6$], [$226.7 plus.minus 6.7$], [$bold(215.9 plus.minus 14.2)$], [$208.2 plus.minus 5.6$],
    table.hline(),
  ),
) <tab:tabel_A4_lr>
