# Prevendo o Consumo de Emergia de Carros Elétricos

# Fonte de Dados
# https://data.mendeley.com/datasets/tb9yrptydn/2

setwd("/home/cienciad/fcd/1-BigDataRAzure/projetos/consumer-eletric-cars/")
getwd()

# Carregando os dados

# Instalando o pacote
install.packages("readxl")

# Pacote readxl
library(readxl)

# Lendo a planilha do Excel
View(read_excel("FEV-data-Excel.xlsx"))

# Importando uma worksheet para um dataframe
df <- read_excel("FEV-data-Excel.xlsx")
View(df)



