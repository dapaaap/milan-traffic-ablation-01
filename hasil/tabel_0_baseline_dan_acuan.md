# Tabel Baseline Naif dan Model Acuan (Duomo, Kotak 5060, Horizon=1)

| Model / Metode | Parameter | Val MAE | Test MAE | Test MAPE (%) | Natal MAE |
|:---|:---:|:---:|:---:|:---:|:---:|
| Naif: nilai terakhir | 0 | 662.6 | 600.9 | 18.4% | 431.2 |
| Naif: kemarin | 0 | 595.3 | 552.2 | 23.8% | 921.5 |
| Naif: minggu lalu | 0 | 492.8 | 467.6 | 19.9% | 1426.2 |
| **ANN (Acuan)** | 6,497 | 248.9 ± 8.9 | 309.9 ± 5.9 | 11.3 ± 0.8% | 680.1 ± 52.0 |
| **RNN (Acuan)** | 5,305 | 206.1 ± 7.4 | 229.6 ± 5.1 | 8.5 ± 0.3% | 421.2 ± 2.4 |
| **LSTM (Acuan)** | 5,578 | 230.5 ± 12.2 | 273.6 ± 25.4 | 9.1 ± 1.0% | 586.0 ± 56.8 |
| **GRU (Acuan)** | 5,397 | 207.5 ± 3.8 | 237.2 ± 9.3 | 8.0 ± 0.7% | 468.2 ± 21.8 |
