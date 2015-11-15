#' Parse all atekst .txt files in a directory
#'
#' Parse all .txt files downloaded from atekst within a directory (including subfolders). It can use a pattern (regex) to identify files. The function returns a data frame with the headline, paper, date, time, mode (net/print), url, and text for each article. In order to speed it up it is possible to run it in parallel by setting \code{parallel} to \code{TRUE} and setting \code{cores}. When working with large corpuses it is recommended to run the function once and save the resulting data frame as a \code{.RData}-file. That way it can be loaded (using \code{load()}) into R in a fraction of the time it takes to parse the whole corpus.
#' @param dir Directory containing atekst .txt files.
#' @param recursive If \code{TRUE}, the function also parses files within subfolders.
#' @param regex Regular expression (pattern) to use for selecting files to parse.
#' @param parallel If \code{TRUE} it will try to do it in parallel (using the packages \code{foreach}, \code{iterators}, \code{doParallel} and \code{parallel}).
#' @param cores The amount of cores to use (if \code{parallel} is \code{TRUE}).
#' @keywords parse atekst
#' @export
#' @examples
#' corpus <- read.atekst.dir("some/directory")
#' save(corpus, file = "atekst-corpus.RData")

read.atekst.dir <- function(dir, recursive = TRUE, regex = "^Utvalgte_dokumenter.*.txt$", parallel = FALSE, cores = 1) {
    files  <- list.files(path = gsub("^/+", "", dir), recursive = recursive, pattern = regex, full.names = TRUE)
    if (length(files) == 0) stop("Unable to find any files.")
    
    if (parallel) {
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
            warning(paste("Only able to detect and use", cores, "cores."))
        } else if (cores < 1) {
            warning("Reverting to one core.")
            cores <- 1
        }
        cl <- makeCluster(cores)
        registerDoParallel(cl)

        out <- foreach(file = files, .combine = rbind, .inorder = FALSE, .packages = "parseAtekst") %dopar% {
            corpus <- read.atekst(file)
            corpus$filepath <- file
            corpus$filepath <- as.character(corpus$filepath)
            corpus$filename <- sub("^.*/(.*)$", "\\1", corpus$filepath)
            return(corpus)
        }
        stopCluster(cl)
        
    } else {
        out <- lapply(files, function(file) {
                          corpus <- parseAtekst::read.atekst(file)
                          corpus$filepath <- file
                          corpus$filepath <- as.character(corpus$filepath)
                          corpus$filename <- sub("^.*/(.*)$", "\\1", corpus$filepath)
                          return(corpus)
                      })
        out <- do.call("rbind", out)
    }

    cat(paste("Imported and parsed", paste0(length(files)), "files, resulting in", paste0(nrow(out)), "articles.\n"))
    return(out)
}
