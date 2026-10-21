# manual rchelsa: https://gitlabext.wsl.ch/karger/rchelsa/-/blob/main/Rchelsa_1.0.2.pdf?ref_type=heads

library(rchelsa)

# from rchelsa description
# source https://gitlabext.wsl.ch/karger/rchelsa 

# define start and end dates for the extraction
startdate <- c(1, -200)    # January, 20,000 BP
enddate   <- c(12, -200)     # December, 20,000 BP
#Step 2: Define multiple coordinates
coords <- data.frame(
  lon = c(13.827138, 13.781620),
  lat = c(46.311087, 46.340116)
)
#Step 3: Extract the data
pr <- getChelsa("pr", coords = coords, startdate = startdate, enddate = enddate, 
                dataset="chelsa-trace21k-centennial")


# full script to create URL
# source: https://gitlabext.wsl.ch/karger/rchelsa/-/blob/main/R/createURL.R?ref_type=heads

#' Build a CHELSA URL or local file path
#'
#' @param local_path Optional local root replacing the remote host,
#'   e.g., "/dme/eunomia/". Defaults to NULL for remote access.
#'
#' @export
createURL <- function(var, date, dataset, extent = "global",
                      ssp = NULL, forcing = NULL,
                      forcing_variant = "r1i1p1f1_w5e5",
                      local_path = NULL) {
  
  resolve_host <- function(remote_host) {
    if (is.null(local_path)) return(remote_host)
    
    if (!is.character(local_path) ||
        length(local_path) != 1L ||
        is.na(local_path) ||
        !nzchar(trimws(local_path))) {
      stop("local_path must be NULL or a single non-empty directory path.")
    }
    
    paste0(sub("/+$", "", path.expand(local_path)), "/")
  }
  
  canon_ds <- function(x) {
    x <- tolower(trimws(x))
    gsub("[^a-z0-9]+", "-", x)
  }
  
  ds     <- canon_ds(dataset)
  var    <- as.character(var)
  extent <- tolower(extent)
  
  # Normalize inputs
  ssp <- if (!is.null(ssp) && nzchar(ssp)) {
    tolower(ssp)
  } else {
    NULL
  }
  
  forcing_in <- if (!is.null(forcing) && nzchar(forcing)) {
    forcing
  } else {
    NULL
  }
  
  forcing_file <- if (!is.null(forcing_in)) {
    tolower(forcing_in)
  } else {
    NULL
  }
  
  # Keep underscores and hyphens in the variant
  variant_file <- if (!is.null(forcing_variant) &&
                      nzchar(forcing_variant)) {
    gsub("[^a-z0-9_-]+", "", tolower(forcing_variant))
  } else {
    NULL
  }
  
  forcing_folder <- if (!is.null(forcing_in)) {
    toupper(forcing_in)
  } else {
    NULL
  }
  
  fmt_year <- function(y) {
    y <- as.integer(y)
    if (y < 0) {
      sprintf("-%03d", abs(y))
    } else {
      sprintf("%04d", y)
    }
  }
  
  parse_month_year <- function(x) {
    if (inherits(x, "Date")) {
      list(mm = format(x, "%m"), yy = format(x, "%Y"))
    } else if (is.numeric(x) && length(x) == 2L) {
      list(mm = sprintf("%02d", x[1]), yy = fmt_year(x[2]))
    } else {
      stop("date must be a Date or numeric c(month, year)")
    }
  }
  
  parse_period <- function(x) {
    if (is.character(x) && grepl("^\\d{4}-\\d{4}$", x)) {
      x
    } else if (is.numeric(x) && length(x) == 2L) {
      sprintf("%04d-%04d", as.integer(x[1]), as.integer(x[2]))
    } else {
      stop("Use period 'YYYY-YYYY' or numeric c(start,end).")
    }
  }
  
  period_from_year <- function(y) {
    y <- as.integer(y)
    
    if (y >= 1981 && y <= 2010) return("1981-2010")
    if (y >= 2011 && y <= 2040) return("2011-2040")
    if (y >= 2041 && y <= 2070) return("2041-2070")
    if (y >= 2071 && y <= 2100) return("2071-2100")
    
    stop("Year ", y, " is outside supported climatology periods.")
  }
  
  # ---------- CHELSA v2.x ----------
  if (ds %in% c(
    "chelsa-daily",
    "chelsa-monthly",
    "chelsa-climatologies",
    "chelsa-bioclim"
  )) {
    
    host  <- resolve_host("https://os.unil.cloud.switch.ch/chelsa02/")
    model <- "chelsa"
    
    if (ds == "chelsa-daily") {
      if (!inherits(date, "Date")) {
        stop("For CHELSA-daily, 'date' must be a Date.")
      }
      
      base <- paste0(
        host, model, "/", extent, "/daily/",
        var, "/", format(date, "%Y"), "/"
      )
      
      file <- sprintf(
        "CHELSA_%s_%s_%s_%s_V.2.1.tif",
        var,
        format(date, "%d"),
        format(date, "%m"),
        format(date, "%Y")
      )
      
      return(paste0(base, file))
    }
    
    if (ds == "chelsa-monthly") {
      my <- parse_month_year(date)
      
      base <- paste0(
        host, model, "/", extent, "/monthly/",
        var, "/", my$yy, "/"
      )
      
      file <- sprintf(
        "CHELSA_%s_%s_%s_V.2.1.tif",
        var, my$mm, my$yy
      )
      
      return(paste0(base, file))
    }
    
    if (ds == "chelsa-climatologies") {
      if (inherits(date, "Date")) {
        mm <- format(date, "%m")
        period <- period_from_year(format(date, "%Y"))
      } else if (is.numeric(date) && length(date) == 2L) {
        mm <- sprintf("%02d", date[1])
        period <- period_from_year(date[2])
      } else if (is.numeric(date) && length(date) == 3L) {
        mm <- sprintf("%02d", date[1])
        period <- sprintf("%04d-%04d", date[2], date[3])
      } else {
        stop(
          "For CHELSA-climatologies, use Date or numeric ",
          "c(month,year) or c(month,start,end)."
        )
      }
      
      base <- paste0(
        host, model, "/", extent, "/climatologies/",
        var, "/", period, "/"
      )
      
      if (!is.null(ssp) && !is.null(forcing_folder)) {
        base <- paste0(base, forcing_folder, "/", ssp, "/")
      }
      
      if (!is.null(ssp) && !is.null(forcing_file)) {
        prefix <- forcing_file
        
        if (!is.null(variant_file)) {
          prefix <- paste0(prefix, "_", variant_file)
        }
        
        file <- sprintf(
          "CHELSA_%s_%s_%s_%s_%s_V.2.1.tif",
          prefix, ssp, var, mm, period
        )
      } else {
        file <- sprintf(
          "CHELSA_%s_%s_%s_V.2.1.tif",
          var, mm, period
        )
      }
      
      return(paste0(base, file))
    }
    
    if (ds == "chelsa-bioclim") {
      period <- parse_period(date)
      
      base <- paste0(
        host, model, "/", extent, "/bioclim/",
        var, "/", period, "/"
      )
      
      if (!is.null(ssp) && !is.null(forcing_folder)) {
        base <- paste0(base, forcing_folder, "/", ssp, "/")
      }
      
      if (!is.null(ssp) && !is.null(forcing_file)) {
        file <- sprintf(
          "CHELSA_%s_%s_%s_%s_V.2.1.tif",
          forcing_file, ssp, var, period
        )
      } else {
        file <- sprintf(
          "CHELSA_%s_%s_V.2.1.tif",
          var, period
        )
      }
      
      return(paste0(base, file))
    }
  }
  
  # ---------- TraCE21k ----------
  if (ds %in% c(
    "chelsa-trace21k-centennial",
    "chelsa-trace21k-bioclim"
  )) {
    
    host  <- resolve_host("https://os.zhdk.cloud.switch.ch/chelsa01/")
    model <- "chelsa_trace21k"
    
    group <- if (ds == "chelsa-trace21k-bioclim") {
      "bioclim"
    } else {
      "centennial"
    }
    
    base <- paste0(
      host, model, "/", extent, "/", group, "/", var, "/"
    )
    
    if (group == "bioclim" || var %in% c("orog", "glz", "scd", "swe")) {
      yy <- if (inherits(date, "Date")) {
        format(date, "%Y")
      } else if (is.numeric(date) && length(date) > 0L) {
        fmt_year(date[[length(date)]])
      } else if (is.character(date) && grepl("^-?\\d+$", date)) {
        fmt_year(as.integer(date))
      } else {
        stop("TraCE21k needs a year (Date, numeric, or character).")
      }
      
      file <- sprintf(
        "CHELSA_TraCE21k_%s_%s_V.1.0.tif",
        var, yy
      )
    } else {
      my <- parse_month_year(date)
      
      file <- sprintf(
        "CHELSA_TraCE21k_%s_%s_%s_V.1.0.tif",
        var, my$mm, my$yy
      )
    }
    
    return(paste0(base, file))
  }
  
  # ---------- CanaryClim ----------
  if (ds == "chelsacanaryclim-climatologies") {
    host <- resolve_host("https://os.zhdk.cloud.switch.ch/chelsa01/")
    
    is_bioclim <- grepl("^bio\\d{1,2}$", tolower(var))
    
    if (is_bioclim) {
      if (is.null(date)) {
        period <- "1979-2013"
      } else if (is.character(date) &&
                 grepl("^\\d{4}-\\d{4}$", date)) {
        period <- date
      } else if (is.numeric(date) && length(date) == 2L) {
        period <- sprintf(
          "%04d-%04d",
          as.integer(date[1]),
          as.integer(date[2])
        )
      } else if (inherits(date, "Date")) {
        period <- "1979-2013"
      } else {
        stop(
          "For CanaryClim bioclim, use period 'YYYY-YYYY' ",
          "or numeric c(start,end)."
        )
      }
    } else {
      if (inherits(date, "Date")) {
        mm <- format(date, "%m")
        yy <- as.integer(format(date, "%Y"))
        period <- if (yy <= 2013) "1979-2013" else "2071-2100"
      } else if (is.numeric(date) && length(date) == 3L) {
        mm <- sprintf("%02d", as.integer(date[1]))
        period <- sprintf(
          "%04d-%04d",
          as.integer(date[2]),
          as.integer(date[3])
        )
      } else {
        stop(
          "For CanaryClim monthly vars (tas/tasmin/tasmax/pr), ",
          "use numeric c(month,start,end) or a Date."
        )
      }
    }
    
    base <- paste0(
      host, "chelsa_canaryclim/canaries/climatologies/",
      var, "/", period, "/"
    )
    
    filename <- if (is_bioclim) {
      sprintf(
        "CHELSACanaryClim_%s_%s_V.1.0.tif",
        var, period
      )
    } else {
      sprintf(
        "CHELSACanaryClim_%s_%s_%s_V.1.0.tif",
        var, mm, period
      )
    }
    
    return(paste0(base, filename))
  }
  
  stop("Unsupported dataset: ", dataset)
}