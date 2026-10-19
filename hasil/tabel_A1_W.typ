// Tabel Panjang Jendela W (jam) (val_MAE)
#figure(
  caption: [Pengaruh Panjang Jendela W (jam) terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Panjang Jendela W (jam)*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [6], [$bold(211.5 plus.minus 6.2)$], [$215.5 plus.minus 4.1$], [$bold(227.1 plus.minus 4.3)$], [$212.6 plus.minus 11.5$],
    [12], [$238.5 plus.minus 4.5$], [$206.7 plus.minus 6.2$], [$235.6 plus.minus 2.0$], [$208.9 plus.minus 10.4$],
    [24], [$248.9 plus.minus 8.9$], [$206.1 plus.minus 7.4$], [$230.5 plus.minus 12.2$], [$207.5 plus.minus 3.8$],
    [48], [$262.6 plus.minus 3.8$], [$bold(200.1 plus.minus 5.3)$], [$249.1 plus.minus 21.8$], [$bold(206.7 plus.minus 5.0)$],
    [168], [$298.2 plus.minus 18.2$], [$204.8 plus.minus 10.2$], [$241.4 plus.minus 8.1$], [$206.7 plus.minus 5.1$],
    table.hline(),
  ),
) <tab:tabel_A1_W>
