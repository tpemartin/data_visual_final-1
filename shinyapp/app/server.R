# makecondition -----------

library(osmdata)
library(dplyr)
library(plotly)
library(stringr)
library(sf)
library(tidyverse)

#saveRDS(df_ntp,file = "osmData_NewTaipei.rds")
readRDS("support/osmData_NewTaipei.rds")-> df_ntp

case = colorspace::sequential_hcl(n=3, h =0 , c = c(200, 0), l = 30, rev = TRUE, power = 1.75)
grDevices::colorRamp(case) -> case_colorGenerator
#scales::show_col(case)


# server --------

server <- function(input, output){
output$distPlot <- plotly::renderPlotly({
    if (input$Region == "none") {
        plotly::plot_ly() %>% add_sf(data = df_ntp$osm_multipolygons, 
            type = "scatter", split = ~name.en, showlegend = F, 
            hoverinfo = "text", text = ~name_and_case_number, 
            hoveron = "fills", stroke = I("gray"), color = ~Range, 
            colors = grDevices::colorRamp(case), hoverlabel = list(bgcolor = "orange", 
                font = list(color = "black", size = 20)))
    }
    else {
        plotly::plot_ly() %>% add_sf(data = df_ntp$osm_multipolygons %>% 
            filter(., str_detect(name.en, input$Region)), type = "scatter", 
            split = ~name.en, showlegend = F, hoverinfo = "text", 
            text = ~name_and_case_number, hoveron = "fills", 
            stroke = I("gray"), hoverlabel = list(bgcolor = "orange", 
                font = list(color = "black", size = 20)))
    }
})
}
