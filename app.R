library(shiny)
library(tidyverse)
library(bslib)

# Use cat data
proj_url = "https://raw.githubusercontent.com/VirginiaBee47/cat_log/refs/heads/main/cat_health.csv"
download.file(url = proj_url, destfile = "cat_health.csv")

kitty_data <- read_csv("cat_health.csv", skip = 1, 
                       col_names = c("date", 
                                     "cat", 
                                     "attribute",
                                     "value")) %>%
  mutate(date = mdy(date))

# Define a custom theme using a Bootswatch theme (e.g., "cerulean")
my_theme <- bs_theme(bootswatch = "cerulean")

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Weight Over Time"),
    plotOutput("weight_plot")
  ),
  card(
    full_screen = TRUE,
    card_header("Injury Incidents"),
    plotOutput("injury_plot")
  )
)

ui <- page_navbar(
  title = "Cat Health Tracker",
  nav_spacer(),
  nav_panel("Weight Over Time", cards[[1]]),
  nav_panel("Injury Incidents", cards[[2]]),
  nav_item(tags$a("Data Source.", 
                  href = "https://raw.githubusercontent.com/VirginiaBee47/cat_log/refs/heads/main/cat_health.csv"))
)

# Define server logic required to draw the dashboard
server <- function(input, output) {
  
  output$weight_plot <- renderPlot({
    ggplot(kitty_data %>% 
             filter(attribute == 'weight'),
           aes(x = date, y = value, color = cat)) +
      geom_line() + 
      coord_cartesian(ylim = c(input$y_min, input$y_max)) +
      theme_classic()
  })
  
  output$injury_plot <- renderPlot({
    ggplot(kitty_data %>% 
             filter(attribute == 'injury'), 
           aes(x = date, y = value, color = cat)) +
      geom_point(size = 4, shape = 3) + 
      coord_cartesian(ylim = c(0, 2)) +
      theme_classic() +
      theme(axis.text.y = element_blank(),
            axis.title.y = element_blank(),
            axis.line.y = element_blank(),
            axis.ticks.y = element_blank())
  })
}

# Run the application 
shinyApp(ui = ui, server = server)