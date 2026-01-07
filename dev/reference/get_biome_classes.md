# Get the biome classes for a dataset.

Get a full list of biomes and how their id as coded in the biome
variable for a given dataset.

## Usage

``` r
get_biome_classes(dataset)
```

## Arguments

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/dev/reference/list_available_datasets.md)).
  This function will not work on custom datasets.

## Value

a data.frame with columns id and category.
