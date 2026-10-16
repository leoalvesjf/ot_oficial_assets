# Full minimap with markers - OTClient 1525

Source: https://tibiamaps.io/downloads/minimap-with-markers (downloaded 2026-10-15).
Format reference: https://tibiamaps.io/guides/minimap-file-format
Data project and attribution: https://github.com/tibiamaps/tibia-map-data
Original ZIP: 6,608,387 bytes; SHA256:
`90bb8e8aed0ec6970334aa96e5908ff86d5cb56b51f4048881ac38e38a37d942`.

## Conversion settings

The reproducible converter is `tools/convert-minimap.py` in the client repository.
Run Python 3 with the extracted `minimap` directory and a NEW output directory:

```powershell
python tools/convert-minimap.py <extracted-minimap-directory> <new-output-directory>
```

- Input: 1,094 Color PNGs, 1,103 WaypointCost PNGs (256x256), and minimapmarkers.bin.
- Whole world: X/Y 0..65535, floors Z 0..15; no Thais-only crop remains.
- PNG CRCs and filters 0..4 decoded; 8-bit noninterlaced indexed/RGB/RGBA/grayscale.
- A tile is known only if BOTH color and waypoint cost are present and not magenta
  (255,0,255). Unknown cells keep flags=0, color=255, speed=10.
- Color index matches OTClient Color::to8bit: floor(R/51)*36 + floor(G/51)*6 + floor(B/51).
- Known tile flags=1 (WasSeen). Yellow waypoint cost (255,255,0) adds flag=4
  (NotWalkable), producing flags=5. Grayscale friction becomes ceil(value/10),
  clamped to 1..255; blocked cells retain speed=10.
- Each row-major 64x64 block contains 4,096 packed flags/color/speed triples.
  Sorted block keys (X,Y,Z), zlib compression level 3.
- OTMM v1 little-endian header: signature 0x4D4D544F, data offset 22, version 1,
  flags 0, description "OTMM 1.0". Block header: uint16 X/Y, uint8 Z, uint16
  compressed length. End sentinel: X/Y=65535, Z=255.
- Markers: protobuf position fields X/Y/Z, icon 0..19 and UTF-8 description
  preserved in JSON. No Lua scripts or personal profile data in the payload.
- This conversion does not export server OTBM or alter sprites, combat, lights or DAT.

## Output and integrity

| File | Bytes | SHA256 |
| --- | ---: | --- |
| world.otmm | 4,967,534 | 4730c1e4312e03e020ae683a3b2018cb1b7cdd116596b99a9a9883e2d562d561 |
| markers.json | 889,262 | 31a1ad121e335e8a52925fcdafab6e80dea2805a5ceac8648d898cfd8bf3e1ab |

9,604 blocks, 17,508,104 known tiles, 16 floors, 6,398 markers.
manifest.json records the source ZIP hash, sizes and payload hashes; the client also
pins the manifest SHA256. Its snapshot identifier retains the original validated
`tibiamaps-20261015-localtest1` name; this is an identifier, not a localhost address.
Final runtime path: `data/things/1525/map-download/`.

## Validation and distribution

Independent readback checked every OTMM block, decompressed size, coordinates,
flags and EOF; all 68,059 known Thais sample cells and 22 sample markers were retained.
The user confirmed minimap click walking, marker tooltips, full-map display and the
optimized performance. The downloader was tested in the actual client via loopback;
GitHub authenticated retrieval is checked separately during publication.

The client downloads and verifies the three fixed files asynchronously on first use.
A valid installed package works offline. A new profile receives the map and markers;
existing personal exploration and markers are preserved. Map data can differ from
custom server geography and include official points unavailable on this server.

While this repository is private, anonymous raw GitHub requests cannot download it.
Use the client developer bridge with Git credentials kept in memory, or distribute
this folder through the existing launcher. No token belongs in the client package.
See client `docs/minimap-download.md` for configuration, testing and limitations.
