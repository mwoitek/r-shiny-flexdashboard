# Import the necessary libraries:
library(shiny)
library(tidyverse)

# Import the data:
dat <- readr::read_csv("cces_sample_coursera.csv") %>%
    dplyr::select(ideo5, pid7) %>%
    tidyr::drop_na()

# Define the user interface:
ui <- shiny::fluidPage(

    shiny::sidebarLayout(

        # Sidebar with a slider input for the Five Point Ideology:
        shiny::sidebarPanel(
            shiny::sliderInput(
                inputId = "ideo5",
                label = paste(
                    "Select Five Point Ideology",
                    "(1=Very liberal, 5=Very conservative)",
                    collapse = " "
                ),
                min = 1,
                max = 5,
                value = 3
            )
        ),

        # Bar plot on the main panel:
        shiny::mainPanel(shiny::plotOutput("bar_plot"))

    )

)

# Define the server logic required to create the bar plot:
server <- function(input, output) {

    output$bar_plot <- shiny::renderPlot({
        ggplot2::ggplot(
            data = dplyr::filter(dat, ideo5 == input$ideo5),
            mapping = ggplot2::aes(x = pid7)
        ) +
            ggplot2::geom_bar(fill = "darkgray") +
            ggplot2::labs(
                x = "7 Point Party ID, 1=Very D, 7=Very R",
                y = "Count"
            ) +
            ggplot2::scale_x_continuous(
                breaks = seq(from = 1, to = 7),
                limits = c(0, 8)
            ) +
            ggplot2::scale_y_continuous(
                breaks = seq(from = 0, to = 125, by = 25),
                limits = c(0, 126)
            ) +
            ggplot2::theme(
                panel.grid.minor.x = ggplot2::element_blank()
            )
    })

}

# Combine user interface and server to create a Shiny App:
shinyApp(ui = ui, server = server)
