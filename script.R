## Prevendo o Consumo de Emergia de Carros Elétricos

# Fonte de Dados
# https://data.mendeley.com/datasets/tb9yrptydn/2

setwd("/home/cienciad/fcd/1-BigDataRAzure/projetos/consumer-electric-cars/")
getwd()

# Instalando o pacote necessários
# install.packages("readxl")
# install.packages("dplyr")

# Carregando pacotes
library('readxl')
library('dplyr')

# Importando o arquivo para um dataframe
df <- read_excel("FEV-data-Excel.xlsx")

# Número de linhas do arquivo
count(df)

# Primeiras linhas do arquivo
head(df)
