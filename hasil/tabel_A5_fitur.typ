// Tabel Kelompok Fitur (val_MAE)
#figure(
  caption: [Pengaruh Kelompok Fitur terhadap val MAE (rata-rata $plus.minus$ SD, 3 seed).],
  table(
    columns: 5,
    stroke: none,
    table.hline(),
    table.header([*Kelompok Fitur*], [*ANN*], [*RNN*], [*LSTM*], [*GRU*]),
    table.hline(stroke: 0.5pt),
    [net], [$260.5 plus.minus 7.0$], [$245.2 plus.minus 5.8$], [$266.2 plus.minus 5.7$], [$264.6 plus.minus 7.0$],
    [net+call+sms], [$259.9 plus.minus 5.2$], [$224.1 plus.minus 2.3$], [$243.7 plus.minus 7.1$], [$231.8 plus.minus 12.6$],
    [net+waktu], [$bold(246.0 plus.minus 9.8)$], [$223.0 plus.minus 9.5$], [$231.1 plus.minus 4.3$], [$213.2 plus.minus 18.2$],
    [semua], [$248.9 plus.minus 8.9$], [$bold(206.1 plus.minus 7.4)$], [$bold(230.5 plus.minus 12.2)$], [$bold(207.5 plus.minus 3.8)$],
    table.hline(),
  ),
) <tab:tabel_A5_fitur>
