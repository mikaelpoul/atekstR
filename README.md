**parseAtekst**: An R-package for extracting articles (with metadata) from .txt-files downloaded from [Retriever' online Norwegian media archive *ATEKST*](http://www.retriever-info.com/no/category/news-archive/), by [Mikael Poul Johannesson](mailto:mikajoh@gmail.com).

> The Retriever (http://www.retriever-info.com/) online Norwegian media archive ATEKST (C) allows researchers to search through their media archive and download news articles based on that search. Typically one can download up to 100 articles at a time bundled together within a .txt-file. With the recent advances in quantitative text analysis (QTA), QTA have become a particularly efficient and powerful way to explore and analyse such collections of text, with several easy-to-use R-packages now being available. However, importing the bundled articles downloaded from ATEKST appropriately into R so to be able to use these packages might not be so easy. This R-package provides functions for parsing .txt-files downloaded from ATEKST, all articles and import them into R. The functions return a data frame with the headline, paper, date and time of publication, mode (net vs print), url and text of each news article.

See the [documentation]().

#### Installation

To install the package, run:

``` R
devtools::install_github("mikaelpoul/parseAtekst")
```

#### Contact

If you have any problems or suggestions, please [open an issue](https://github.com/mikaelpoul/parseAtekst/issues/new) or send me an [email](mikajoh@gmail.com).
