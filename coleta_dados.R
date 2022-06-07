####################################################################
#################### Coleta de Dados com o R #######################
####################################################################


library(GetBCBData) # CRAN v0.6
library(rbcb)       # CRAN v0.1.8
library(ipeadatar)  # CRAN v0.1.5
library(sidrar)     # CRAN v0.2.7
library(OECD)       # CRAN v0.2.4
library(imfr)       # CRAN v0.1.9.1
library(WDI)        # CRAN v2.7.6
library(dplyr)      # CRAN v1.0.7
library(stringr)    # CRAN v1.4.0
library(tidyr)      # CRAN v1.2.0
library(magrittr)   # CRAN v2.0.2
library(tidyverse)

# Coletar dados da SELIC no SGS/BCB
dados_sgs <- GetBCBData::gbcbd_get_series(
  id          = 432,
  first.date  = "2020-01-01",
  last.date   = Sys.Date()
)

tail(dados_sgs)

# Coletar dados de várias séries no SGS/BCB
dados_sgs <- GetBCBData::gbcbd_get_series(
  id          = c("Dólar" = 3698, "IBC-Br" = 24363, 
                  "Resultado Primário" = 5793),
  first.date  = "2020-01-01",
  last.date   = Sys.Date(),
  format.data = "wide"
)

### Dados de expectativas de mercado do Banco Central 

tail(dados_sgs)

dados_focus <- rbcb::get_market_expectations(
  type       = "annual",
  indic      = "IPCA",
  start_date = "2020-01-01"
)

tail(dados_focus)

### Dados do IPEADATA

# Extrair tabela com todas séries e códigos disponíveis
series_ipeadata <- ipeadatar::available_series()

# Filtrar séries com o termo "caged"
dplyr::filter(
  series_ipeadata,
  stringr::str_detect(source, stringr::regex("caged", ignore_case = TRUE))
)

# Dados do ipeadata

dados_ipeadata <- ipeadatar::ipeadata("CAGED12_SALDON12")

tail(dados_ipeadata)

dados_ipeadata <- ipeadatar::ipeadata(
  c(
    "caged"   = "CAGED12_SALDON12",
    "embi_br" = "JPM366_EMBI366"
  )
)

tail(dados_ipeadata)

# Dados do SIDRA

# Código de consulta com filtros na tabela 7060 (Sidra/IBGE)
cod_sidra <- "/t/7060/n1/all/v/63/p/all/c315/7169/d/v63%202"

# Coleta dos dados com o código
dados_sidra <- sidrar::get_sidra(api = cod_sidra)
tail(dplyr::as_tibble(dados_sidra))

# Dados da OCDE

lista_datasets <- OECD::get_datasets()
lista_datasets

OECD::search_dataset("unemployment", data = lista_datasets)

dataset <- "DUR_D"
dataset_str <- OECD::get_data_structure(dataset)
str(dataset_str, max.level = 1)

dados_ocde <- OECD::get_dataset(
  dataset = dataset,
  filter  = list(
    COUNTRY = c("USA", "G7"),
    SEX     = "MEN",
    AGE     = "2024"
  )
)
dados_ocde

