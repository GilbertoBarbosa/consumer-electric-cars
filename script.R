## Predict Consumer Electric Cars

# Data Source
# https://data.mendeley.com/datasets/tb9yrptydn/2

setwd("/home/cienciad/fcd/1-BigDataRAzure/projetos/consumer-electric-cars/")
getwd()

# Installing necessary packages
# install.packages("readxl")
# install.packages("dplyr")
# install.packages("caret")

# Loading necessary packages
library('readxl')
library('dplyr')
library('caret')
library('ggplot2')
library('dplyr')

set.seed(123)

####################################################
################## DATA EXPLORATION ################
####################################################

# Importing file
df <- read_excel("FEV-data-Excel.xlsx")

# Number lines
count(df)

# First rows
head(df)

# Finding null values
sum(is.na(df))

# Deleting rows that have null values
df <- na.omit(df)

# Statistics summary
summary(df)
str(df)

# Renaming columns
colnames(df) <-c('car', 'make', 'model', 'mprice', 'power', 'mtorque', 'tbrakes', 'dtype', 'bcapacity', 
                'range', 'wheelbase', 'length', 'width','height','mweight', 'pweight', 'mcapacity', 
                'nseats', 'ndoors','tsize', 'mspeed', 'bocapacity', 'acceleration', 'mcpower', 'cenergy')

# Categorical Variables

# Make
g <- ggplot(df, aes(make))
g + geom_bar()

# Type of brakes
g <- ggplot(df, aes(tbrakes))
g + geom_bar()

# Drive type
g <- ggplot(df, aes(dtype))
g + geom_bar()


# Numerical Variables

# Minimal price ( * 100)
df['mprice2'] = df['mprice']/100
ggplot(df, aes(x=mprice2)) +
  geom_boxplot()

# Outlier Minimal Price:
filter(df[c('car','mprice')], mprice == max(df['mprice']))

# Engine power
ggplot(df, aes(x=power)) +
  geom_boxplot()

# Outlier Engine power:
filter(df[c('car','power')], power == max(df['power']))

# Width
ggplot(df, aes(x=width)) +
  geom_boxplot()

# Outlier Engine power:
filter(df[c('car','width')], width == max(df['width']))

# Maximum speed
ggplot(df, aes(x=mspeed)) +
  geom_boxplot()

# Outlier Engine power:
filter(df[c('car','mspeed')], mspeed == max(df['mspeed']))

# Acceleration
ggplot(df, aes(x=acceleration)) +
  geom_boxplot()

# Mean Energy consuption
ggplot(df, aes(x=cenergy)) +
  geom_boxplot()

# Price x Acceleration
ggplot(df, aes(x = mprice2, y = acceleration, colour = make)) + 
  geom_point()

# Price x Engine Power
ggplot(df, aes(x = mprice2, y = power, colour = make)) + 
  geom_point()

# Energy consumption x Acceleration
ggplot(df, aes(x = cenergy, y = acceleration, colour = make)) + 
  geom_point() 

# Energy consumption x Maximum Torque
ggplot(df, aes(x = cenergy, y = mtorque, colour = make)) + 
  geom_point() 

# Energy Consumption x Maximum Empty Weight
ggplot(df, aes(x = cenergy, y = mweight, colour = make)) + 
  geom_point() 

#####################################################
################## FEATURE SELECTION ################
#####################################################               

# Deleting columns make, car and model because the algorithm
# Linear Regression need only numeric values
df$make <- NULL
df$car <- NULL
df$model <- NULL

table(df$tbrakes)

# Replace tbrakes column values for numbers
df$tbrakes <- replace(df$tbrakes, is.na(df$tbrakes), 0)
df$tbrakes <- replace(df$tbrakes, df$tbrakes == "disc (front + rear)", 1)
df$tbrakes <- replace(df$tbrakes, df$tbrakes == "disc (front) + drum (rear)", 2)

table(df$dtype)

# Replace dtypes column values for numbers
df$dtype <- replace(df$dtype, df$dtype == "2WD (front)", 1)
df$dtype <- replace(df$dtype, df$dtype == "2WD (rear)", 2)
df$dtype <- replace(df$dtype, df$dtype == "4WD", 3)


#####################################################
################## MODEL TRAINING ##################
####################################################

# First Model

# Dividing data in training and test
split <- createDataPartition(y = df$cenergy, p = 0.7, list = FALSE)

train_data <- df[split,]
test_data <- df[-split,]

# Training the first version of model with all variables
model.v1 <- lm(cenergy ~ ., data = train_data)

model.v1

# Summary first model
summary(model.v1)

# Second Model

# In this model, only variables that had statistical significance
# Pr(>|t|) less than 0.05 were considered.
model.v2 <- lm(cenergy ~ dtype + range + bocapacity, data = train_data)

model.v2

# Summary second model
summary(model.v2)

# Third Model

# Deleting non-numeric variables
df$tbrakes <- NULL
df$dtype <- NULL

# Correlation between all numeric variables
cor(df[c('mprice', 'power', 'mtorque', 'bcapacity', 'range', 'wheelbase', 'length', 'width', 'height',
         'mweight', 'pweight', 'mcapacity', 'nseats', 'ndoors','tsize', 'mspeed', 'bocapacity', 'acceleration', 
         'mcpower', 'cenergy')])

# Variables range, width, height, nseats, ndoors, tsize and acceleration
# don't have strong correlation with the variable cenergy

select.variables <- c('mprice', 'power', 'mtorque', 'bcapacity', 'wheelbase', 'length',
                      'mweight', 'pweight', 'mcapacity', 'mspeed', 'bocapacity',
                      'mcpower', 'cenergy')

# Correlation
cor(df[select.variables])

# Dividing data in training and test
split <- createDataPartition(y = df$cenergy, p = 0.7, list = FALSE)

# Training Third Model
model.v3 <- lm(cenergy ~ mprice + power + mtorque + bcapacity + wheelbase
               + length + mweight + mcapacity + mspeed + bocapacity + mcpower, data = train_data)

model.v3

# Summary Third Model
summary(model.v3)
