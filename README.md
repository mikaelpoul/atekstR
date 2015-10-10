**parseAtekst**: An R-package for extracting articles (with metadata) from .txt-files downloaded from [Retriever's](http://www.retriever-info.com) online Norwegian media archive [ATEKST](http://www.retriever-info.com/no/category/news-archive/).

See the [documentation](https://github.com/mikaelpoul/parseAtekst/raw/master/docs/parseAtekst-docs-v1.1.pdf).

> The Retriever (http://www.retriever-info.com/) online Norwegian media archive ATEKST (C) allows researchers to search through their media archive and download news articles based on that search. Typically one can download up to 100 articles at a time bundled together within a .txt-file. With the recent advances in quantitative text analysis (QTA), QTA have become a particularly efficient and powerful way to explore and analyze such collections of text, with several easy-to-use R-packages now being available. However, importing the bundled articles downloaded from ATEKST appropriately into R so to be able to use these packages might not be so easy. This R-package provides the abilityto parse .txt-files downloaded from ATEKST, extract all articles and import them into R. The inluded functions returns a data frame with the headline, paper, date and time of publication, mode (net vs print), url and text of each news article. It is possible to parse a single .txt-file with `read.atekst()` or all .txt-files in a directory (including subfolders) with `read.atekst.dir()`.


#### Installation

To install the package, run:

``` R
devtools::install_github("mikaelpoul/parseAtekst")
```

#### Contact

If you have any problems or suggestions, feel free to [open an issue](https://github.com/mikaelpoul/parseAtekst/issues/new) or send me an [email](mailto:mikajoh@gmail.com). I welcome corrections, suggestions or questions large or small.


-------


Created by [Mikael Poul Johannesson](mailto:mikajoh@gmail.com). The package and source code is provided under the GNU GPL V2 license, meaning its [free software](http://www.gnu.org/philosophy/free-sw.en.html). A copy of the license can be found in the [`LICENSE`](https://github.com/mikaelpoul/parseAtekst/blob/master/LICENSE) file.
