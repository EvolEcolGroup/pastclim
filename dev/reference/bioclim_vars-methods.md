# Compute bioclimatic variables

Function to compute "bioclimatic" variables from monthly average
temperature and precipitation data. For modern data, this variables are
generally computed using min and maximum temperature, but for many
palaeoclimatic reconstructions only average temperature is available.
Most variables, with the exception of BIO02 and BIO03, can be rephrased
meaningfully in terms of mean temperature. This function is a modified
version of `predicts::bcvars`.

## Usage

``` r
bioclim_vars(prec, tavg, ...)

# S4 method for class 'numeric,numeric'
bioclim_vars(prec, tavg)

# S4 method for class 'SpatRaster,SpatRaster'
bioclim_vars(prec, tavg, filename = "", ...)

# S4 method for class 'SpatRasterDataset,SpatRasterDataset'
bioclim_vars(prec, tavg, filename = "", ...)

# S4 method for class 'matrix,matrix'
bioclim_vars(prec, tavg)
```

## Arguments

- prec:

  monthly precipitation

- tavg:

  monthly average temperatures

- ...:

  additional variables for specific methods

- filename:

  filename to save the raster (optional).

## Value

the bioclim variables

## Details

The variables are:

- BIO01 = Annual Mean Temperature

- BIO04 = Temperature Seasonality (standard deviation x 100)

- BIO05 = Max Temperature of Warmest Month

- BIO06 = Min Temperature of Coldest Month

- BIO07 = Temperature Annual Range (P5-P6)

- BIO08 = Mean Temperature of Wettest Quarter

- BIO09 = Mean Temperature of Driest Quarter

- BIO10 = Mean Temperature of Warmest Quarter

- BIO11 = Mean Temperature of Coldest Quarter

- BIO12 = Annual Precipitation

- BIO13 = Precipitation of Wettest Month

- BIO14 = Precipitation of Driest Month

- BIO15 = Precipitation Seasonality (Coefficient of Variation)

- BIO16 = Precipitation of Wettest Quarter

- BIO17 = Precipitation of Driest Quarter

- BIO18 = Precipitation of Warmest Quarter

- BIO19 = Precipitation of Coldest Quarter

These summary Bioclimatic variables are after:

Nix, 1986. A biogeographic analysis of Australian elapid snakes. In: R.
Longmore (ed.). Atlas of elapid snakes of Australia. Australian Flora
and Fauna Series 7. Australian Government Publishing Service, Canberra.

and expanded following the ANUCLIM manual
