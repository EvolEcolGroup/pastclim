#' Reconstruct biomes based on the Köppen Geiger's classification
#'
#' Function to reconstruct biomes following the Köppen Geiger's
#' classification, as implemented in Beck et al (2018). This function is a
#' translation of the Matlab function "KoeppenGeiger" provided in that
#' publication. See Table 1 in beck et al (2018) for the rules implemented
#' in this function.
#'
#' Beck, H.E., McVicar, T.R., Vergopolan, N. et al. High-resolution (1 km)
#' Köppen-Geiger maps for 1901–2099 based on constrained CMIP6 projections.
#' Sci Data 10, 724 (2023). https://doi.org/10.1038/s41597-023-02549-6
#'
#' @param tavg monthly average temperatures
#' @param prec monthly precipitation
#' @param broad boolean whether to return broad level classification
#' @param class_names boolean whether to return the names of classes (in
#' addition to codes)
#' @param ... additional variables for specific methods
#' @returns a data.frame with the Köppen Geiger classification
#' @docType methods
#' @rdname koeppen_geiger-methods
#' @importFrom methods setGeneric
#' @examples
#' prec <- matrix(
#'   c(
#'     66, 51, 53, 53, 33, 34.2, 70.9, 58, 54, 104.3, 81.2, 82.8, 113.3,
#'     97.4, 89, 109.7, 89, 93.4, 99.8, 92.6, 85.3, 102.3, 84, 81.6, 108.6, 88.4,
#'     82.7, 140.1, 120.4, 111.6, 120.4, 113.9, 96.7, 90, 77.4, 79.1
#'   ),
#'   ncol = 12, byrow = TRUE
#' )
#' tavg <- matrix(
#'   c(
#'     -0.2, 1.7, 2.9, 0.3, 4.2, 5, 4, 9, 9.2, 7.3, 12.6, 12.7, 12.1,
#'     17.2, 17, 15.5, 20.5, 20.3, 17.9, 22.8, 22.9, 17.4, 22.3, 22.4, 13.2, 18.2,
#'     18.6, 8.8, 13, 13.6, 3.5, 6.4, 7.5, 0.3, 2.1, 3.4
#'   ),
#'   ncol = 12, byrow = TRUE
#' )
#' koeppen_geiger(prec, tavg, broad = TRUE)
#'
#' @export

methods::setGeneric("koeppen_geiger", function(prec, tavg, broad = FALSE,
                                               class_names = TRUE, ...) {
  methods::standardGeneric("koeppen_geiger")
})

#' #' @rdname koeppen_geiger-methods
#' #' @export
#' methods::setMethod(
#'   "koeppen_geiger", signature(prec = "numeric", tavg = "numeric"),
#'   function(prec, tavg, broad = FALSE, class_names = TRUE, ...) {
#'     koeppen_geiger(
#'       prec = t(as.matrix(prec)), tavg = t(as.matrix(tavg)),
#'       broad = broad, class_names = class_names
#'     )
#'   }
#' )

#' @rdname koeppen_geiger-methods
#' @export
methods::setMethod(
  "koeppen_geiger", signature(prec = "matrix", tavg = "matrix"),
  function(prec, tavg, broad = FALSE, class_names = TRUE) {

    # sure we don't have Kelvin
    if (ncol(prec) != 12) {
      stop("prec needs to have 12 columns")
    }
    if (ncol(tavg) != 12) {
      stop("tavg needs to have 12 columns")
    }
    if (nrow(prec) != nrow(tavg)) {
      stop("prec and tavg need to have the same number of rows")
    }

    # we get the indeces of the lines which have data
    valid_rows <- which(!is.na(prec[, 1] + tavg[, 1]))
    tot_n_rows <- nrow(prec)
    prec <- prec[valid_rows, ]
    tavg <- tavg[valid_rows, ]

    if (any(tavg > 100)) {
      stop("tavg should be in degrees celsius, but the current input is Kelvin")
    }
        
    if (!inherits(tavg, "matrix")){
      stop("only one valid row of data, this function needs at least two")
    }

    T_ONDJFM <- apply(tavg[, c(10, 11, 12, 1, 2, 3)], 1, mean)
    T_AMJJAS <- apply(tavg[, c(4, 5, 6, 7, 8, 9)], 1, mean)
    tmp <- T_AMJJAS > T_ONDJFM
    SUM_SEL <- array(FALSE, dim = dim(tavg))
    SUM_SEL[, c(10, 11, 12, 1, 2, 3)] <- !tmp
    SUM_SEL[, c(4, 5, 6, 7, 8, 9)] <- tmp
    Pw <- apply(prec * (1 - SUM_SEL), 1, sum)
    Ps <- apply(prec * SUM_SEL, 1, sum)
    Pdry <- apply(prec, 1, min)

    tmp <- SUM_SEL
    tmp[tmp == 0] <- NA
    Psdry <- apply(prec * tmp, 1, min, na.rm = TRUE)
    Pswet <- apply(prec * tmp, 1, max, na.rm = TRUE)

    tmp <- 1 - SUM_SEL
    tmp[tmp == 0] <- NA
    Pwdry <- apply(prec * tmp, 1, min, na.rm = TRUE)
    Pwwet <- apply(prec * tmp, 1, max, na.rm = TRUE)

    MAT <- apply(tavg, 1, mean)
    MAP <- apply(prec, 1, sum)
    Tmon10 <- apply(tavg > 10, 1, sum)
    Thot <- apply(tavg, 1, max)
    Tcold <- apply(tavg, 1, min)

    Pthresh <- 2 * MAT + 14
    Pthresh[Pw * 2.333 > Ps] <- 2 * MAT[Pw * 2.333 > Ps]
    Pthresh[Ps * 2.333 > Pw] <- 2 * MAT[Ps * 2.333 > Pw] + 28

    B <- MAP < 10 * Pthresh
    BW <- B & MAP < 5 * Pthresh
    BWh <- BW & MAT >= 18
    BWk <- BW & MAT < 18
    BS <- B & MAP >= 5 * Pthresh
    BSh <- BS & MAT >= 18
    BSk <- BS & MAT < 18

    A <- Thot >= 18 & !B
    Af <- A & Pdry >= 60
    Am <- A & !Af & Pdry >= 100 - MAP / 25
    Aw <- A & !Af & Pdry < 100 - MAP / 25

    C <- Thot > 10 & Tcold > 0 & Tcold < 18 & !B
    Cs <- C & Psdry < 40 & Psdry < Pwwet / 3
    Cw <- C & Pwdry < Pswet / 10
    overlap <- Cs & Cw
    Cs[overlap & Ps > Pw] <- 0
    Cw[overlap & Ps <= Pw] <- 0
    Csa <- Cs & Thot >= 22
    Csb <- Cs & !Csa & Tmon10 >= 4
    Csc <- Cs & !Csa & !Csb & Tmon10 >= 1 & Tmon10 < 4
    Cwa <- Cw & Thot >= 22
    Cwb <- Cw & !Cwa & Tmon10 >= 4
    Cwc <- Cw & !Cwa & !Cwb & Tmon10 >= 1 & Tmon10 < 4
    Cf <- C & !Cs & !Cw
    Cfa <- Cf & Thot >= 22
    Cfb <- Cf & !Cfa & Tmon10 >= 4
    Cfc <- Cf & !Cfa & !Cfb & Tmon10 >= 1 & Tmon10 < 4

    D <- Thot > 10 & Tcold <= 0 & !B
    Ds <- D & Psdry < 40 & Psdry < Pwwet / 3
    Dw <- D & Pwdry < Pswet / 10
    overlap <- Ds & Dw
    Ds[overlap & Ps > Pw] <- 0
    Dw[overlap & Ps <= Pw] <- 0
    Dsa <- Ds & Thot >= 22
    Dsb <- Ds & !Dsa & Tmon10 >= 4
    Dsd <- Ds & !Dsa & !Dsb & Tcold < -38
    Dsc <- Ds & !Dsa & !Dsb & !Dsd

    Dwa <- Dw & Thot >= 22
    Dwb <- Dw & !Dwa & Tmon10 >= 4
    Dwd <- Dw & !Dwa & !Dwb & Tcold < -38
    Dwc <- Dw & !Dwa & !Dwb & !Dwd
    Df <- D & !Ds & !Dw
    Dfa <- Df & Thot >= 22
    Dfb <- Df & !Dfa & Tmon10 >= 4
    Dfd <- Df & !Dfa & !Dfb & Tcold < -38
    Dfc <- Df & !Dfa & !Dfb & !Dfd

    E <- Thot <= 10 & !B
    ET <- E & Thot > 0
    EF <- E & Thot <= 0

    class <- rep(0, nrow(tavg))

    for (cc in 1:nrow(pastclim::koeppen_classes)) {
      class[eval(parse(text = pastclim::koeppen_classes[cc, 3]))] <- pastclim::koeppen_classes[cc, 1]
    }

    kg_classification <- data.frame(id = class)

    if (broad) {
      broad_class <- rep(0, nrow(tavg))
      for (cc in 1:nrow(pastclim::koeppen_classes)) {
        broad_class[eval(parse(text = pastclim::koeppen_classes[cc, 3]))] <- pastclim::koeppen_classes[cc, 2]
      }
      kg_classification$broad <- broad_class
    }
    # now reintroduce the missing rows
    kg_classification_full <- as.data.frame(matrix(NA,
      ncol = ncol(kg_classification),
      nrow = tot_n_rows,
      dimnames = list(NULL, names(kg_classification))
    ))
    kg_classification_full[valid_rows, ] <- kg_classification[, ]
    return(kg_classification_full)
  }
)

#' @param filename filename to save the raster (optional).
#' @rdname koeppen_geiger-methods
#' @export
methods::setMethod(
  "koeppen_geiger", signature(prec = "SpatRaster", tavg = "SpatRaster"),
  function(prec, tavg, broad = FALSE, class_names = TRUE, filename = "", ...) {
    if (nlyr(prec) != 12) stop("nlyr(prec) is not 12")
    if (nlyr(tavg) != 12) stop("nlyr(tavg) is not 12")

    x <- c(prec, tavg)
    readStart(x)
    on.exit(readStop(x))
    nc <- ncol(x)
    raster_names <- "id"
    out <- rast(prec, nlyr = 1)
    names(out) <- raster_names
    b <- writeStart(out, filename, ...)
    for (i in 1:b$n) {
      d <- readValues(x, b$row[i], b$nrows[i], 1, nc, TRUE, FALSE)
      p <- koeppen_geiger(d[, 1:12], d[, 13:24],
        broad = FALSE,
        class_names = FALSE
      )
      p <- as.matrix(p)
      writeValues(out, p, b$row[i], b$nrows[i])
    }
    writeStop(out)
    levels(out) <- pastclim::koeppen_classes
    if (class_names) {
      if (!broad) {
        activeCat(out, layer = 1) <- "code"
      } else {
        activeCat(out, layer = 1) <- "code_broad"
      }
    } else {
      if (!broad) {
        activeCat(out, layer = 1) <- "id"
      } else {
        activeCat(out, layer = 1) <- "id_broad"
      }
    }
    terra::coltab(out) <- data.frame(
      values = pastclim::koeppen_classes$id,
      cols = pastclim::koeppen_classes$colour
    )
    return(out)
  }
)



#' @param filename filename to save the raster (optional).
#' @rdname koeppen_geiger-methods
#' @export
methods::setMethod(
  "koeppen_geiger", signature(prec = "SpatRasterDataset", tavg = "SpatRasterDataset"),
  function(prec, tavg, broad = FALSE, class_names = TRUE, filename = "", ...) {
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
      koeppen_slice <- koeppen_geiger(prec_slice, tavg_slice)
      # set times in years BP
      time_bp(koeppen_slice) <- rep(time_slices[i], terra::nlyr(koeppen_slice))
      if (i == 1) {
        biovars_list <- split(koeppen_slice, f = terra::nlyr(koeppen_slice))
      } else {
        for (x in 1:(terra::nlyr(koeppen_slice))) {
          biovars_list[[x]] <- c(biovars_list[[x]], koeppen_slice[[x]])
        }
      }
    }
    # return the variables as a SpatRasterDataset
    koeppen_sds <- terra::sds(biovars_list)
    names(koeppen_sds) <- names(koeppen_slice)
    varnames(koeppen_sds) <- names(koeppen_slice)
    return(koeppen_sds)
  }
)
