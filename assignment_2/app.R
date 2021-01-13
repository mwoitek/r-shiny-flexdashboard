# Import the necessary libraries:
library(tidyverse)
library(shiny)
library(plotly)
library(DT)

# Import the data:
dat <- readr::read_csv(file = "cces_sample_coursera.csv") %>%
    dplyr::select(pid7, ideo5, newsint, gender, educ, CC18_308a, region) %>%
    tidyr::drop_na()

# Define the user interface:
ui <- shiny::navbarPage(

    title = "My Application",

    shiny::tabPanel(

        title = "Page 1",

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

            # Two tabs on the main panel:
            shiny::mainPanel(
                shiny::tabsetPanel(

                    shiny::tabPanel(
                        title = "Tab1",
                        shiny::plotOutput(outputId = "bar_plot_pid7")
                    ),

                    shiny::tabPanel(
                        title = "Tab2",
                        shiny::plotOutput(outputId = "bar_plot_trump")
                    )

                )
            )

        )

    ),

    shiny::tabPanel(

        title = "Page 2",

        shiny::sidebarLayout(

            # Sidebar with a check box group for selecting genders:
            shiny::sidebarPanel(
                shiny::checkboxGroupInput(
                    inputId = "select_gender",
                    label = "Select Gender",
                    choices = c(1, 2)
                )
            ),

            # Scatter plot on the main panel:
            shiny::mainPanel(plotly::plotlyOutput(outputId = "scatter_plot"))

        )

    ),

    shiny::tabPanel(

        title = "Page 3",

        shiny::sidebarLayout(

            # Sidebar with a `selectizeInput` object for selecting the region:
            shiny::sidebarPanel(
                shiny::selectizeInput(
                    inputId = "select_region",
                    label = "Select Region",
                    choices = seq(from = 1, to = 4),
                    multiple = TRUE
                )
            ),

            # Data table on the main panel:
            shiny::mainPanel(DT::dataTableOutput(outputId = "data_table"))

        )

    )

)

# Define the server:
server <- function(input, output) {

    # Page 1 - Tab1.
    # Define the server logic required to create the bar plot.
    output$bar_plot_pid7 <- shiny::renderPlot({
        ggplot2::ggplot(
            data = dplyr::filter(dat, ideo5 == input$ideo5),
            mapping = ggplot2::aes(x = pid7)) +
            ggplot2::geom_bar(fill = "dimgray") +
            ggplot2::labs(
                x = "7 Point Party ID, 1=Very D, 7=Very R",
                y = "Count") +
            ggplot2::scale_x_continuous(
                breaks = seq(from = 1, to = 7),
                limits = c(0, 8)) +
            ggplot2::scale_y_continuous(
                breaks = seq(from = 0, to = 100, by = 25),
                limits = c(0, 110)) +
            ggplot2::theme(panel.grid.minor.x = ggplot2::element_blank())
    })

    # Page 1 - Tab2.
    # Define the server logic required to create the bar plot.
    output$bar_plot_trump <- shiny::renderPlot({
        ggplot2::ggplot(
            data = dplyr::filter(dat, ideo5 == input$ideo5),
            mapping = ggplot2::aes(x = CC18_308a)) +
            ggplot2::geom_bar(fill = "dimgray") +
            ggplot2::labs(x = "Trump Support", y = "Count") +
            ggplot2::scale_x_continuous(
                breaks = seq(from = 1, to = 4),
                limits = c(0, 5)) +
            ggplot2::theme(panel.grid.minor.x = ggplot2::element_blank())
    })

    # Page 2.
    # Define the server logic required to create the scatter plot.
    output$scatter_plot <- plotly::renderPlotly({
        plotly::ggplotly(
            ggplot2::ggplot(
                data = dplyr::filter(dat, gender %in% input$select_gender),
                mapping = ggplot2::aes(x = educ, y = pid7)) +
                ggplot2::geom_point(position = "jitter") +
                ggplot2::geom_smooth(formula = y ~ x, method = "loess")
        )
    })

    # Page 3.
    # Define the server logic required to create the data table.
    output$data_table <- DT::renderDataTable({
        dplyr::filter(dat, region %in% input$select_region)
    })

}

# Combine user interface and server to create the Shiny App:
shinyApp(ui = ui, server = server)
