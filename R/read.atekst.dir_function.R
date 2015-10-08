#' Parse all atekst .txt files in an directory
#'
#' This function allows you to parse all atekst-style .txt files in an directory. The function returns a data frame with the headline, paper, data, section (if any) and main text. 
#' @param dir Path to the directory 
#' @param recursive Should it go through all subfolders?
#' @param cores How many cores (i.e. parallel processes) do you wish to use?
#' @keywords atekst
#' @export
#' @examples
#' read.atekst.dir()

read.atekst.dir <- function(dir, recursive = TRUE, cores = 1) { 
    require(foreach, quietly = TRUE)
    require(iterators, quietly = TRUE)
    require(doParallel, quietly = TRUE)
    require(parallel, quietly = TRUE)

    ## Core safety
    if (!cores%%1 == 0) {
        cores <- 1
        warning("The number of cores must be an integer. Reverting to one core.")
    } else if (cores > detectCores()) {
        cores <- detectCores()
        warning(paste0("Only able to detect and use ", cores, " cores."))
    } else if (cores < 1) {
        warning("Reverting to one core.")
        cores <- 1
    }
    cl <- makeCluster(cores)
    registerDoParallel(cl)
    
    ## Import file list and parse
    files  <- list.files(path = dir, recursive = recursive, pattern = paste('*.txt$', sep=''), full.names = TRUE)
    out <- foreach(file = files, .combine = rbind, .inorder = FALSE, .packages = "parseAtekst") %dopar% {
        corpus <- read.atekst(file)
        corpus$filepath <- file
        corpus$filepath <- as.character(corpus$filepath)
        corpus$filename <- sub("^.*/(.*)$", "\\1", corpus$filepath)
        return(corpus)
    }
    stopCluster(cl)
    return(out)
}
