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

set.seed(123)

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
                'nseats', 'ndoors','tsize', 'mspeed', 'bocapacity', 'acceleration', 'mcpower', 'cenergy')
                

# Deleting columns make, car and model
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

# Finding null values
sum(is.na(df))

# Deleting rows that have null values
df <- na.omit(df)

# Dividing data in training and test
split <- createDataPartition(y = df$cenergy, p = 0.7, list = FALSE)

train_data <- df[split,]
test_data <- df[-split,]

# Training the first version of model with all columns
model.v1 <- lm(cenergy ~ ., data = train_data)

model.v1

# Summary first model
summary(model.v1)

predictedValues <- predict(model.v1, test_data)
predictedValues
plot(test_data$cenergy, predictedValues)

# Second Model
# In this model, only variables that had statistical significance
# Pr(>|t|) less than 0.05 were considered.
model.v2 <- lm(cenergy ~ dtype + range + bocapacity, data = train_data)

model.v2

# Summary second model
summary(model.v2)

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

cor(df[select.variables])

# Dividing data in training and test
split <- createDataPartition(y = df$cenergy, p = 0.7, list = FALSE)

model.v3 <- lm(cenergy ~ mprice + power + mtorque + bcapacity + wheelbase
               + length + mweight + mcapacity + mspeed + bocapacity + mcpower, data = train_data)

model.v3

# Summary second model
summary(model.v3)
