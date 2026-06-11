# 02_charts.R
# Builds the three charts in output/ from the CSVs in data/.

# install.packages(c("dplyr", "readr", "ggplot2"))  # first run only
library(dplyr)
library(readr)
library(ggplot2)

gdp <- read_csv("data/gdp_growth.csv")
cpi <- read_csv("data/inflation.csv")
rem <- read_csv("data/remittances.csv")

# Uzbekistan drawn thick so the eye lands on it first.
pal <- c(Uzbekistan = "#1a6fb5", Kazakhstan = "#888888",
         `Kyrgyz Republic` = "#c98a2b", Tajikistan = "#5aa469")

theme_set(theme_minimal(base_size = 11))

# Figure 1: GDP growth, Uzbekistan vs neighbours -----------------------------
gdp |>
  filter(iso3c != "RUS") |>
  ggplot(aes(year, gdp_growth, colour = country,
             linewidth = country == "Uzbekistan")) +
  geom_hline(yintercept = 0, linewidth = 0.3) +
  geom_line() +
  scale_colour_manual(values = pal) +
  scale_linewidth_manual(values = c(0.6, 1.4), guide = "none") +
  labs(title = "GDP growth, Uzbekistan vs Central Asian neighbours, 2008–2024",
       y = "annual %", x = NULL, colour = NULL,
       caption = "Source: World Bank WDI (NY.GDP.MKTP.KD.ZG)")
ggsave("output/fig1_gdp_growth.png", width = 8, height = 4.5, dpi = 150)

# Figure 2: inflation in Uzbekistan, with the 2017 liberalization marked -----
cpi |>
  filter(iso3c == "UZB") |>
  ggplot(aes(year, inflation)) +
  geom_vline(xintercept = 2017, colour = "#b35454", linetype = "dashed") +
  geom_line(colour = "#1a6fb5", linewidth = 1.2) +
  geom_point(colour = "#1a6fb5", size = 1.6) +
  annotate("text", x = 2016.8, y = 16.5, hjust = 1, size = 3,
           colour = "#b35454",
           label = "Sept 2017: som float +\nFX liberalization") +
  labs(title = "Inflation in Uzbekistan, 2011–2024 (consumer prices, annual %)",
       y = "annual %", x = NULL,
       caption = "Source: World Bank WDI (FP.CPI.TOTL.ZG)")
ggsave("output/fig2_inflation_uzb.png", width = 8, height = 4.5, dpi = 150)

# Figure 3: remittances, % of GDP --------------------------------------------
rem |>
  ggplot(aes(year, remit_gdp, colour = country,
             linewidth = country == "Uzbekistan")) +
  geom_line() +
  scale_colour_manual(values = pal) +
  scale_linewidth_manual(values = c(0.6, 1.4), guide = "none") +
  labs(title = "Personal remittances received, % of GDP, 2008–2024",
       y = "% of GDP", x = NULL, colour = NULL,
       caption = "Source: World Bank WDI (BX.TRF.PWKR.DT.GD.ZS)")
ggsave("output/fig3_remittances.png", width = 8, height = 4.5, dpi = 150)
