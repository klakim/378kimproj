install.packages("vetiver")
install.packages("pins")
install.packages("plumber")


library(vetiver)
library(pins)

# Set the board directory
b <- pins::board_folder("finalproj")
# Load the model from the pin
v <- vetiver::vetiver_pin_read(b, "penguin_model")


library(plumber)

# Define your API
pr <- plumber$new()
pr$handle("POST", "/predict", function(req) {
  # Assuming 'req' contains the input data
  # and you have a vetiver model 'v'
  input_data <- jsonlite::fromJSON(as.character(req$postBody))
  prediction <- vetiver::vetiver_predict(v, input_data)
  return(list(prediction = prediction))
})

# Run the API
pr$run(port = 8080)
