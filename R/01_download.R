# 01_download.R
# Downloads macro indicators for Uzbekistan and neighbours from the
# World Bank WDI API and saves them as tidy CSVs in data/.
# Run once to refresh the data; the repo ships with a recent snapshot.

# install.packages(c("WDI", "dplyr", "readr"))  # first run only
library(WDI)
library(dplyr)
library(readr)

countries <- c("UZ", "KZ", "KG", "TJ", "RU")

# Each indicator gets its own CSV so the analysis scripts stay simple.
indicators <- c(
  gdp_growth = "NY.GDP.MKTP.KD.ZG",   # GDP growth, annual %
  inflation  = "FP.CPI.TOTL.ZG",      # CPI inflation, annual %
  remit_gdp  = "BX.TRF.PWKR.DT.GD.ZS" # remittances received, % of GDP
)

for (name in names(indicators)) {
  df <- WDI(country = countries, indicator = indicators[[name]],
            start = 2008, end = 2025) |>
    rename(value = 5) |>                 # WDI names the column after the code
    filter(!is.na(value)) |>             # drop years not yet reported
    transmute(iso3c, country, year,
              !!name := round(value, 2)) |>
    arrange(iso3c, year)
  write_csv(df, file.path("data", paste0(name, ".csv")))
}
