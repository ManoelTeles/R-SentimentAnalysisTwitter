##analise de sentimento 
#  Download de Packages (Twitter,...) para atualização de versão
install.packages("ROAuth")
install.packages("httr")
install.packages("base64enc")
install.packages("tm")
install.packages("SnowballC")
install.packages("randomForest")
install.packages("twitteR")
install.packages("wordcloud")
install.packages("Rstem")
install.packages("sentiment")

library(ROAuth)
library(httr)
library(base64enc)
library(tm)
library(SnowballC)
library(randomForest)
library(twitteR)
library(wordcloud)
library(sentiment)
require(twitteR)

#1. Localizar configuraÃ§Ãµes de OAuth para twitter (Cache) 
#2. Registrando a aplicaÃ§Ã£o do twitter -> api.twitter.com
#3. Get Credenciais OAuth (usuário testKYC)
#4. Aplicando a API 
consumer_key <- "xxx"
consumer_secret <- "xxxx"
access_token <- "xxx"
access_secret <- "xxx"

## Autenticando no Twitter
setup_twitter_oauth(consumer_key,consumer_secret,access_token, access_secret)

## Busca Twitter
tweets = searchTwitter("transitoSP", n=200)

#Conversion to data.frames
df <- twListToDF(tweets)
View(df)


write.table (df,"C:/Twits/TransitoSP.csv", sep=";")

#Recarregar dados do Arquivo csv
arquivokyc <- read.csv("C:/Users/manoe/Documents/MANOEL/R/analise_sentimento_saida.csv", header=TRUE, sep=";")
getwd()

View(arquivokyc)

# Verificar os atributos do tweet e o tipo
sapply(arquivokyc,class)

# Verificar os atributos dos Campos (Alterar o tipo de Campo)
arquivokyc$Text = as.character(arquivokyc$Text)
sapply(arquivokyc ,class)


#Pre-processamento (Conversao+Tolower+removePontuaÃ§Ã£o+RemoveNumeros+RemoveStopWords)
text <- iconv(arquivokyc$Text,to="ASCII//TRANSLIT")

#Transforma em um Corpus
myCorpus <- Corpus(VectorSource(text))
##inspect(myCorpus[1:3])
writeLines(as.character(myCorpus))

text <- tolower(text)
text <- removePunctuation(text)
text <- removeNumbers(text)

#Stopwords - Remover StopWords
text <- removeWords(text, stopwords('portuguese'))

#Steaming - reduz ao Radical
text <- stemDocument(text, language = "portuguese")

text
myCorpus <- Corpus(VectorSource(text))



# Construindo uma matriz de documentos versus termos:
docs_term <- DocumentTermMatrix(myCorpus)
docs_term
inspect(docs_term)
findFreqTerms(docs_term,lowfreq=20)

# Construindo uma matriz de termos e cada tweet que aparece
term_doc <- TermDocumentMatrix(myCorpus)
term_doc
inspect(term_doc)
findFreqTerms(term_doc,lowfreq=20)

dataset <- as.data.frame(cbind(inspect(docs_term), arquivokyc))
dataset$text <- NULL
tail(names(dataset))

############# Análise de Sentimento #########################
class_emo = classify_emotion(text, algorithm="bayes", prior=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"

# classificando polaridade
class_pol = classify_polarity(text, algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

## Apresentando resultados de sentimento ##
sent_df = data.frame(text=text, emotion=emotion,
                     polarity=polarity, stringsAsFactors=FALSE)


sent_df = within(sent_df,
                 emotion <- factor(emotion, levels=names(sort(table(emotion), 
                                                              decreasing=TRUE))))
View(sent_df)

write.table (sent_df,"C:/Users/manoe/Documents/MANOEL/R/analise_sentimento_saida.csv", sep=";")
 