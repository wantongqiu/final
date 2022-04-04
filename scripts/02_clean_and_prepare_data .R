
library(janitor)
library(pdftools)
library(purrr)
library(tidyverse)
library(stringi)
setwd("~/Desktop/2022 winter/STA304/paper4")
#install.packages("pdftools")
library("pdftools")
all_content <- pdf_text("FRIND1.pdf")
just_page_i <- stri_split_lines(all_content[[83]])[[1]]  # see pg 83
just_page_i

just_page_i <- just_page_i[just_page_i != ""] # delete empty line
just_page_i

# Grab the type of table
type_of_table <- just_page_i[1] |> str_squish()
type_of_table

# Get rid of the top matter
# Manually for now, but could create some rules if needed
just_page_i_no_header <- just_page_i[38:length(just_page_i)]
just_page_i_no_header
# Get rid of the bottom matter
# Manually for now, but could create some rules if needed
just_page_i_no_header_no_footer <- just_page_i_no_header[1:10] 
just_page_i_no_header_no_footer

# Convert into a tibble
raw_data <- tibble(all = just_page_i_no_header_no_footer)
raw_data

# Split columns
raw_data |>
  mutate(all = str_squish(all)) # Any space more than two spaces is reduced
  
raw_data <-
  raw_data |>
  mutate(all = str_squish(all)) |> # Any space more than two spaces is reduced
  mutate(all = str_replace(all, "6 - 9", "6-9")) |> # One specific issue
  separate(col = all,
           into = c("age", "illiterate", "literate", "Primary_school", "middle_school", "high_school", 
                    "above_high_school", "missing","total_percent","number","median_number_of_years_of_schooling"),
           sep = " ", # Works fine because the tables are nicely laid out
           remove = TRUE,
           fill = "right",
           extra = "drop"
  )

raw_data


# There is one row of NAs, so remove it
raw_data <- 
  raw_data|> 
  remove_empty(which = c("rows"))

# Add the area and the page
raw_data$table <- type_of_table
raw_data$page <- 51
raw_data

write_csv(raw_data, "/Users/wantongqiu/Desktop/2022 winter/STA304/raw_data.csv")





