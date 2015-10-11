## parseAtekst: An R package for extracting articles from .txt-files downloaded from [ATEKST](http://www.retriever-info.com/no/category/news-archive/)

See the [**documentation**](https://github.com/mikaelpoul/parseAtekst/raw/master/docs/parseAtekst-docs-v1.1.pdf).

#### Summary

[Retriever](http://www.retriever-info.com/)'s online Norwegian media archive [ATEKST](http://www.retriever-info.com/en/category/news-archive/) makes it possible for researchers to search through their extensive archive in Scandinavia and download news articles based on that search. Typically one can download up to 100 articles at a time bundled together in one .txt-file, designed for printing and reading a selection of articles. With the recent advances in quantitative text analysis (QTA), QTA have become a particularly efficient and powerful way to explore and analyze such collections of text, with several easy-to-use R-packages now being available. However, importing the bundled articles downloaded from [ATEKST](http://www.retriever-info.com/no/category/news-archive/) appropriately into R so to be able to use these packages might not be so easy. This R-package provides the ability to parse .txt-files downloaded from [ATEKST](http://www.retriever-info.com/no/category/news-archive/), extract all articles (with meta data) and import them into R.

The package currently includes two functions (see the [**documentation**](https://github.com/mikaelpoul/parseAtekst/raw/master/docs/parseAtekst-docs-v1.1.pdf)):

- `read.atekst()` Parse and import a single .txt-file.
- `read.atekst.dir()` Parse and import all .txt-files in a directory (including subfolders).

Both functions returns a data frame with the headline, paper, date and time of publication, mode (net vs print), url and text of each news article.

#### Installation

You need the `devtools` package in order to install `parseAtekst`. You can install it using the follow code (note that you only need to run this once):

``` R
if(!require(devtools)) install.packages("devtools")
```

You can then load `devtools` and install `parseAtekst` by running

``` R
library(devtools)
install_github("mikaelpoul/parseAtekst", dependencies = TRUE)
```

#### Contact

If you have any problems or suggestions, feel free to [open an issue](https://github.com/mikaelpoul/parseAtekst/issues/new) or send me an [email](mailto:mikajoh@gmail.com). I welcome corrections, suggestions or questions large or small.


-------


Created by [Mikael Poul Johannesson](mailto:mikajoh@gmail.com). The package and source code is provided under the GNU GPL V2 license, meaning its [free software](http://www.gnu.org/philosophy/free-sw.en.html). A copy of the license can be found in the [`LICENSE`](https://github.com/mikaelpoul/parseAtekst/blob/master/LICENSE) file.

