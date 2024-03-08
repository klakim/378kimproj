library(shiny) #App interface WORKS 3/7
library(httr2) # Need
library(jsonlite)  #List to JSON


# Define the API URL
api_url <- "http://127.0.0.1:8080/predict"  # Same as Shiny URL

# Define the UI layout
ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bill_length", "Bill Length (mm)", min = 30, max = 60, value = 45, step = 0.1),
      selectInput("sex", "Sex", choices = c("Male", "Female")),
      selectInput("species", "Species", choices = c("Adelie", "Chinstrap", "Gentoo")),
      actionButton("predict", "Predict")
    ),
    mainPanel(
      h2("Penguin Parameters"),
      verbatimTextOutput("vals"),
      h2("Predicted Penguin Mass (g)"),
      textOutput("pred")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Configure the log object
  log <- log4r::logger()
  
  # Log app start
  log4r::info(log, "App Started")
  
  vals <- reactive({
    # Directly set the reactive values to be in the same format as FastAPI 
    list(
      bill_length_mm = as.numeric(input$bill_length),  # Make sure numeric
      species_Chinstrap = input$species == "Chinstrap",  # Boolean
      species_Gentoo = input$species == "Gentoo",  # Boolean
      sex_male = input$sex == "Male"  # Boolean
    )
  })
  
  observeEvent(input$predict, {
    req_body <- vals()  # Take the current state of reactive values directly
    
    # Logging from Chapter 4
    cat("Sending to backend:", jsonlite::toJSON(req_body, auto_unbox = TRUE), "\n")
    
    # Send the POST request
    response <- request(api_url) |>
      req_body_json(req_body) |>  # Chat GPT help: Use auto_unboxing to ensure JSON doesn't have arrays
      req_perform() |>
      resp_body_json()
    
    # Prediction to the UI output, chatGPT helped
    output$pred <- renderText({
      if ("prediction" %in% names(response)) {
        paste("Predicted mass:", response$prediction[[1]], "grams")
      } else {
        paste("Error in prediction:", response$detail)
      }
    })
    
    # What was outputted in Chapter 4
    output$vals <- renderPrint({
      req_body
    })
  }, ignoreInit = TRUE)
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
