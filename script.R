## Predict Consumer Electric Cars

# Data Source
# https://data.mendeley.com/datasets/tb9yrptydn/2

setwd("/home/cienciad/fcd/1-BigDataRAzure/projetos/consumer-electric-cars/")
getwd()

# Installing necessary packages
# install.packages("readxl")
# install.packages("dplyr")

# Loading necessary packages
library('readxl')
library('dplyr')

# Importing file
df <- read_excel("FEV-data-Excel.xlsx")

# Number lines
count(df)

# First rows
head(df)

# Statistics summary
summary(df)

# Renaming columns
colnames(df) <-c('car', 'make', 'model', 'mprice', 'power', 'mtorque', 'tbrakes', 'dtype', 'bcapacity', 
                'range', 'wheelbase', 'length', 'width','height','mweight', 'pweight', 'mcapacity', 
                'nseats', 'ndoors','tsize', 'mspeed', 'bcapacity', 'acceleration', 'mcpower', 'cenergy')
                

# Deleting columns car and model
df$car <- NULL
df$model <- NULL

