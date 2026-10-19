"""
generate_final_outputs.py
-------------------------
Skrip otomatis untuk memproses hasil/ablasi.csv dan baseline naif:
1. Menghasilkan seluruh tabel rekap dan per-faktor dalam format Markdown (.md),
   LaTeX booktabs (.tex), Typst (.typ), dan CSV (.csv) dengan format rata-rata ± simpangan baku (3 seed).
2. Menghasilkan grafik dengan ukuran pas kolom IEEE:
   - Single Column: 3.5 inci (88.9 mm) x 2.4 inci, 300 DPI
   - Double Column: 7.0 inci (177.8 mm) x 2.4 inci, 300 DPI
   dengan tipografi proporsional dan palet warna resmi proyek.
3. Menyimpan seluruh artefak ke direktori hasil/ dan menyinkronkan gambar ke folder laporan.
"""

import os
import shutil
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Direktori kerja
BASE_DIR = Path(__file__).resolve().parent
HASIL_DIR = BASE_DIR / "hasil"
HASIL_DIR.mkdir(exist_ok=True)

LATEX_GAMBAR_DIR = BASE_DIR / "laporan-latex" / "gambar"
TYPST_GAMBAR_DIR = BASE_DIR / "laporan-typst" / "gambar"

# Palet warna resmi proyek
NAVY, GOLD, RED, TEAL, GRAY = "#0B1F3A", "#D4A017", "#C8102E", "#1E8C8C", "#5A5A5A"
WARNA_MODEL = {"ANN": GOLD, "RNN": RED, "LSTM": NAVY, "GRU": TEAL}
MARKER_MODEL = {"ANN": "s", "RNN": "o", "LSTM": "^", "GRU": "D"}
MODELS = ["ANN", "RNN", "LSTM", "GRU"]

def setup_matplotlib_ieee(single_col=True):
    """Konfigurasi gaya matplotlib agar tipografi dan ukuran presisi untuk kolom IEEE."""
    plt.rcParams.update({
        "font.family": "serif",
        "font.serif": ["Times New Roman", "DejaVu Serif", "STIXGeneral"],
        "font.size": 8.0,
        "axes.labelsize": 8.5,
        "axes.titlesize": 9.0,
        "xtick.labelsize": 7.5,
        "ytick.labelsize": 7.5,
        "legend.fontsize": 7.5,
        "legend.title_fontsize": 8.0,
        "figure.titlesize": 9.5,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.grid": True,
        "grid.alpha": 0.25,
        "grid.linestyle": "--",
        "grid.linewidth": 0.5,
        "lines.linewidth": 1.3,
        "lines.markersize": 4.5,
        "errorbar.capsize": 2.5,
        "savefig.dpi": 300,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.03,
    })

def format_mean_std(mean, std, precision=1, is_latex=False, is_typst=False, bold=False):
    """Format nilai numerik menjadi mean ± std."""
    if pd.isna(mean):
        return "-"
    m_str = f"{mean:.{precision}f}"
    if pd.isna(std) or std == 0.0:
        val_str = m_str
    else:
        s_str = f"{std:.{precision}f}"
        if is_latex:
            val_str = f"{m_str} \\pm {s_str}"
        elif is_typst:
            val_str = f"{m_str} plus.minus {s_str}"
        else:
            val_str = f"{m_str} ± {s_str}"
    
    if bold:
        if is_latex:
            return f"\\mathbf{{{val_str}}}"
        elif is_typst:
            return f"$bold({val_str})$"
        else:
            return f"**{val_str}**"
    else:
        if is_latex:
            return f"${val_str}$"
        elif is_typst:
            return f"${val_str}$"
        else:
            return val_str

def load_data():
    csv_path = HASIL_DIR / "ablasi.csv"
    if not csv_path.exists():
        raise FileNotFoundError(f"File {csv_path} tidak ditemukan!")
    
    df = pd.read_csv(csv_path, dtype={"nilai": str, "kunci": str})
    for col in ["val_MAE", "val_RMSE", "val_MAPE", "test_MAE", "test_RMSE", "test_MAPE", "natal_MAE", "natal_RMSE", "natal_MAPE", "param", "epoch", "detik"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    return df

def generate_table_factor(df, bagian, faktor_nama, nilai_list, label_col, output_base, metric="val_MAE"):
    """
    Menghasilkan tabel matriks [Nilai Faktor x 4 Model] untuk metrik tertentu.
    Menghasilkan file .md, .tex, .typ, dan .csv
    """
    sub = df[df["bagian"] == bagian]
    
    # Hitung mean & std per (nilai, model)
    stats = sub.groupby(["nilai", "model"])[metric].agg(["mean", "std"]).reset_index()
    
    rows_md = []
    rows_tex = []
    rows_typ = []
    csv_records = []
    
    # Header
    header_md = f"| {label_col} | " + " | ".join(MODELS) + " |"
    sep_md = "|:---:|" + ":---:|" * len(MODELS)
    rows_md.extend([header_md, sep_md])
    
    rows_tex.append("\\begin{table}[t]")
    rows_tex.append("  \\centering")
    rows_tex.append(f"  \\caption{{Pengaruh {label_col} terhadap {metric.replace('_', ' ')} (rata-rata $\\pm$ SD, 3 seed)}}")
    rows_tex.append(f"  \\label{{tab:{output_base}}}")
    rows_tex.append("  \\begin{tabular}{@{}l" + "c" * len(MODELS) + "@{}}")
    rows_tex.append("    \\toprule")
    rows_tex.append(f"    {label_col} & " + " & ".join(MODELS) + " \\\\")
    rows_tex.append("    \\midrule")
    
    rows_typ.append(f"// Tabel {label_col} ({metric})")
    rows_typ.append("#figure(")
    rows_typ.append(f"  caption: [Pengaruh {label_col} terhadap {metric.replace('_', ' ')} (rata-rata $plus.minus$ SD, 3 seed).],")
    rows_typ.append("  table(")
    rows_typ.append(f"    columns: {len(MODELS) + 1},")
    rows_typ.append("    stroke: none,")
    rows_typ.append("    table.hline(),")
    typ_header = f"    table.header([*{label_col}*], " + ", ".join([f"[*{m}*]" for m in MODELS]) + "),"
    rows_typ.append(typ_header)
    rows_typ.append("    table.hline(stroke: 0.5pt),")
    
    # Cari nilai minimum per model untuk ditebalkan
    min_vals = {}
    for m in MODELS:
        m_stats = stats[stats["model"] == m]
        if not m_stats.empty:
            min_vals[m] = m_stats["mean"].min()
    
    for val in nilai_list:
        val_str = str(val)
        md_cells = [val_str]
        tex_cells = [val_str]
        typ_cells = [f"[{val_str}]"]
        csv_row = {"nilai": val_str}
        
        for m in MODELS:
            match = stats[(stats["nilai"] == val_str) & (stats["model"] == m)]
            if match.empty:
                md_cells.append("-")
                tex_cells.append("-")
                typ_cells.append("[-]")
                csv_row[f"{m}_mean"] = np.nan
                csv_row[f"{m}_std"] = np.nan
                csv_row[f"{m}_formatted"] = "-"
            else:
                mean = match["mean"].values[0]
                std = match["std"].values[0]
                is_best = (abs(mean - min_vals.get(m, -999)) < 1e-5)
                
                md_cells.append(format_mean_std(mean, std, precision=1, bold=is_best))
                tex_cells.append(format_mean_std(mean, std, precision=1, is_latex=True, bold=is_best))
                typ_cells.append(f"[{format_mean_std(mean, std, precision=1, is_typst=True, bold=is_best)}]")
                
                csv_row[f"{m}_mean"] = round(mean, 2)
                csv_row[f"{m}_std"] = round(std, 2) if not pd.isna(std) else 0.0
                csv_row[f"{m}_formatted"] = format_mean_std(mean, std, precision=1)
        
        rows_md.append("| " + " | ".join(md_cells) + " |")
        rows_tex.append("    " + " & ".join(tex_cells) + " \\\\")
        rows_typ.append("    " + ", ".join(typ_cells) + ",")
        csv_records.append(csv_row)
    
    rows_tex.append("    \\bottomrule")
    rows_tex.append("  \\end{tabular}")
    rows_tex.append("\\end{table}")
    
    rows_typ.append("    table.hline(),")
    rows_typ.append("  ),")
    rows_typ.append(f") <tab:{output_base}>")
    
    # Simpan file
    with open(HASIL_DIR / f"{output_base}.md", "w", encoding="utf-8") as f:
        f.write("\n".join(rows_md) + "\n")
    with open(HASIL_DIR / f"{output_base}.tex", "w", encoding="utf-8") as f:
        f.write("\n".join(rows_tex) + "\n")
    with open(HASIL_DIR / f"{output_base}.typ", "w", encoding="utf-8") as f:
        f.write("\n".join(rows_typ) + "\n")
    pd.DataFrame(csv_records).to_csv(HASIL_DIR / f"{output_base}.csv", index=False)

def generate_table_0(df):
    """Tabel Baseline Naif dan Model Acuan di Duomo."""
    sub0 = df[df["bagian"] == "0"]
    stats0 = sub0.groupby("model").agg({
        "param": "first",
        "val_MAE": ["mean", "std"],
        "test_MAE": ["mean", "std"],
        "test_MAPE": ["mean", "std"],
        "natal_MAE": ["mean", "std"]
    })
    
    # Muat baseline naif
    duomo_naif_file = HASIL_DIR / "baseline_naif_duomo.csv"
    naif_rows = []
    if duomo_naif_file.exists():
        ndf = pd.read_csv(duomo_naif_file)
        ndf1 = ndf[ndf["horizon"] == 1]
        for m_name in ndf1["model"].unique():
            sub_m = ndf1[ndf1["model"] == m_name]
            v_val = sub_m[sub_m["split"] == "val"]["MAE"].values[0] if len(sub_m[sub_m["split"] == "val"]) else np.nan
            t_val = sub_m[sub_m["split"] == "test"]["MAE"].values[0] if len(sub_m[sub_m["split"] == "test"]) else np.nan
            p_val = sub_m[sub_m["split"] == "test"]["MAPE"].values[0] if len(sub_m[sub_m["split"] == "test"]) else np.nan
            n_val = sub_m[sub_m["split"] == "natal"]["MAE"].values[0] if len(sub_m[sub_m["split"] == "natal"]) else np.nan
            naif_rows.append((m_name, 0, v_val, 0.0, t_val, 0.0, p_val, 0.0, n_val, 0.0))
    
    # Susun Markdown & CSV
    md_lines = [
        "# Tabel Baseline Naif dan Model Acuan (Duomo, Kotak 5060, Horizon=1)",
        "",
        "| Model / Metode | Parameter | Val MAE | Test MAE | Test MAPE (%) | Natal MAE |",
        "|:---|:---:|:---:|:---:|:---:|:---:|",
    ]
    csv_rows = []
    for row in naif_rows:
        md_lines.append(f"| {row[0]} | {row[1]} | {format_mean_std(row[2], 0.0)} | {format_mean_std(row[4], 0.0)} | {format_mean_std(row[6], 0.0)}% | {format_mean_std(row[8], 0.0)} |")
        csv_rows.append({
            "metode": row[0], "param": row[1],
            "val_MAE_mean": round(row[2], 2), "val_MAE_std": 0.0, "val_MAE_formatted": format_mean_std(row[2], 0.0),
            "test_MAE_mean": round(row[4], 2), "test_MAE_std": 0.0, "test_MAE_formatted": format_mean_std(row[4], 0.0),
            "test_MAPE_mean": round(row[6], 2), "test_MAPE_std": 0.0, "test_MAPE_formatted": f"{row[6]:.1f}%",
            "natal_MAE_mean": round(row[8], 2), "natal_MAE_std": 0.0, "natal_MAE_formatted": format_mean_std(row[8], 0.0)
        })
    for m in MODELS:
        row = stats0.loc[m]
        p = int(row[("param", "first")])
        vm, vs = row[("val_MAE", "mean")], row[("val_MAE", "std")]
        tm, ts = row[("test_MAE", "mean")], row[("test_MAE", "std")]
        pm, ps = row[("test_MAPE", "mean")], row[("test_MAPE", "std")]
        nm, ns = row[("natal_MAE", "mean")], row[("natal_MAE", "std")]
        md_lines.append(f"| **{m} (Acuan)** | {p:,} | {format_mean_std(vm, vs)} | {format_mean_std(tm, ts)} | {format_mean_std(pm, ps)}% | {format_mean_std(nm, ns)} |")
        csv_rows.append({
            "metode": f"{m} (Acuan)", "param": p,
            "val_MAE_mean": round(vm, 2), "val_MAE_std": round(vs, 2), "val_MAE_formatted": format_mean_std(vm, vs),
            "test_MAE_mean": round(tm, 2), "test_MAE_std": round(ts, 2), "test_MAE_formatted": format_mean_std(tm, ts),
            "test_MAPE_mean": round(pm, 2), "test_MAPE_std": round(ps, 2), "test_MAPE_formatted": f"{pm:.1f}%",
            "natal_MAE_mean": round(nm, 2), "natal_MAE_std": round(ns, 2), "natal_MAE_formatted": format_mean_std(nm, ns)
        })
    
    with open(HASIL_DIR / "tabel_0_baseline_dan_acuan.md", "w", encoding="utf-8") as f:
        f.write("\n".join(md_lines) + "\n")
    pd.DataFrame(csv_rows).to_csv(HASIL_DIR / "tabel_0_baseline_dan_acuan.csv", index=False)
    
    # Susun LaTeX
    tex_lines = [
        "\\begin{table}[t]",
        "  \\centering",
        "  \\caption{Baseline Naif dan Konfigurasi Acuan di Duomo ($H=1$, rata-rata $\\pm$ SD, 3 seed)}",
        "  \\label{tab:baseline_acuan}",
        "  \\begin{tabular}{@{}lccccc@{}}",
        "    \\toprule",
        "    Metode / Model & Param & Val MAE & Test MAE & Test MAPE (\\%) & Natal MAE \\\\",
        "    \\midrule",
    ]
    for row in naif_rows:
        tex_lines.append(f"    {row[0]} & {row[1]} & {format_mean_std(row[2], 0.0, is_latex=True)} & {format_mean_std(row[4], 0.0, is_latex=True)} & {format_mean_std(row[6], 0.0, is_latex=True)} & {format_mean_std(row[8], 0.0, is_latex=True)} \\\\")
    tex_lines.append("    \\midrule")
    for m in MODELS:
        row = stats0.loc[m]
        p = int(row[("param", "first")])
        vm, vs = row[("val_MAE", "mean")], row[("val_MAE", "std")]
        tm, ts = row[("test_MAE", "mean")], row[("test_MAE", "std")]
        pm, ps = row[("test_MAPE", "mean")], row[("test_MAPE", "std")]
        nm, ns = row[("natal_MAE", "mean")], row[("natal_MAE", "std")]
        tex_lines.append(f"    \\textbf{{{m}}} (Acuan) & {p:,} & {format_mean_std(vm, vs, is_latex=True)} & {format_mean_std(tm, ts, is_latex=True)} & {format_mean_std(pm, ps, is_latex=True)} & {format_mean_std(nm, ns, is_latex=True)} \\\\")
    tex_lines.extend([
        "    \\bottomrule",
        "  \\end{tabular}",
        "\\end{table}"
    ])
    with open(HASIL_DIR / "tabel_0_baseline_dan_acuan.tex", "w", encoding="utf-8") as f:
        f.write("\n".join(tex_lines) + "\n")

def generate_table_C_and_D(df):
    """Tabel C (Terbaik vs Acuan di Duomo) dan Tabel D (Generalisasi di Navigli)."""
    # Bagian C
    acuan_df = df[df["bagian"] == "0"]
    terbaik_df = df[df["bagian"] == "C"]
    
    md_c = [
        "# Tabel Bagian C: Konfigurasi Gabungan Terbaik vs Acuan di Duomo",
        "",
        "| Model | Konfigurasi | Parameter | Val MAE | Test MAE | Test MAPE (%) | Natal MAE |",
        "|:---:|:---:|:---:|:---:|:---:|:---:|:---:|",
    ]
    tex_c = [
        "\\begin{table}[t]",
        "  \\centering",
        "  \\caption{Perbandingan Konfigurasi Acuan vs Terbaik per Model di Duomo (3 seed)}",
        "  \\label{tab:terbaik_duomo}",
        "  \\begin{tabular}{@{}llccccc@{}}",
        "    \\toprule",
        "    Model & Konfigurasi & Param & Val MAE & Test MAE & Test MAPE (\\%) & Natal MAE \\\\",
        "    \\midrule",
    ]
    csv_c = []
    
    for m in MODELS:
        a_sub = acuan_df[acuan_df["model"] == m]
        c_sub = terbaik_df[terbaik_df["model"] == m]
        
        ap = int(a_sub["param"].iloc[0])
        av_m, av_s = a_sub["val_MAE"].mean(), a_sub["val_MAE"].std()
        at_m, at_s = a_sub["test_MAE"].mean(), a_sub["test_MAE"].std()
        ap_m, ap_s = a_sub["test_MAPE"].mean(), a_sub["test_MAPE"].std()
        an_m, an_s = a_sub["natal_MAE"].mean(), a_sub["natal_MAE"].std()
        
        cp = int(c_sub["param"].iloc[0]) if not c_sub.empty else ap
        cv_m, cv_s = (c_sub["val_MAE"].mean(), c_sub["val_MAE"].std()) if not c_sub.empty else (av_m, av_s)
        ct_m, ct_s = (c_sub["test_MAE"].mean(), c_sub["test_MAE"].std()) if not c_sub.empty else (at_m, at_s)
        cp_m, cp_s = (c_sub["test_MAPE"].mean(), c_sub["test_MAPE"].std()) if not c_sub.empty else (ap_m, ap_s)
        cn_m, cn_s = (c_sub["natal_MAE"].mean(), c_sub["natal_MAE"].std()) if not c_sub.empty else (an_m, an_s)
        
        c_better = (ct_m < at_m)
        
        md_c.append(f"| {m} | Acuan | {ap:,} | {format_mean_std(av_m, av_s)} | {format_mean_std(at_m, at_s)} | {format_mean_std(ap_m, ap_s)}% | {format_mean_std(an_m, an_s)} |")
        md_c.append(f"| {m} | **Terbaik** | {cp:,} | {format_mean_std(cv_m, cv_s)} | {format_mean_std(ct_m, ct_s, bold=c_better)} | {format_mean_std(cp_m, cp_s)}% | {format_mean_std(cn_m, cn_s)} |")
        
        tex_c.append(f"    \\multirow{{2}}{{*}}{{{m}}} & Acuan & {ap:,} & {format_mean_std(av_m, av_s, is_latex=True)} & {format_mean_std(at_m, at_s, is_latex=True)} & {format_mean_std(ap_m, ap_s, is_latex=True)} & {format_mean_std(an_m, an_s, is_latex=True)} \\\\")
        tex_c.append(f"     & \\textbf{{Terbaik}} & {cp:,} & {format_mean_std(cv_m, cv_s, is_latex=True)} & {format_mean_std(ct_m, ct_s, is_latex=True, bold=c_better)} & {format_mean_std(cp_m, cp_s, is_latex=True)} & {format_mean_std(cn_m, cn_s, is_latex=True)} \\\\")
        tex_c.append("    \\midrule" if m != MODELS[-1] else "    \\bottomrule")
        
        csv_c.extend([
            {"model": m, "konfigurasi": "Acuan", "param": ap, "val_MAE_mean": round(av_m, 2), "val_MAE_std": round(av_s, 2), "test_MAE_mean": round(at_m, 2), "test_MAE_std": round(at_s, 2), "natal_MAE_mean": round(an_m, 2), "natal_MAE_std": round(an_s, 2)},
            {"model": m, "konfigurasi": "Terbaik", "param": cp, "val_MAE_mean": round(cv_m, 2), "val_MAE_std": round(cv_s, 2), "test_MAE_mean": round(ct_m, 2), "test_MAE_std": round(ct_s, 2), "natal_MAE_mean": round(cn_m, 2), "natal_MAE_std": round(cn_s, 2)}
        ])

    tex_c.extend(["  \\end{tabular}", "\\end{table}"])
    
    with open(HASIL_DIR / "tabel_C_terbaik_vs_acuan.md", "w", encoding="utf-8") as f:
        f.write("\n".join(md_c) + "\n")
    with open(HASIL_DIR / "tabel_C_terbaik_vs_acuan.tex", "w", encoding="utf-8") as f:
        f.write("\n".join(tex_c) + "\n")
    pd.DataFrame(csv_c).to_csv(HASIL_DIR / "tabel_C_terbaik_vs_acuan.csv", index=False)
        
    # Bagian D (Navigli)
    d_acuan = df[df["bagian"] == "D-acuan"]
    d_terbaik = df[df["bagian"] == "D-terbaik"]
    
    md_d = [
        "# Tabel Bagian D: Evaluasi Generalisasi di Navigli (Kotak 4555, Kode 1)",
        "",
        "| Model | Konfigurasi | Parameter | Val MAE | Test MAE | Test MAPE (%) | Natal MAE |",
        "|:---:|:---:|:---:|:---:|:---:|:---:|:---:|",
    ]
    tex_d = [
        "\\begin{table}[t]",
        "  \\centering",
        "  \\caption{Uji Generalisasi di Navigli (Kotak 4555, Kode 1, 3 seed)}",
        "  \\label{tab:generalisasi_navigli}",
        "  \\begin{tabular}{@{}llccccc@{}}",
        "    \\toprule",
        "    Model & Konfigurasi & Param & Val MAE & Test MAE & Test MAPE (\\%) & Natal MAE \\\\",
        "    \\midrule",
    ]
    csv_d = []
    
    for m in MODELS:
        a_sub = d_acuan[d_acuan["model"] == m]
        c_sub = d_terbaik[d_terbaik["model"] == m]
        
        ap = int(a_sub["param"].iloc[0])
        av_m, av_s = a_sub["val_MAE"].mean(), a_sub["val_MAE"].std()
        at_m, at_s = a_sub["test_MAE"].mean(), a_sub["test_MAE"].std()
        ap_m, ap_s = a_sub["test_MAPE"].mean(), a_sub["test_MAPE"].std()
        an_m, an_s = a_sub["natal_MAE"].mean(), a_sub["natal_MAE"].std()
        
        cp = int(c_sub["param"].iloc[0]) if not c_sub.empty else ap
        cv_m, cv_s = (c_sub["val_MAE"].mean(), c_sub["val_MAE"].std()) if not c_sub.empty else (av_m, av_s)
        ct_m, ct_s = (c_sub["test_MAE"].mean(), c_sub["test_MAE"].std()) if not c_sub.empty else (at_m, at_s)
        cp_m, cp_s = (c_sub["test_MAPE"].mean(), c_sub["test_MAPE"].std()) if not c_sub.empty else (ap_m, ap_s)
        cn_m, cn_s = (c_sub["natal_MAE"].mean(), c_sub["natal_MAE"].std()) if not c_sub.empty else (an_m, an_s)
        
        c_better = (ct_m < at_m)
        
        md_d.append(f"| {m} | Acuan | {ap:,} | {format_mean_std(av_m, av_s)} | {format_mean_std(at_m, at_s)} | {format_mean_std(ap_m, ap_s)}% | {format_mean_std(an_m, an_s)} |")
        md_d.append(f"| {m} | **Terbaik** | {cp:,} | {format_mean_std(cv_m, cv_s)} | {format_mean_std(ct_m, ct_s, bold=c_better)} | {format_mean_std(cp_m, cp_s)}% | {format_mean_std(cn_m, cn_s)} |")
        
        tex_d.append(f"    \\multirow{{2}}{{*}}{{{m}}} & Acuan & {ap:,} & {format_mean_std(av_m, av_s, is_latex=True)} & {format_mean_std(at_m, at_s, is_latex=True)} & {format_mean_std(ap_m, ap_s, is_latex=True)} & {format_mean_std(an_m, an_s, is_latex=True)} \\\\")
        tex_d.append(f"     & \\textbf{{Terbaik}} & {cp:,} & {format_mean_std(cv_m, cv_s, is_latex=True)} & {format_mean_std(ct_m, ct_s, is_latex=True, bold=c_better)} & {format_mean_std(cp_m, cp_s, is_latex=True)} & {format_mean_std(cn_m, cn_s, is_latex=True)} \\\\")
        tex_d.append("    \\midrule" if m != MODELS[-1] else "    \\bottomrule")
        
        csv_d.extend([
            {"model": m, "konfigurasi": "Acuan", "param": ap, "val_MAE_mean": round(av_m, 2), "val_MAE_std": round(av_s, 2), "test_MAE_mean": round(at_m, 2), "test_MAE_std": round(at_s, 2), "natal_MAE_mean": round(an_m, 2), "natal_MAE_std": round(an_s, 2)},
            {"model": m, "konfigurasi": "Terbaik", "param": cp, "val_MAE_mean": round(cv_m, 2), "val_MAE_std": round(cv_s, 2), "test_MAE_mean": round(ct_m, 2), "test_MAE_std": round(ct_s, 2), "natal_MAE_mean": round(cn_m, 2), "natal_MAE_std": round(cn_s, 2)}
        ])
        
    tex_d.extend(["  \\end{tabular}", "\\end{table}"])
    
    with open(HASIL_DIR / "tabel_D_generalisasi_navigli.md", "w", encoding="utf-8") as f:
        f.write("\n".join(md_d) + "\n")
    with open(HASIL_DIR / "tabel_D_generalisasi_navigli.tex", "w", encoding="utf-8") as f:
        f.write("\n".join(tex_d) + "\n")
    pd.DataFrame(csv_d).to_csv(HASIL_DIR / "tabel_D_generalisasi_navigli.csv", index=False)

def plot_ieee_single_col(df, bagian, faktor_nama, nilai_list, label_x, output_name, log_x=False):
    """
    Plot single column IEEE: 3.5 inci lebar x 2.4 inci tinggi.
    Fokus pada Test MAE dengan errorbar (mean ± 1 SD).
    """
    setup_matplotlib_ieee(single_col=True)
    fig, ax = plt.subplots(figsize=(3.5, 2.4))
    
    sub = df[df["bagian"] == bagian]
    urutan = [str(x) for x in nilai_list]
    
    for m in MODELS:
        m_sub = sub[sub["model"] == m]
        r = m_sub.groupby("nilai", sort=False)["test_MAE"].agg(["mean", "std"]).reindex(urutan)
        if r.empty or r["mean"].isna().all():
            continue
        
        x = np.arange(len(urutan))
        ax.errorbar(
            x, r["mean"], yerr=r["std"].fillna(0),
            label=m, color=WARNA_MODEL[m], marker=MARKER_MODEL[m],
            capsize=2.5, elinewidth=1.0, capthick=1.0, alpha=0.9
        )
    
    ax.set_xticks(np.arange(len(urutan)))
    ax.set_xticklabels(urutan, rotation=20 if any(len(s) > 4 for s in urutan) else 0)
    ax.set_xlabel(label_x)
    ax.set_ylabel("Test MAE")
    ax.legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85, loc="best", ncol=2)
    
    out_path = HASIL_DIR / output_name
    plt.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close()

def plot_ieee_wide(df, bagian, faktor_nama, nilai_list, label_x, output_name):
    """
    Plot double column IEEE: 7.0 inci lebar x 2.4 inci tinggi.
    Dua panel berdampingan: Val MAE (kiri) dan Test MAE (kanan).
    """
    setup_matplotlib_ieee(single_col=False)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 2.4), sharey=True)
    
    sub = df[df["bagian"] == bagian]
    urutan = [str(x) for x in nilai_list]
    
    for ax, split in zip(axes, ["val", "test"]):
        for m in MODELS:
            m_sub = sub[sub["model"] == m]
            r = m_sub.groupby("nilai", sort=False)[f"{split}_MAE"].agg(["mean", "std"]).reindex(urutan)
            if r.empty or r["mean"].isna().all():
                continue
            x = np.arange(len(urutan))
            ax.errorbar(
                x, r["mean"], yerr=r["std"].fillna(0),
                label=m, color=WARNA_MODEL[m], marker=MARKER_MODEL[m],
                capsize=2.5, elinewidth=1.0, capthick=1.0, alpha=0.9
            )
            ax.set_xticks(x)
            ax.set_xticklabels(urutan, rotation=15 if any(len(s) > 4 for s in urutan) else 0)
        ax.set_title(f"Akurasi {split.capitalize()} Set", fontweight="bold")
        ax.set_xlabel(label_x)
    
    axes[0].set_ylabel("MAE (Aktivitas)")
    axes[1].legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85, loc="best", ncol=2)
    
    out_path = HASIL_DIR / output_name
    plt.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close()

def plot_ieee_param_capacity(df):
    """Plot Kapasitas Parameter vs MAE (skala log x) untuk IEEE column."""
    setup_matplotlib_ieee(single_col=True)
    fig, ax = plt.subplots(figsize=(3.5, 2.4))
    
    sub = df[df["bagian"] == "A2"]
    for m in MODELS:
        m_sub = sub[sub["model"] == m]
        r = m_sub.groupby("param")["test_MAE"].agg(["mean", "std"]).sort_index()
        if r.empty:
            continue
        ax.errorbar(
            r.index, r["mean"], yerr=r["std"].fillna(0),
            label=m, color=WARNA_MODEL[m], marker=MARKER_MODEL[m],
            capsize=2.5, elinewidth=1.0, alpha=0.9
        )
    ax.set_xscale("log")
    ax.set_xlabel("Jumlah Parameter (skala log)")
    ax.set_ylabel("Test MAE")
    ax.legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85, loc="best", ncol=2)
    
    plt.savefig(HASIL_DIR / "ieee_col_A2_param.png", dpi=300, bbox_inches="tight")
    plt.close()
    
    # Wide version
    setup_matplotlib_ieee(single_col=False)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 2.4), sharey=True)
    for ax, split in zip(axes, ["val", "test"]):
        for m in MODELS:
            m_sub = sub[sub["model"] == m]
            r = m_sub.groupby("param")[f"{split}_MAE"].agg(["mean", "std"]).sort_index()
            if r.empty:
                continue
            ax.errorbar(
                r.index, r["mean"], yerr=r["std"].fillna(0),
                label=m, color=WARNA_MODEL[m], marker=MARKER_MODEL[m],
                capsize=2.5, elinewidth=1.0, alpha=0.9
            )
        ax.set_xscale("log")
        ax.set_title(f"{split.capitalize()} MAE vs Kapasitas", fontweight="bold")
        ax.set_xlabel("Jumlah Parameter (skala log)")
    axes[0].set_ylabel("MAE")
    axes[1].legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85, loc="best", ncol=2)
    plt.savefig(HASIL_DIR / "ieee_wide_A2_param.png", dpi=300, bbox_inches="tight")
    plt.close()

def plot_ieee_terbaik_vs_acuan(df):
    """Bar chart Acuan vs Terbaik untuk Test MAE dan Natal MAE."""
    setup_matplotlib_ieee(single_col=True)
    fig, ax = plt.subplots(figsize=(3.5, 2.4))
    
    acuan_df = df[df["bagian"] == "0"]
    terbaik_df = df[df["bagian"] == "C"]
    
    x = np.arange(len(MODELS))
    width = 0.36
    
    a_means = [acuan_df[acuan_df["model"] == m]["test_MAE"].mean() for m in MODELS]
    a_stds = [acuan_df[acuan_df["model"] == m]["test_MAE"].std() for m in MODELS]
    t_means = [terbaik_df[terbaik_df["model"] == m]["test_MAE"].mean() for m in MODELS]
    t_stds = [terbaik_df[terbaik_df["model"] == m]["test_MAE"].std() for m in MODELS]
    
    ax.bar(x - width/2, a_means, width, yerr=a_stds, label="Acuan", color=GRAY, alpha=0.7, capsize=2)
    ax.bar(x + width/2, t_means, width, yerr=t_stds, label="Terbaik", color=[WARNA_MODEL[m] for m in MODELS], alpha=0.95, capsize=2)
    
    ax.set_xticks(x)
    ax.set_xticklabels(MODELS)
    ax.set_ylabel("Test MAE (Duomo)")
    ax.legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85)
    
    plt.savefig(HASIL_DIR / "ieee_col_C_terbaik_vs_acuan.png", dpi=300, bbox_inches="tight")
    plt.close()
    
    # Wide version (Test MAE & Natal MAE)
    setup_matplotlib_ieee(single_col=False)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 2.4))
    
    for ax, split, label in zip(axes, ["test", "natal"], ["Test MAE (16–22 Des)", "Natal MAE (23–29 Des)"]):
        am = [acuan_df[acuan_df["model"] == m][f"{split}_MAE"].mean() for m in MODELS]
        as_ = [acuan_df[acuan_df["model"] == m][f"{split}_MAE"].std() for m in MODELS]
        tm = [terbaik_df[terbaik_df["model"] == m][f"{split}_MAE"].mean() for m in MODELS]
        ts_ = [terbaik_df[terbaik_df["model"] == m][f"{split}_MAE"].std() for m in MODELS]
        
        ax.bar(x - width/2, am, width, yerr=as_, label="Acuan", color=GRAY, alpha=0.65, capsize=2)
        ax.bar(x + width/2, tm, width, yerr=ts_, label="Terbaik", color=[WARNA_MODEL[m] for m in MODELS], alpha=0.95, capsize=2)
        ax.set_xticks(x)
        ax.set_xticklabels(MODELS)
        ax.set_title(label, fontweight="bold")
        ax.set_ylabel("MAE")
        ax.legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85)
    
    plt.savefig(HASIL_DIR / "ieee_wide_C_terbaik_vs_acuan.png", dpi=300, bbox_inches="tight")
    plt.close()

def plot_ieee_generalisasi(df):
    """Bar chart Duomo vs Navigli per model."""
    setup_matplotlib_ieee(single_col=True)
    fig, ax = plt.subplots(figsize=(3.5, 2.4))
    
    d_acuan = df[df["bagian"] == "D-acuan"]
    d_terbaik = df[df["bagian"] == "D-terbaik"]
    
    x = np.arange(len(MODELS))
    width = 0.36
    
    a_means = [d_acuan[d_acuan["model"] == m]["test_MAE"].mean() for m in MODELS]
    a_stds = [d_acuan[d_acuan["model"] == m]["test_MAE"].std() for m in MODELS]
    t_means = [d_terbaik[d_terbaik["model"] == m]["test_MAE"].mean() for m in MODELS]
    t_stds = [d_terbaik[d_terbaik["model"] == m]["test_MAE"].std() for m in MODELS]
    
    ax.bar(x - width/2, a_means, width, yerr=a_stds, label="Acuan", color=GRAY, alpha=0.7, capsize=2)
    ax.bar(x + width/2, t_means, width, yerr=t_stds, label="Terbaik", color=[WARNA_MODEL[m] for m in MODELS], alpha=0.95, capsize=2)
    ax.set_xticks(x)
    ax.set_xticklabels(MODELS)
    ax.set_ylabel("Test MAE (Navigli)")
    ax.legend(frameon=True, facecolor="white", edgecolor="none", framealpha=0.85)
    
    plt.savefig(HASIL_DIR / "ieee_col_D_generalisasi.png", dpi=300, bbox_inches="tight")
    plt.close()
    
    # Wide version (Duomo vs Navigli)
    duomo_terbaik = df[df["bagian"] == "C"]
    setup_matplotlib_ieee(single_col=False)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 2.4), sharey=True)
    
    # Panel Duomo
    dm = [duomo_terbaik[duomo_terbaik["model"] == m]["test_MAE"].mean() for m in MODELS]
    ds = [duomo_terbaik[duomo_terbaik["model"] == m]["test_MAE"].std() for m in MODELS]
    axes[0].bar(x, dm, width*1.5, yerr=ds, color=[WARNA_MODEL[m] for m in MODELS], alpha=0.9, capsize=2.5)
    axes[0].set_xticks(x)
    axes[0].set_xticklabels(MODELS)
    axes[0].set_title("Duomo (Kotak 5060, Pusat Bisnis)", fontweight="bold")
    axes[0].set_ylabel("Test MAE")
    
    # Panel Navigli
    nm = [d_terbaik[d_terbaik["model"] == m]["test_MAE"].mean() for m in MODELS]
    ns = [d_terbaik[d_terbaik["model"] == m]["test_MAE"].std() for m in MODELS]
    axes[1].bar(x, nm, width*1.5, yerr=ns, color=[WARNA_MODEL[m] for m in MODELS], alpha=0.9, capsize=2.5)
    axes[1].set_xticks(x)
    axes[1].set_xticklabels(MODELS)
    axes[1].set_title("Navigli (Kotak 4555, Kanal/Hiburan)", fontweight="bold")
    
    plt.savefig(HASIL_DIR / "ieee_wide_D_generalisasi.png", dpi=300, bbox_inches="tight")
    plt.close()

def sync_figures_to_reports():
    """Menyalin gambar grafik IEEE ke laporan-latex/gambar/ dan laporan-typst/gambar/."""
    for target_dir in [LATEX_GAMBAR_DIR, TYPST_GAMBAR_DIR]:
        if target_dir.exists():
            for f in HASIL_DIR.glob("ieee_*.png"):
                shutil.copy2(f, target_dir / f.name)
            for f in HASIL_DIR.glob("*.png"):
                shutil.copy2(f, target_dir / f.name)
    print("  [OK] Seluruh gambar disinkronkan ke folder laporan-latex dan laporan-typst")

def main():
    print("Memuat dataset ablasi...")
    df = load_data()
    print(f"Total baris dimuat: {len(df)}")
    
    # 1. Tabel-tabel
    print("\n--- Menghasilkan Tabel-Tabel Final ---")
    generate_table_0(df)
    print("  [OK] tabel_0_baseline_dan_acuan (.md, .tex, .csv)")
    
    faktor_configs = [
        ("A1", "W", [6, 12, 24, 48, 168], "Panjang Jendela W (jam)", "tabel_A1_W"),
        ("A2", "hidden", [16, 32, 64, 128], "Ukuran Hidden", "tabel_A2_hidden"),
        ("A3", "layers", [1, 2, 3], "Jumlah Lapisan", "tabel_A3_layers"),
        ("A4", "lr", [0.0001, 0.001, 0.01], "Learning Rate", "tabel_A4_lr"),
        ("A5", "fitur", ["net", "net+call+sms", "net+waktu", "semua"], "Kelompok Fitur", "tabel_A5_fitur"),
        ("B2", "dropout", [0.0, 0.2, 0.5], "Dropout Rate", "tabel_B2_dropout"),
        ("B6", "horizon", [1, 6, 24], "Horizon Peramalan (jam)", "tabel_B6_horizon"),
    ]
    
    for bag, fak, vals, lbl, base in faktor_configs:
        generate_table_factor(df, bag, fak, vals, lbl, base, metric="val_MAE")
        print(f"  [OK] {base} (.md, .tex, .typ, .csv)")
    
    generate_table_C_and_D(df)
    print("  [OK] tabel_C_terbaik_vs_acuan (.md, .tex, .csv)")
    print("  [OK] tabel_D_generalisasi_navigli (.md, .tex, .csv)")
    
    # 2. Grafik-Grafik IEEE
    print("\n--- Menghasilkan Grafik Final Kolom IEEE (300 DPI) ---")
    plot_faktor_configs = [
        ("A1", "W", [6, 12, 24, 48, 168], "Panjang Jendela W (jam)", "ieee_col_A1_W.png", "ieee_wide_A1_W.png"),
        ("A2", "hidden", [16, 32, 64, 128], "Ukuran Hidden", "ieee_col_A2_hidden.png", "ieee_wide_A2_hidden.png"),
        ("A3", "layers", [1, 2, 3], "Jumlah Lapisan", "ieee_col_A3_layers.png", "ieee_wide_A3_layers.png"),
        ("A4", "lr", [0.0001, 0.001, 0.01], "Learning Rate", "ieee_col_A4_lr.png", "ieee_wide_A4_lr.png"),
        ("A5", "fitur", ["net", "net+call+sms", "net+waktu", "semua"], "Kelompok Fitur", "ieee_col_A5_fitur.png", "ieee_wide_A5_fitur.png"),
        ("B2", "dropout", [0.0, 0.2, 0.5], "Tingkat Dropout", "ieee_col_B2_dropout.png", "ieee_wide_B2_dropout.png"),
        ("B6", "horizon", [1, 6, 24], "Horizon H (jam)", "ieee_col_B6_horizon.png", "ieee_wide_B6_horizon.png"),
    ]
    
    for bag, fak, vals, lbl, f_col, f_wide in plot_faktor_configs:
        plot_ieee_single_col(df, bag, fak, vals, lbl, f_col)
        plot_ieee_wide(df, bag, fak, vals, lbl, f_wide)
        print(f"  [OK] {f_col} (Single Col: 3.5\") & {f_wide} (Double Col: 7.0\")")
    
    plot_ieee_param_capacity(df)
    print("  [OK] ieee_col_A2_param.png & ieee_wide_A2_param.png")
    
    plot_ieee_terbaik_vs_acuan(df)
    print("  [OK] ieee_col_C_terbaik_vs_acuan.png & ieee_wide_C_terbaik_vs_acuan.png")
    
    plot_ieee_generalisasi(df)
    print("  [OK] ieee_col_D_generalisasi.png & ieee_wide_D_generalisasi.png")
    
    # Sinkronisasi gambar
    print("\n--- Menyinkronkan Gambar ke Template Laporan ---")
    sync_figures_to_reports()
    
    print("\nSemua tabel dan grafik final IEEE berhasil digenerate di folder hasil/!")

if __name__ == "__main__":
    main()
