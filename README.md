### parseAtekst

This R-package provides functions for parsing .txt-files downloaded from [ATEKST](http://www.retriever-info.com/no/category/news-archive/) that imports individual articles (and metadata) into R. They return a data frame with the headline, paper, date and time of publication, mode (net vs print), url and text of each news article. The package includes two functions (see the [**documentation**](https://github.com/mikaelpoul/parseAtekst/raw/master/docs/parseAtekst-docs-v1.2.pdf)):

- `read.atekst()` Import articles from a single .txt-file.
- `read.atekst.dir()` Import articles from all .txt-files in a directory (including subfolders).

#### Installation

You need the `devtools` package in order to install `parseAtekst`. You can install it using the follow code (note that you only need to run this once):

``` R
if(!require(devtools)) install.packages("devtools")
```

You can then load `devtools` and install `parseAtekst` by running:

``` R
library(devtools)
install_github("mikaelpoul/parseAtekst", dependencies = TRUE)
```

#### Contact

If you have any problems or suggestions, feel free to [open an issue](https://github.com/mikaelpoul/parseAtekst/issues/new) or send me an [email](mailto:mikajoh@gmail.com). I welcome corrections, suggestions or questions large or small.
