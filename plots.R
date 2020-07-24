library(ggplot2)
library(readr)
library(viridis)
library(scales)
library(plotly)
library(htmlwidgets)
options(browser = "/usr/bin/firefox")

african_data <- read_csv("../../african_data.csv")
african_data$Date <- as.Date(as.character(african_data$Date), format = "%Y-%m-%d")

names(african_data)[14] <- "Stay At Home Requirements"
african_data$y <- african_data$CountryName

home_data <- african_data[, names(african_data) %in% c("Date", "CountryName", "Stay At Home Requirements")]

home_data <- home_data[complete.cases(home_data), ]

home_data$CountryName <- factor(home_data$CountryName,levels=rev(unique(home_data$CountryName)))

home_data <- home_data[home_data$Date > "2020-02-14", ]

home_data <- home_data[home_data$CountryName != "France",]

p <- ggplot(home_data, aes(x = Date, y = CountryName, fill = `Stay At Home Requirements`)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    geom_tile() +
    scale_fill_gradientn(
#        colours = c("gray81", "lightblue1", "#0066CC"),
        colours = c("gray81", "lightblue1", "#0066CC", "navyblue"), #j orig
        limits = c(0, 3),  ## there are 4 categories
        oob = squish) +
    labs(x = "", y = "") +
    scale_x_date(date_breaks = "2 weeks", date_labels = "%b-%d")


home <- ggplotly(p)

saveWidget(home, "stay_home_status.html")

