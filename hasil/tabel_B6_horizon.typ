// Tabel Horizon Peramalan (jam) (val_MAE)
#figure(
  caption: [Pengaruh Horizon Peramalan (jam) terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Horizon Peramalan (jam)*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [1], [$bold(248.9 plus.minus 8.9)$], [$bold(206.1 plus.minus 7.4)$], [$bold(230.5 plus.minus 12.2)$], [$bold(207.5 plus.minus 3.8)$],
    [6], [$337.2 plus.minus 2.4$], [$416.6 plus.minus 11.4$], [$392.9 plus.minus 24.5$], [$381.1 plus.minus 21.0$],
    [24], [$449.0 plus.minus 7.6$], [$437.2 plus.minus 3.2$], [$456.9 plus.minus 19.8$], [$451.8 plus.minus 11.6$],
    table.hline(),
  ),
) <tab:tabel_B6_horizon>
