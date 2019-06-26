library(forecast)
library(ggplot2)
library(tseries)
library(xts)

serie = readRDS("serie.Rds")

serie = to.daily(serie)
serie = (serie$serie.High + serie$serie.Low)/2

autoplot(serie) +
  ylab("Consumo em MW/hora") + 
  xlab("") +
  labs(title = "Dados de consumo de uma unidade geradora de Furnas")

adf.test(treino, 
         alternative = "explosive")

ggAcf(serie)
ggPacf(serie)

arima = auto.arima(serie, 
           stationary = TRUE, 
           seasonal = TRUE,
           max.order = 10000)

hist(residuals(arima))

previsao = forecast(arima, h = 31)
erro = as.numeric(previsao$mean) - as.numeric(teste)
