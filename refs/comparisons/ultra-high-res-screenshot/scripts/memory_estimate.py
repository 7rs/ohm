#!/usr/bin/env python3
"""Order-of-magnitude memory estimate for a frame of W x H pixels. Nothing is measured: formats come
from the shader packs' declared colortexNFormat lines (read from the zips), the main/alt texture pair
from Oculus' RenderTarget class (mainTexture and altTexture fields), the rest are assumptions listed below.
usage: memory_estimate.py OUT.csv"""
import csv, sys
# bytes per pixel of the declared formats (3-component 8-bit formats are padded to 4 by drivers; RGB16/RGB16F to 8)
PACKS = {
    "BSL 10.1 (7 declared)":              [4, 4, 8, 4, 4, 8, 8],
    "Complementary r5.10 (14 declared)":  [4, 4, 1, 8, 1, 4, 4, 8, 4, 4, 4, 4, 8, 8],
    "I Like Vanilla 1.5.0b (11 declared)": [4, 4, 8, 8, 4, 4, 4, 2, 2, 4, 2],
    "Mellow 3.5 (5 declared)":            [4, 4, 4, 4, 4],
    "Solas 3.9 (7 declared)":             [4, 4, 8, 8, 8, 8, 8],
}
OTHER = 4 + 4 + 4 + 4  # vanilla main target (RGBA8 + depth 32), Oculus depth copies counted as one 4-byte plane, DH color+depth (4+4) -> assumption 20 B
OTHER = 20
SIZES = [("1080p window", 1920, 1080), ("4K", 3840, 2160), ("8K", 7680, 4320), ("15360x8640", 15360, 8640), ("16384x16384", 16384, 16384)]
rows = [["case", "pixels_MP", "pack", "shader_buffers_GiB (main+alt)", "other_GiB", "total_GPU_GiB", "cpu_readback_RGBA_GiB", "forgeshot_RGB_directbuffer_GiB"]]
for name, w, h in SIZES:
    px = w * h
    cpu = px * 4 / 2**30
    fs = px * 3 / 2**30
    rows.append([name, round(px / 1e6, 1), "no shader pack", 0, round(px * OTHER / 2**30, 2), round(px * OTHER / 2**30, 2), round(cpu, 2), round(fs, 2)])
    for pk, fm in PACKS.items():
        sh = px * sum(fm) * 2 / 2**30
        rows.append([name, round(px / 1e6, 1), pk, round(sh, 2), round(px * OTHER / 2**30, 2), round(sh + px * OTHER / 2**30, 2), round(cpu, 2), round(fs, 2)])
with open(sys.argv[1], "w", newline="") as f:
    csv.writer(f).writerows(rows)
for r in rows: print(*r, sep=" | ")
