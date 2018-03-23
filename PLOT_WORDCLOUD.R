##WORDCLOUND 

##INSTALANDO PACKAGES

install.packages("XML")
install.packages("tm")
install.packages("wordcloud")
install.packages("RColorBrewer")

library(XML)
library(tm)
library(wordcloud)
library(RColorBrewer)

require(XML)
require(tm)
require(wordcloud)
require(RColorBrewer)

#Recarregar dados do Arquivo csv
arquivo_tratado <- read.csv("C:/Users/manoe/Documents/MANOEL/R/Script_Final/Datasets_Tratado/calculo_renal.csv", header=TRUE, sep=";")
getwd()

sapply(arquivo_tratado ,class)

# Verificar os atributos dos Campos (Alterar o tipo de Campo)
arquivo_tratado$text = as.character(arquivo_tratado$text)
arquivo_tratado$screenName = as.character(arquivo_tratado$screenName)
arquivo_tratado$created = as.Date(arquivo_tratado$created)
sapply(arquivo_tratado ,class)
View(arquivo_tratado)


wordcloud(arquivo_tratado$text, scale = c(8,0.5), max.words = 2000, random.order = FALSE,
          rot.per = 0.55, use.r.layout = FALSE, colors = brewer.pal(8, "Dark2"))

