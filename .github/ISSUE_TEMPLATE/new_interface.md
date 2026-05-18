---
name: New Interface / Timing Pattern
about: Request or submit a new interface type or timing pattern not covered yet
title: "[INTERFACE] <Interface Name> — <XDC/SDC/LPF>"
labels: new-interface
assignees: ''
---

## Interface Details

**Interface name:** (e.g. PCIe x4, MIPI CSI-2 RX, I3C, MII, SGMII)
**Vendor format needed:** (XDC / SDC / LPF / all three)
**Speed / frequency:** 
**Standard reference:** (e.g. IEEE 802.3, MIPI D-PHY v2.1, PCIe Base Spec 4.0)

---

## Are you submitting a file or requesting one?

- [ ] Submitting — I have a tested template to contribute
- [ ] Requesting — I need this interface and can't find a good reference

---

## If submitting — checklist

- [ ] Includes theory block explaining the interface timing model
- [ ] Timing values derived from a real datasheet (cite it below)
- [ ] Placeholders use `<PIN_NAME>` format for values users must fill in
- [ ] Adjustment guide included explaining what to change per device
- [ ] Both XDC and SDC provided (LPF if applicable to Lattice)

---

## Datasheet / Standard reference

**Device/chip used for timing values:** 
**Datasheet parameter names used:** (e.g. tSU, tH, tCO_max)
**Standard document:** 

---

## Paste constraint file

```tcl
# paste your .xdc / .sdc / .lpf here
```

---

## Additional notes

<!-- Any gotchas, board-specific quirks, or things that tripped you up -->
