### atekstR

This R-package provides functions for extracting articles (with metadata) from .txt-files downloaded from [ATEKST](http://www.retriever-info.com/no/category/news-archive/) and import them into R. They return a data frame with the headline, paper, date and time of publication, mode (net vs print), url and text of each news article. The package includes two functions (see the [**documentation**](https://github.com/mikaelpoul/atekstR/raw/master/docs/atekstR-docs-v1.2.pdf)):

- `read.atekst()` Import articles from a single .txt-file.
- `read.atekst.dir()` Import articles from all .txt-files in a directory (including subfolders).

#### Installation

You need the `devtools` package in order to install `atekstR`. You can install it using the follow code (note that you only need to run this once):

``` R
if(!require(devtools)) install.packages("devtools")
```

You can then load `devtools` and install `atekstR` by running:

``` R
library(devtools)
install_github("mikaelpoul/atekstR", dependencies = TRUE)
```

#### Contact

If you have any problems or suggestions, feel free to [open an issue](https://github.com/mikaelpoul/atekstR/issues/new) or send me an [email](mailto:mikajoh@gmail.com). I welcome corrections, suggestions or questions large or small.
