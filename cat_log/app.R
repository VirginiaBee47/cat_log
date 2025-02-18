library(shiny)
library(tidyverse)

# Use cat data
proj_url = "https://raw.githubusercontent.com/VirginiaBee47/cat_log/refs/heads/main/cat_health.csv"
download.file(url = proj_url, destfile = "cat_health.csv")

kitty_data <- read_csv("cat_health.csv", skip = 2, 
                       col_names = c("date", 
                                     "cleopatra_weight", 
                                     "amumu_weight")) %>%
  mutate(date = mdy(date)) %>% 
  pivot_longer(cols = c("cleopatra_weight", "amumu_weight"), 
               names_to = "cat") %>%
  separate_wider_delim(cat, delim = '_', names = c("cat", "attribute"))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Cat Health Tracker"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput("y_min", "Y minimum", 
                   value = min(kitty_data$value),
                   min = min(kitty_data$value), max = max(kitty_data$value),
                   step = 0.01),
      numericInput("y_max", "Y maximum", 
                   value = max(kitty_data$value),
                   min = min(kitty_data$value), max = max(kitty_data$value),
                   step = 0.01)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("weight_plot")
    )
  )
)

# Define server logic required to draw the dashboard
server <- function(input, output) {
  
  output$weight_plot <- renderPlot({
    ggplot(kitty_data, aes(x = date, y = value, color = cat)) +
      geom_line() + 
      coord_cartesian(ylim = c(input$y_min, input$y_max)) +
      theme_classic()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)