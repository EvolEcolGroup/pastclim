# Documentation for *CHELSA-TracCE21k*

CHELSA-TraCE21k data provides monthly climate data for temperature and
precipitation at 30 arc-sec spatial resolution in 100-year time steps
for the last 21,000 years. Palaeo-orography at high spatial resolution
and at each time step is created by combining high resolution
information on glacial cover from current and Last Glacial Maximum (LGM)
glacier databases with the interpolation of a dynamic ice sheet model
(ICE6G) and a coupling to mean annual temperatures from CCSM3-TraCE21k.
Based on the reconstructed palaeo-orography, mean annual temperature and
precipitation was downscaled using the CHELSA V1.2 algorithm.

## Details

More details on the dataset are available on its dedicated
[website](https://chelsa-climate.org/chelsa-trace21k/).

An alternative to downloading very large files is to use virtual
rasters. Simply append "\_vis" to the name of the dataset of interest
(*CHELSA_trace21k_1.0_0.5m_vsi*). This is the recommended approach, and
it is currently the only available version of the dataset.

IMPORTANT: If you use this dataset, make sure to cite the original
publication:

Karger, D.N., Nobis, M.P., Normand, S., Graham, C.H., Zimmermann, N.
(2023) CHELSA-TraCE21k – High resolution (1 km) downscaled transient
temperature and precipitation data since the Last Glacial Maximum.
Climate of the Past.
[doi:10.5194/cp-2021-30](https://doi.org/10.5194/cp-2021-30)

## Note

There is a missing time slice at -1300 years BP for `temperature_min_07`
and `temperature_max_07` on the CHELSA server. That timestep is replaced
with -1200 years BP in `pastclim` for those two variables.
