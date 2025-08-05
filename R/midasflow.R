#' @useDynLib midasflow, .registration=TRUE

find_library <- function(libname, paths = NULL) {
  get_os <- function() {
    sysname <- Sys.info()[["sysname"]]
    if (sysname == "Darwin") {
      return("macos")
    }
    if (sysname == "Linux") {
      return("linux")
    }
    if (sysname == "Windows") {
      return("windows")
    }
    return("unknown")
  }

  os <- get_os()
  extensions <- switch(
    os,
    "windows" = c(".dll"),
    "linux" = c(".so"),
    "macos" = c(".dylib"),
    stop("Unsupported OS")
  )

  prefix <- if (os == "windows") "" else "lib"

  if (is.null(paths)) {
    path_envs <- c(
      Sys.getenv("LD_LIBRARY_PATH"),
      Sys.getenv("DYLD_LIBRARY_PATH"), # macOS equivalent
      Sys.getenv("PATH")
    )
    paths <- unique(
      unlist(strsplit(path_envs, .Platform$path.sep)),
      as.vector(outer(
        c("/usr/lib", "/usr/local/lib"),
        c("", "64"),
        paste0
      ))
    )
  }

  for (path in paths) {
    for (ext in extensions) {
      candidate <- file.path(path, paste0(prefix, libname, ext))
      if (file.exists(candidate)) {
        return(normalizePath(candidate))
      }
    }
  }

  stop(paste("Cannot find library", libname))
}

dyn.load(find_library("midas"))

# after adding C functions here,
# from an R sessoin in midasflow-r
# 1. styler::style_pkg()
# 2. devtools::install()
# in Bash just outside midasflow-r
# 3. R CMD build midasflow-r
# 4. R CMD INSTALL midasflow_$(sed '/Version/!d; s/.* //' midasflow-r/DESCRIPTION).tar.gz

#' Run the Memory-Efficient Flow Accumulation (MEFA) algorithm
#'
#' @references
#' Cho, H. (2023). *Memory-Efficient Flow Accumulation Using a Look-Around Approach and Its OpenMP Parallelization*. Environmental Modelling & Software 167, 105771. <https://doi.org/10.1016/j.envsoft.2023.105771>.
#'
#' @param dir_path Character. Input flow direction raster (e.g., gpkg:file.gpkg:layer).
#' @param accum_path Character. Output flow accumulation GeoTiff.
#' @param dir_opts Character, optional. Comma-separated list of GDAL options for dir_path.
#' @param encoding Character, optional. Input flow direction encoding.
#'
#'	power2 (default): \eqn{2^{0,\cdots,7}} CW from E (e.g., r.terraflow, ArcGIS)
#'
#'	taudem: 1-8 (E-SE CCW) (e.g., d8flowdir)
#'
#'	45degree: 1-8 (NE-E CCW) (e.g., r.watershed)
#'
#'	degree: (0,360] (E-E CCW)
#'
#'	E,SE,S,SW,W,NW,N,NE: custom (e.g., 1,8,7,6,5,4,3,2 for taudem)
#' @param use_lessmem Logical, optional. Use less memory.
#' @param compress_output Logical, optional. Compress output GeoTIFF.
#' @param num_threads Integer, optional. Number of threads (default OMP_NUM_THREADS).
#' @return Integer status code (0 for success).
#' @export
mefa <- function(
  dir_path,
  accum_path,
  dir_opts = NULL,
  encoding = NULL,
  use_lessmem = FALSE,
  compress_output = FALSE,
  num_threads = 0
) {
  .Call(
    "call_mefa",
    dir_path,
    dir_opts,
    encoding,
    accum_path,
    as.integer(use_lessmem),
    as.integer(compress_output),
    as.integer(num_threads)
  )
}

#' Run the Memory-Efficient Watershed Delineation (MESHED) algorithm
#'
#' @references
#' Cho, H. (2025). *Avoid Backtracking and Burn Your Inputs: CONUS-Scale Watershed Delineation Using OpenMP*. Environmental Modelling & Software 183, 106244. <https://doi.org/10.1016/j.envsoft.2024.106244>.
#'
#' @param dir_path Character. Input flow direction raster (e.g., gpkg:file.gpkg:layer).
#' @param outlets_path Character. Input outlets vector.
#' @param id_col Character. Input column for outlet IDs.
#' @param output_path Character. Output watersheds GeoTIFF or output text file with save_outlets.
#' @param dir_opts Character, optional. Comma-separated list of GDAL options for dir_path.
#' @param encoding Character, optional. Input flow direction encoding.
#'
#'	power2 (default): \eqn{2^{0,\cdots,7}} CW from E (e.g., r.terraflow, ArcGIS)
#'
#'	taudem: 1-8 (E-SE CCW) (e.g., d8flowdir)
#'
#'	45degree: 1-8 (NE-E CCW) (e.g., r.watershed)
#'
#'	degree: (0,360] (E-E CCW)
#'
#'	E,SE,S,SW,W,NW,N,NE: custom (e.g., 1,8,7,6,5,4,3,2 for taudem)
#' @param outlets_layer Character, optional. Layer name of input outlets vector, if necessary (e.g., gpkg).
#' @param outlets_opts Character, optional. Comma-separated list of GDAL options for outlets.
#' @param hier_path Character, optional. Output subwatershed hierarchy CSV.
#' @param use_lessmem Logical, optional. Use less memory.
#' @param compress_output Logical, optional. Compress output GeoTIFF.
#' @param save_outlets Logical, optional. Write outlet rows and columns, and exit.
#' @param num_threads Integer, optional. Number of threads (default OMP_NUM_THREADS).
#' @param tracing_stack_size Integer, optional. Tracing stack size (default 3072, 0 for guessing).
#' @return Integer status code (0 for success).
#' @export
meshed <- function(
  dir_path,
  outlets_path,
  id_col,
  output_path,
  dir_opts = NULL,
  encoding = NULL,
  outlets_layer = NULL,
  outlets_opts = NULL,
  hier_path = NULL,
  use_lessmem = FALSE,
  compress_output = FALSE,
  save_outlets = FALSE,
  num_threads = 0,
  tracing_stack_size = 0
) {
  .Call(
    "call_meshed",
    dir_path,
    dir_opts,
    encoding,
    outlets_path,
    outlets_layer,
    outlets_opts,
    id_col,
    output_path,
    hier_path,
    as.integer(use_lessmem),
    as.integer(compress_output),
    as.integer(save_outlets),
    as.integer(num_threads),
    as.integer(tracing_stack_size)
  )
}

#' Run the Memory-Efficient Longest Flow Path (MELFP) algorithm
#'
#' @references
#' Cho, H. (2025). *Loop Then Task: Hybridizing OpenMP Parallelism to Improve Load Balancing and Memory Efficiency in Continental-Scale Longest Flow Path Computation*. Environmental Modelling & Software 193, 106630. <https://doi.org/10.1016/j.envsoft.2025.106630>.
#'
#' @param dir_path Character. Input flow direction raster (e.g., gpkg:file.gpkg:layer).
#' @param outlets_path Character. Input outlets vector.
#' @param id_col Character. Input column for outlet IDs.
#' @param output_path Character. Output watersheds GeoTIFF or output text file with save_outlets.
#' @param dir_opts Character, optional. Comma-separated list of GDAL options for dir_path.
#' @param encoding Character, optional. Input flow direction encoding.
#'
#'	power2 (default): \eqn{2^{0,\cdots,7}} CW from E (e.g., r.terraflow, ArcGIS)
#'
#'	taudem: 1-8 (E-SE CCW) (e.g., d8flowdir)
#'
#'	45degree: 1-8 (NE-E CCW) (e.g., r.watershed)
#'
#'	degree: (0,360] (E-E CCW)
#'
#'	E,SE,S,SW,W,NW,N,NE: custom (e.g., 1,8,7,6,5,4,3,2 for taudem)
#' @param outlets_layer Character, optional. Layer name of input outlets vector, if necessary (e.g., gpkg).
#' @param outlets_opts Character, optional. Comma-separated list of GDAL options for outlets.
#' @param oid_col Character, optional. Output column for outlet IDs.
#' @param lfp_name Character, optional. Layer name for output longest flow paths.
#' @param heads_name Character, optional. Layer name for output longest flow path heads.
#' @param coors_path Character, optional. Output longest flow path head coordinates CSV.
#' @param find_full Logical, optional. Find full longest flow paths.
#' @param use_lessmem Integer, optional. Use less memory.
#' @param save_outlets Logical, optional. Write outlet rows and columns, and exit.
#' @param num_threads Integer, optional. Number of threads (default OMP_NUM_THREADS).
#' @param tracing_stack_size Integer, optional. Tracing stack size (default 3072, 0 for guessing).
#' @return Integer status code (0 for success).
#' @export
melfp <- function(
  dir_path,
  outlets_path,
  id_col,
  output_path,
  dir_opts = NULL,
  encoding = NULL,
  outlets_layer = NULL,
  outlets_opts = NULL,
  oid_col = "lfp_id",
  lfp_name = "lfp",
  heads_name = NULL,
  coors_path = NULL,
  find_full = FALSE,
  use_lessmem = 2,
  save_outlets = FALSE,
  num_threads = 0,
  tracing_stack_size = 0
) {
  .Call(
    "call_melfp",
    dir_path,
    dir_opts,
    encoding,
    outlets_path,
    outlets_layer,
    outlets_opts,
    id_col,
    output_path,
    oid_col,
    lfp_name,
    heads_name,
    coors_path,
    as.integer(find_full),
    as.integer(use_lessmem),
    as.integer(save_outlets),
    as.integer(num_threads),
    as.integer(tracing_stack_size)
  )
}
