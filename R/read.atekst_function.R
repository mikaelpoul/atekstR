#' Parse an atekst .txt file
#'
#' This function allows you to parse an atekst .txt-file. The function returns a data frame with the headline, paper, data, section (if any) and main text.
#' @param file Path to atekst .txt-file. Can also be an object (i.e., already read with readLines() if object = TRUE.
#' @param object If have already read the file with readLines() and wish to feed the parser an R object instead, then object should be TRUE.
#' @keywords parse atekst
#' @export
#' @examples
#' read.atekst()

read.atekst <- function(file, object = FALSE) {
    if (!object) {
        file <- readLines(file, skipNul = TRUE, encoding = "latin1")
    }
    
    ## Extract each article
    splits <- grep("==============================================================================", file)
    articles <- lapply(0:length(splits), function(x) {
        if (x == 0) {  # for first article
            article <- file[(grep("------------------------------------------------------------------------------", file)[1] - 6):(splits[1] - 1)]
        } else if (x == length(splits)) {
            article <- file[(splits[x] + 2):(length(file) - 1)]
        } else {  # for last
            article <- file[(splits[x] + 2):(splits[x + 1] - 1)]
        }
        return(article)
    })

    ## Parse each article in turn
    allList <- lapply(articles, function(art) {

        ## headline
        headline <- art[grep("------------------------------------------------------------------------------", art)-2]

        ## paper/date
        ##        noPaper <- TRUE
        ##        x <- grep("------------------------------------------------------------------------------", art)[1]
        ##        while(noPaper) {
        ##            x <- x + 1
        ##            if (x == (length(art) + 1)) {
        ##                break
        ##            }
        ##            if (grepl(", [0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]", art[x])) {
        ##                
        ##                paper <- sub("(,*),.*", "\\1", art[x])
        ##                date <- sub(".*, (.*)", "\\1", art[x])
        ##                noPaper <- FALSE
        ##            }
        ##        }

        ## paper
        paperLine <- grep(", [0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]", art)[1]
        paper <- sub("(,*),.*", "\\1", art[paperLine])

        ## date
        dateRaw <- sub(".*, (.*)", "\\1", art[paperLine])
        dateRaw <- strsplit(dateRaw, " ")[[1]]
        date <- dateRaw[1]
        time <- NA
        if (length(dateRaw) == 2) {
            time <- dateRaw[2]
        }
        
        ## section:
        ##        noSec <- TRUE
        ##section <- NA
        ##        sStop <- grep("Publisert på ", art)[1]
        ##        x <- grep("------------------------------------------------------------------------------", art)[1]
        ##        while(noSec) {
        ##            x <- x + 1
        ##            if (x == sStop) {
        ##                break
        ##            }
        ##            if (any(grepl("Seksjon: ", art[x]) | grepl("SEKSJON:", art[x]))) {
        ##                section <- strsplit(sub("^.*: *(.*)", "\\1", art[x]), " ")[[1]][[1]]
        ##                noSec <- FALSE
        ##            }
        ##        }

        ## mode/url
        startsy <- grep("Publisert på", art)[1] + 1
        if (grepl("nett", art[startsy - 1])) {
            mode <- "net"
            urlLine <- grep("Se webartikkelen på ", art)
            url <- sub("Se webartikkelen på (.*)$", "\\1", art[urlLine[length(urlLine)]])
        } else {
              mode <- "print"
              url <- NA
          }
        ## main text
        
        ##stopsy <- length(art) - 4
        stopsy <- grep("©", art)
        stopsy <- stopsy[length(stopsy)]
        stopsy <- stopsy - 1
        main <- art[startsy:stopsy]
        main <- gsub("  ", " ", paste(main, collapse = " "))
        main <- gsub("  ", " ", main)  # remove (usually) the last of double-spaces
        main <- sub(" *(.*) $", "\\1", main)  # remove spaces at the beginning and end of text

        ## safty pitstop
        headline <- as.character(headline)[1]
        paper <- as.character(paper)[1]
        date <- as.character(date)[1]
        time <- as.character(time)[1]
        mode <- as.character(mode)[1]
        url <- as.character(url)[1]
        main <- as.character(main)[1]
        
        return(list("headline" = headline,
                    "paper" = paper,
                    "date" = date,
                    "time" = time,
                    "mode" = mode,
                    "url" = url,
                    "text" = main))
        ##return(c(headline, paper, date, section, main))
    })
    
    out <- data.frame("headline" = sapply(1:length(allList), function(x) return(allList[[x]]$headline)),
                      "paper" = sapply(1:length(allList), function(x) return(allList[[x]]$paper)),
                      "date" = sapply(1:length(allList), function(x) return(allList[[x]]$date)),
                      "time" = sapply(1:length(allList), function(x) return(allList[[x]]$time)),
                      "mode" = sapply(1:length(allList), function(x) return(allList[[x]]$mode)),
                      "url" = sapply(1:length(allList), function(x) return(allList[[x]]$url)),
                      ##"section" = sapply(1:length(allList), function(x) return(allList[[x]]$section)),
                      "text" = sapply(1:length(allList), function(x) return(allList[[x]]$text)))
    if (ncol(out) != 7) {
        out <- data.frame("headline" = "FAIL",
                          "paper" = "FAIL",
                          "date" = "FAIL",
                          "time" = "FAIL",
                          "mode" = "FAIL",
                          "url" = "FAIL",
                          ##"section" = "FAIL",
                          "text" = "FAIL")
    }
    
    out$headline <- as.character(out$headline)
    out$paper <- as.character(out$paper)
    out$date <- as.character(out$date)
    out$time <- as.character(out$time)
    out$mode <- as.character(out$mode)
    out$url <- as.character(out$url)
    ##out$section <- as.character(out$section)
    out$text <- as.character(out$text) 
    return(out)
}
