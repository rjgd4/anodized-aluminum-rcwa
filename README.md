# Anodized Aluminum – RCWA Reflectance & Color Simulation

MATLAB simulation of the appearance of nanoporous anodic alumina on an
aluminum substrate, using the RCWA (Rigorous Coupled-Wave Analysis) method
with the RETICOLO toolbox.

Nanoporous alumina films on aluminum look orange in the specular direction
and matt and bluish in other directions. This phenomenon comes from the
quasi-periodic structure of the pores. This project models that structure
in 1D to compute the specular reflectance and the resulting color.

> Project carried out at Institut d'Optique Graduate School
> (2AS 2025-2026), supervised by Renée Charrière.
> Script names and code comments are in French.

## Models

1. Random variation of the **pore radius** (Gaussian, std σr)
2. Random variation of the **pore positions** (Gaussian, std σc)
3. Random shift of the **pore edges** (Gaussian, std consistent with the 2D structure)
4. Edge variation with **small secondary pores** between the main pores

A perfectly periodic network and a flat layer are used as references.
25 nanopores per simulation.

## Results

Models 1–3 reproduce the experimental trend well, but are limited by the
1D description of a 2D structure. Model 4 (secondary pores) does not match
the measurements, probably for the same reason.
See `poster/` for the full results and the chromaticity diagram under D65.

## Requirements

- MATLAB
- **RETICOLO toolbox** (not included, download it from its authors and add it to your MATLAB path)

## Usage

1. Install RETICOLO and add it to the MATLAB path.
2. Keep the `.mat` files in the same folder as the scripts.
3. Reflectance: run `aluminium_reflectance_avecmoyenne.m` (averaged
   reflectance) or `Alumine_interface_plane_variation_longeur_onde.m`
   (raw spectral analysis).
4. Color: run `relflectance_chromaticite.m` to convert spectra to CIE
   chromaticity coordinates.

## Repository structure

| Path | Content |
|---|---|
| `matlab/` | Simulation scripts and required data (`.mat`) |
| `poster/` | Project poster (PDF) |

## References

- Kuang et al., *Modeling the specular spectral reflectance of quasi-ordered
  alumina nanopores on an aluminum substrate*
- Faucheu et al., *Structural colors of nanoporous anodic alumina: overview
  of recent advances and case study in elaboration, characterization,
  photometry and modelling*

## Authors

- Robin Jegard
- Mathias Lejeune
