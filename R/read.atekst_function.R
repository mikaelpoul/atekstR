#' Parse an atekst .txt file
#'
#' This function allows you to parse an atekst .txt-file. The function returns a data frame with the headline, paper, date, time, mode (net/print), url, and text for each article..
#' @param file Path to a .txt-file downloaded from atekst. Typically called something like "Utvalgte_dokumenter-100-01.01.2015.txt".
#' @keywords parse atekst
#' @export
#' @examples
#' corpus <- read.atekst("Utvalgte_dokumenter-100-01.01.2015.txt")
#' save(corpus, file = "atekst-corpus.RData")

read.atekst <- function(file) {
    file <- readLines(file, skipNul = TRUE, encoding = "latin1")
    file <- enc2utf8(file)
    Encoding(file) <- "UTF-8"
    
    ## Extract each article
    splits <- grep("==============================================================================", file)
    articles <- lapply(0:length(splits), function(x) {
        if (x == 0) {  # for first article
            article <- file[(grep("------------------------------------------------------------------------------", file)[1] - 6):(splits[1] - 1)]
        } else if (x == length(splits)) { # for last
            article <- file[(splits[x] + 2):(length(file) - 1)]
        } else {  
            article <- file[(splits[x] + 2):(splits[x + 1] - 1)]
        }
        return(article)
    })

    ## Then parse each article in turn
    allList <- lapply(articles, function(art) {

        ## headline
        headline <- art[grep("------------------------------------------------------------------------------", art)-2]
        
        ## paper
        paperLine <- grep(", [0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]", art)[1]
        paper <- sub("(,*),.*", "\\1", art[paperLine])

        ## date/time
        dateRaw <- sub(".*, (.*)", "\\1", art[paperLine])
        dateRaw <- strsplit(dateRaw, " ")[[1]]
        date <- dateRaw[1]
        time <- NA
        if (length(dateRaw) == 2) {
            time <- dateRaw[2]
        }
        
        ## mode/url
        starting <- grep("Publisert p", art)[1] + 1
        if (grepl("nett", art[starting - 1])) {
            mode <- "net"
            urlLine <- grep("Se webartikkelen p", art)
            url <- sub("Se webartikkelen p. (.*)$", "\\1", art[urlLine[length(urlLine)]])
        } else {
              mode <- "print"
              url <- NA
        }
        
        ## main text (as "main")
        FoundEnd <- FALSE
        firstRound <- FALSE
        x <- length(art) + 1
        if (mode == "paper") {  # a slow but safe way to find the end of the main text
            while(!FoundEnd) {
                x <- x - 1
                if (grepl("[A-Za-z]", art[x])) {
                    FoundEnd <- TRUE
                }
            }
        } else {
            while(!FoundEnd) {
                x <- x - 1
                if (firstRound) {
                    if (grepl("[A-Za-z]", art[x])) {
                        FoundEnd <- TRUE
                    }
                } else {
                    if (grepl("[A-Za-z]", art[x])) {
                        firstRound <- TRUE
                    }
                }
            }
        }
        stopping <- x - 1
        main <- art[starting:stopping]
        main <- gsub("  ", " ", paste(main, collapse = " "))
        main <- gsub("  ", " ", main)  # remove (usually) the last of double-spaces
        main <- sub(" *(.*) $", "\\1", main)  # remove spaces at the beginning and end of text

        ## Sometimes it carries more than one vector per element, screwing things up
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
    })
    
    out <- data.frame("headline" = sapply(1:length(allList), function(x) return(allList[[x]]$headline)),
                      "paper" = sapply(1:length(allList), function(x) return(allList[[x]]$paper)),
                      "date" = sapply(1:length(allList), function(x) return(allList[[x]]$date)),
                      "time" = sapply(1:length(allList), function(x) return(allList[[x]]$time)),
                      "mode" = sapply(1:length(allList), function(x) return(allList[[x]]$mode)),
                      "url" = sapply(1:length(allList), function(x) return(allList[[x]]$url)),
                      "text" = sapply(1:length(allList), function(x) return(allList[[x]]$text)))
    
    out$headline <- as.character(out$headline)
    out$paper <- as.character(out$paper)
    out$date <- as.character(out$date)
    out$time <- as.character(out$time)
    out$mode <- as.character(out$mode)
    out$url <- as.character(out$url)
    out$text <- as.character(out$text) 
    return(out)
}
