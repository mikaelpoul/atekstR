#' Parse all atekst .txt files in an directory
#'
#' This function allows you to parse all .txt files downloaded from atekst within a directory (including subfolders). If \code{strict == TRUE} it only tries to parse .txt-files starting with "Utvalgte_dokumenter", otherwise it will try to parse all .txt-files it can find. It is recommended that the directory only contains .txt-files downloaded from Atekst. The function returns a data frame with the headline, paper, date, time, mode (net/print), url, and text for each article. In order to save time when working with large corpuses it is recommended to run the function once and save the resulting data frame as a \code{RData}-file (using \code{save()}). That way it can be loaded (using \code{load()}) into R in a fraction of the time it takes to parse the whole corpus.
#' @param dir Directory containing atekst .txt files.
#' @param recursive If \code{TRUE}, the function also parses files within subfolders.
#' @param cores The amount of cores (i.e. parallel processes) that should be utilized.
#' @param strict If \code{TRUE}, the function only parses .txt files with filenames starting with "Utvalgte_dokumenter".
#' @keywords parse atekst
#' @export
#' @examples
#' corpus <- read.atekst.dir("some/directory")
#' save(corpus, file = "atekst-corpus.RData")

read.atekst.dir <- function(dir, recursive = TRUE, strict = TRUE, cores = 1) { 
    require(foreach, quietly = TRUE)
    require(iterators, quietly = TRUE)
    require(doParallel, quietly = TRUE)
    require(parallel, quietly = TRUE)

    ## Doublecheck n cores and register cluster
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
    if (strict) {
        files  <- list.files(path = dir, recursive = recursive, pattern = paste("^Utvalgte_dokumenter*.txt$", sep = ""), full.names = TRUE)
    } else {
        files  <- list.files(path = dir, recursive = recursive, pattern = paste("*.txt$", sep = ""), full.names = TRUE)
    }
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
