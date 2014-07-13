# UOY Bus Interaction Planning

## Interaction mechanics
(1) I am here, going here. Next bus?
(2) When are the next buses from A in B direction?

(2) is simpler to build but offers less. Forces us to use the earliest stop.

---

## Areas
- Hes East
- Field Ln
- Hes Hall
- Library Bridge
- Wentworth Way
- Hes Road
- Piccadilly
- Clifford St
- Rougier St
- Railway

---

## Courser Areas (WEST STOP, EAST STOP)
- Hes East (Sport Village-Station & Car Park-Station, TFTV-Sport Village & Field Ln-Car Park)
- Hes West (Hes Hall-Station, Wentworth Way-Sport Village)
- Hes Road (The Retreat-Station, Willis St-Sport Village)
- City Centre (Piccadilly-Station & Clifford St-Station, Piccadilly-Sport Village & Clifford St-Sport Village)
- Railway Station (Station-Acomb, Station-Sport Village)

## Courser Area ATCOCodes (WEST STOP, EAST STOP)
- Hes East (3290YYA03646 & 3290YYA03608, 3290YYA03630 & 3290YYA01011)
- Hes West (3290YYA00279, 3290YYA00282)
- Hes Road (3290YYA00186, 3290YYA00188)
- City Centre (3290YYA00103 & 3290YYA00167, 3290YYA01672 & 3290YYA00168)
- Railway Station (3290YYA00133 & 3290YYA00134, 3290YYA00145)

From                  East 1        East 2        West 1        West 2
UOY Heslington East   3290YYA03630  3290YYA01011  3290YYA03646  3290YYA03608
UOY Heslington West   3290YYA00282                3290YYA00279
Heslington Road       3290YYA00188                3290YYA00186
City Centre           3290YYA01672  3290YYA00168  3290YYA00103  3290YYA00167
Railway Station       3290YYA00145                3290YYA00133  3290YYA00134

---

```
area_atcocode_lookup = {
  "hes_east" => {
    "east" => ["3290YYA03630", "3290YYA01011"],
    "west" => ["3290YYA03646", "3290YYA03608"]
  },
  "hes_west" => {
    "east" => ["3290YYA00282"],
    "west" => ["3290YYA00279"]
  },
  "hes_road" => {
    "east" => ["3290YYA00188"],
    "west" => ["3290YYA00186"]
  },
  "city_centre" => {
    "east" => ["3290YYA01672", "3290YYA00168"],
    "west" => ["3290YYA00103", "3290YYA00167"]
  },
  "railway" => {
    "east" => ["3290YYA00145"],
    "west" => ["3290YYA00133", "3290YYA00134"]
  }
}
```
