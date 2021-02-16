
<!-- README.md is generated from README.Rmd. Please edit that file -->

This repository holds all data and code used for SOC 721S.

I’m not sharing the `raw_data` folder, which is quite heavy.

``` r
sum(fs::file_size(dir("raw_data", full.names = TRUE, recursive = TRUE)))
#> 5.01G
```

And is structured like this:

``` r
fs::dir_tree("raw_data")
#> raw_data
#> ├── 1979
#> │   ├── NHSDA-1979-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1979-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1979-DS0001-data-stata.dta
#> │   └── NHSDA-1979-DS0001-info-codebook.pdf
#> ├── 1982
#> │   ├── NHSDA-1982-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1982-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1982-DS0001-data-stata.dta
#> │   └── NHSDA-1982-DS0001-info-codebook.pdf
#> ├── 1985
#> │   ├── NHSDA-1985-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1985-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1985-DS0001-data-stata.dta
#> │   └── NHSDA-1985-DS0001-info-codebook.pdf
#> ├── 1988
#> │   ├── NHSDA-1988-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1988-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1988-DS0001-data-stata.dta
#> │   └── NHSDA-1988-DS0001-info-codebook.pdf
#> ├── 1990
#> │   ├── NHSDA-1990-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1990-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1990-DS0001-data-stata.dta
#> │   └── NHSDA-1990-DS0001-info-codebook.pdf
#> ├── 1991
#> │   ├── NHSDA-1991-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1991-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1991-DS0001-data-stata.dta
#> │   └── NHSDA-1991-DS0001-info-codebook.pdf
#> ├── 1992
#> │   ├── NHSDA-1992-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1992-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1992-DS0001-data-stata.dta
#> │   └── NHSDA-1992-DS0001-info-codebook.pdf
#> ├── 1993
#> │   ├── NHSDA-1993-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1993-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1993-DS0001-data-stata.dta
#> │   └── NHSDA-1993-DS0001-info-codebook.pdf
#> ├── 1994
#> │   ├── NHSDA-1994-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1994-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1994-DS0001-data-stata.dta
#> │   ├── NHSDA-1994-DS0001-info-codebook.pdf
#> │   ├── NHSDA-1994-DS0002-bndl-data-stata.zip
#> │   ├── NHSDA-1994-DS0002-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1994-DS0002-data-stata.dta
#> │   └── NHSDA-1994-DS0002-info-codebook.pdf
#> ├── 1995
#> │   ├── NHSDA-1995-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1995-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1995-DS0001-data-stata.dta
#> │   └── NHSDA-1995-DS0001-info-codebook.pdf
#> ├── 1996
#> │   ├── NHSDA-1996-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1996-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1996-DS0001-data-stata.dta
#> │   └── NHSDA-1996-DS0001-info-codebook.pdf
#> ├── 1997
#> │   ├── NHSDA-1997-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1997-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1997-DS0001-data-stata.dta
#> │   └── NHSDA-1997-DS0001-info-codebook.pdf
#> ├── 1998
#> │   ├── NHSDA-1998-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1998-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1998-DS0001-data-stata.dta
#> │   └── NHSDA-1998-DS0001-info-codebook.pdf
#> ├── 1999
#> │   ├── NHSDA-1999-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-1999-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-1999-DS0001-data-stata.dta
#> │   └── NHSDA-1999-DS0001-info-codebook.pdf
#> ├── 2000
#> │   ├── NHSDA-2000-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-2000-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-2000-DS0001-data-stata.dta
#> │   └── NHSDA-2000-DS0001-info-codebook.pdf
#> ├── 2001
#> │   ├── NHSDA-2001-DS0001-bndl-data-stata.zip
#> │   ├── NHSDA-2001-DS0001-data-stata-supplemental-syntax.do
#> │   ├── NHSDA-2001-DS0001-data-stata.dta
#> │   └── NHSDA-2001-DS0001-info-codebook.pdf
#> ├── 2002
#> │   ├── NSDUH-2002-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2002-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2002-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2002.DTA
#> ├── 2003
#> │   ├── NSDUH-2003-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2003-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2003-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2003.DTA
#> ├── 2004
#> │   ├── NSDUH-2004-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2004-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2004-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2004.DTA
#> ├── 2005
#> │   ├── NSDUH-2005-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2005-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2005-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2005.DTA
#> ├── 2006
#> │   ├── NSDUH-2006-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2006-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2006-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2006.DTA
#> ├── 2007
#> │   ├── NSDUH-2007-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2007-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2007-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2007.DTA
#> ├── 2008
#> │   ├── NSDUH-2008-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2008-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2008-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2008.DTA
#> ├── 2009
#> │   ├── NSDUH-2009-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2009-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2009-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2009.DTA
#> ├── 2010
#> │   ├── NSDUH-2010-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2010-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2010-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2010.DTA
#> ├── 2011
#> │   ├── NSDUH-2011-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2011-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2011-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2011.DTA
#> ├── 2012
#> │   ├── NSDUH-2012-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2012-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2012-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2012.DTA
#> ├── 2013
#> │   ├── NSDUH-2013-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2013-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2013-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2013.DTA
#> ├── 2014
#> │   ├── NSDUH-2014-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2014-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2014-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2014.DTA
#> ├── 2015
#> │   ├── NSDUH-2015-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2015-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2015-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2015.DTA
#> ├── 2016
#> │   ├── NSDUH-2016-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2016-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2016-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2016.DTA
#> ├── 2017
#> │   ├── NSDUH-2017-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2017-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2017-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2017.DTA
#> ├── 2018
#> │   ├── NSDUH-2018-DS0001-bndl-data-stata.zip
#> │   ├── NSDUH-2018-DS0001-info-codebook.pdf
#> │   ├── NSDUH-2018-data-stata-supplemental-syntax.do
#> │   └── NSDUH_2018.DTA
#> └── 2019
#>     ├── NSDUH-2019-DS0001-bndl-data-stata.zip
#>     ├── NSDUH-2019-DS0001-info-codebook.pdf
#>     ├── NSDUH-2019_data-stata-supplemental-syntax.do
#>     └── NSDUH_2019.DTA
```
