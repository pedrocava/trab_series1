library(rio)
library(tibble)
library(dplyr)
library(lubridate)
library(tsibble)
library(xts)

dados = import("AEP_hourly.csv") %>% as_tibble()

dados = distinct(dados, 
                 Datetime, 
                 .keep_all = TRUE)

dados$mes = substring(dados$Datetime, first = 6, last = 7) %>% as.factor()

dados$Datetime = as_datetime(dados$Datetime)
dados$t = seq(1, to = nrow(dados))
dados$mes = as.numeric(dados$mes)
dados$estacao = ifelse(dados$mes >= 3 & dados$mes <= 5, "Primaveira",
                       ifelse(dados$mes >= 6 & dados$mes <= 8, "Verão",
                              ifelse(dados$mes >= 9 & dados$mes <= 11, "Outono",
                                     ifelse(dados$mes > 11 | dados$mes <= 2, "Inverno", "")))) %>% factor()
dados$mes = dados$mes %>% as.factor()

dados$consumo = dados$AEP_MW
dados$AEP_MW = NULL

dados = as_tsibble(dados, index = Datetime)

saveRDS(dados, "dados.Rds")


indice = seq(from = as.POSIXct(head(dados$Datetime, n = 1)), 
             to = as.POSIXct(tail(dados$Datetime, n = 1)),
             by = "hour")

indicador = ifelse(indice %in% setdiff(indice, dados$Datetime), 
                         TRUE, 
                         FALSE)

matriz = tibble(indice = indice,
                indicador = indicador)

matriz = matriz[indicador == FALSE,]
indice = matriz$indice

serie = xts(dados$consumo, order.by = indice)

saveRDS(serie, "serie.Rds")

diaria = to.daily(serie)
diaria = (diaria$serie.High + diaria$serie.Low)/2

saveRDS(diaria, "diaria.Rds")
