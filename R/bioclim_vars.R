#' Compute bioclimatic variables
#'
#' Function to compute "bioclimatic" variables from
#' monthly average temperature and precipitation data. For modern data,
#' this variables are generally computed using min and maximum temperature,
#' but for many palaeoclimatic reconstructions only average temperature is
#' available. Most variables, with the exception of BIO02 and BIO03, can
#' be rephrased meaningfully in terms of mean temperature.
#' This function is a modified version of \code{predicts::bcvars}.
#'
#' The variables are:
#' * BIO01 = Annual Mean Temperature
#' * BIO04 = Temperature Seasonality (standard deviation x 100)
#' * BIO05 = Max Temperature of Warmest Month
#' * BIO06 = Min Temperature of Coldest Month
#' * BIO07 = Temperature Annual Range (P5-P6)
#' * BIO08 = Mean Temperature of Wettest Quarter
#' * BIO09 = Mean Temperature of Driest Quarter
#' * BIO10 = Mean Temperature of Warmest Quarter
#' * BIO11 = Mean Temperature of Coldest Quarter
#' * BIO12 = Annual Precipitation
#' * BIO13 = Precipitation of Wettest Month
#' * BIO14 = Precipitation of Driest Month
#' * BIO15 = Precipitation Seasonality (Coefficient of Variation)
#' * BIO16 = Precipitation of Wettest Quarter
#' * BIO17 = Precipitation of Driest Quarter
#' * BIO18 = Precipitation of Warmest Quarter
#' * BIO19 = Precipitation of Coldest Quarter
#'
#' These summary Bioclimatic variables are after:
#'
#' Nix, 1986. A biogeographic analysis of Australian elapid snakes. In: R. Longmore (ed.).
#'     Atlas of elapid snakes of Australia. Australian Flora and Fauna Series 7.
#'     Australian Government Publishing Service, Canberra.
#'
#'  and expanded following the ANUCLIM manual
#'
#'
#' @param tavg monthly average temperatures
#' @param prec monthly precipitation
#' @param ... additional variables for specific methods
#' @returns the bioclim variables
#' @docType methods
#' @rdname bioclim_vars-methods
#' @importFrom methods setGeneric
#' @export

methods::setGeneric("bioclim_vars", function(prec, tavg, ...) {
  methods::standardGeneric("bioclim_vars")
})

#' @rdname bioclim_vars-methods
#' @export
methods::setMethod(
  "bioclim_vars", signature(prec = "numeric", tavg = "numeric"),
  function(prec, tavg) {
    bioclim_vars(t(as.matrix(prec)), t(as.matrix(tavg)))
  }
)

#' @param filename filename where the raster can be stored.
#' @rdname bioclim_vars-methods
#' @export
methods::setMethod(
  "bioclim_vars", signature(prec = "SpatRaster", tavg = "SpatRaster"),
  function(prec, tavg, filename = "", ...) {
    if (nlyr(prec) != 12) stop("nlyr(prec) is not 12")
    if (nlyr(tavg) != 12) stop("nlyr(tavg) is not 12")


    x <- c(prec, tavg)
    readStart(x)
    on.exit(readStop(x))
    nc <- ncol(x)
    out <- rast(prec, nlyr = 17)
    names(out) <- c(
      "bio01", paste0("bio0", 4:9),
      paste0("bio", 10:19)
    )
    b <- writeStart(out, filename, ...)
    for (i in 1:b$n) {
      d <- readValues(x, b$row[i], b$nrows[i], 1, nc, TRUE, FALSE)
      p <- bioclim_vars(d[, 1:12], d[, 13:24])
      writeValues(out, p, b$row[i], b$nrows[i])
    }
    writeStop(out)
    return(out)
  }
)


#' @param filename filename where the raster can be stored.
#' @rdname bioclim_vars-methods
#' @export
methods::setMethod(
  "bioclim_vars", signature(prec = "SpatRasterDataset", tavg = "SpatRasterDataset"),
  function(prec, tavg, filename = "", ...) {
    if (!all(is_region_series(prec), is_region_series(tavg))) {
      "prec and tavg should be generated with region_series"
    }
    if (!all(
      (nlyr(prec)[1] == nlyr(tavg)[1]),
      (time_bp(prec[[1]]) == time_bp(tavg[[1]]))
    )) {
      stop("prec and tavg should have the same time steps")
    }
    time_slices <- time_bp(prec[[1]])
    # loop over the time slices
    for (i in 1:length(time_slices)) {
      prec_slice <- slice_region_series(prec, time_bp = time_slices[i])
      tavg_slice <- slice_region_series(tavg, time_bp = time_slices[i])
      biovars_slice <- bioclim_vars(prec_slice, tavg_slice)
      # set times in years BP
      time_bp(biovars_slice) <- rep(time_slices[i], terra::nlyr(biovars_slice))
      if (i == 1) {
        biovars_list <- split(biovars_slice, f = 1:17)
      } else {
        for (x in 1:(terra::nlyr(biovars_slice))) {
          biovars_list[[x]] <- c(biovars_list[[x]], biovars_slice[[x]])
        }
      }
    }
    # return the variables as a SpatRasterDataset
    bioclim_sds <- terra::sds(biovars_list)
    names(bioclim_sds) <- c(
      "bio01", paste0("bio0", 4:9),
      paste0("bio", 10:19)
    )
    varnames(bioclim_sds) <- c(
      "bio01", paste0("bio0", 4:9),
      paste0("bio", 10:19)
    )
    return(bioclim_sds)
  }
)


#' @rdname bioclim_vars-methods
#' @export
methods::setMethod(
  "bioclim_vars", signature(prec = "matrix", tavg = "matrix"),
  function(prec, tavg) {
    if (nrow(prec) != nrow(tavg)) {
      stop("prec and tavg should have same length")
    }

    if (ncol(prec) != ncol(tavg)) {
      stop("prec and tavg should have same number of variables (columns)")
    }

    # can"t have missing values in a row
    nas <- apply(prec, 1, function(x) {
      any(is.na(x))
    })
    nas <- nas | apply(tavg, 1, function(x) {
      any(is.na(x))
    })
    p <- matrix(nrow = nrow(prec), ncol = 17)
    colnames(p) <- c(
      "bio01", paste0("bio0", 4:9),
      paste0("bio", 10:19)
    )
    if (all(nas)) {
      return(p)
    }

    prec[nas, ] <- NA
    tavg[nas, ] <- NA

    window <- function(x) {
      lng <- length(x)
      x <- c(x, x[1:3])
      m <- matrix(ncol = 3, nrow = lng)
      for (i in 1:3) {
        m[, i] <- x[i:(lng + i - 1)]
      }
      apply(m, MARGIN = 1, FUN = sum)
    }

    # P1. Annual Mean Temperature
    p[, "bio01"] <- apply(tavg, 1, mean)
    # P4. Temperature Seasonality (standard deviation)
    p[, "bio04"] <- 100 * apply(tavg, 1, stats::sd)
    # P5. Max Temperature of Warmest Period
    p[, "bio05"] <- apply(tavg, 1, max)
    # P6. Min Temperature of Coldest Period
    p[, "bio06"] <- apply(tavg, 1, min)
    # P7. Temperature Annual Range (P5-P6)
    p[, "bio07"] <- p[, "bio05"] - p[, "bio06"]
    # P12. Annual Precipitation
    p[, "bio12"] <- apply(prec, 1, sum)
    # P13. Precipitation of Wettest Period
    p[, "bio13"] <- apply(prec, 1, max)
    # P14. Precipitation of Driest Period
    p[, "bio14"] <- apply(prec, 1, min)
    # P15. Precipitation Seasonality(Coefficient of Variation)
    # the "1 +" is to avoid strange CVs for areas where mean rainfaill is < 1)
    p[, "bio15"] <- apply(prec + 1, 1, .cv)

    # precip by quarter (3 months)
    wet <- t(apply(prec, 1, window))
    # P16. Precipitation of Wettest Quarter
    p[, "bio16"] <- apply(wet, 1, max)
    # P17. Precipitation of Driest Quarter
    p[, "bio17"] <- apply(wet, 1, min)
    tmp <- t(apply(tavg, 1, window)) / 3

    if (all(is.na(wet))) {
      p[, "bio08"] <- NA
      p[, "bio09"] <- NA
    } else {
      # P8. Mean Temperature of Wettest Quarter
      wetqrt <- cbind(1:nrow(p), as.integer(apply(wet, 1, which.max)))
      p[, "bio08"] <- tmp[wetqrt]
      # P9. Mean Temperature of Driest Quarter
      dryqrt <- cbind(1:nrow(p), as.integer(apply(wet, 1, which.min)))
      p[, "bio09"] <- tmp[dryqrt]
    }
    # P10 Mean Temperature of Warmest Quarter
    p[, "bio10"] <- apply(tmp, 1, max)

    # P11 Mean Temperature of Coldest Quarter
    p[, "bio11"] <- apply(tmp, 1, min)

    if (all(is.na(tmp))) {
      p[, "bio18"] <- NA
      p[, "bio19"] <- NA
    } else {
      # P18. Precipitation of Warmest Quarter
      hot <- cbind(1:nrow(p), as.integer(apply(tmp, 1, which.max)))
      p[, "bio18"] <- wet[hot]
      # P19. Precipitation of Coldest Quarter
      cold <- cbind(1:nrow(p), as.integer(apply(tmp, 1, which.min)))
      p[, "bio19"] <- wet[cold]
    }

    return(p)
  }
)

#' Coefficient of variation (expressed as percentage)
#'
#' R function to compute the coefficient of variation
#' (expressed as a percentage). If there is only a single value, stats::sd = NA.
#' However, one could argue that cv =0; and NA may break the code that
#' receives it. The function returns 0 if the mean is close to zero.
#'
#' This is ODD: abs to avoid very small (or zero) mean with e.g. -5:5
#'
#' @param x a vector of values
#' @returns the cv
#' @keywords internal

.cv <- function(x) {
  # m <- mean(abs(x))
  m <- mean(x)
  if (is.na(m)) {
    return(NA)
  }
  if (m == 0) {
    return(0)
  } else {
    return(100 * stats::sd(x) / m)
  }
}
