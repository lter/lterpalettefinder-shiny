## ------------------------------------ ##
     # `lterpalettefinder` Shiny App
## ------------------------------------ ##

# Load libraries
library(shiny)
library(shinyWidgets)
library(htmltools)
library(lterpalettefinder)
library(tidyverse)

# User Interface -------------------------
ui <- shiny::fluidPage(
  
  # UI - Aesthetic Customization ---------
  
  # Set background color
  shinyWidgets::setBackgroundColor(color = 'ghostwhite',
                                   gradient = "linear",
                                   direction = "bottom"),
  
  # UI - Header Text ---------------------
  
  # Top level title
  shiny::titlePanel("Welcome to `lterpalettefinder`!"),
  
  # Subheading
  htmltools::h4("Overview"),
  
  # Text explanation of app
  "`lterpalettefinder` is a package developed for the program R. It allows users to extract colors from a user-supplied photo to then use in visualization or figure construction.",
  htmltools::strong("This website is meant to allow people to use the functions in this package without needing to learn or use R"),
  
  # Line break
  htmltools::hr(),
  
  # User instructions
  htmltools::h4("To use `lterpalettefinder`: follow the numbered steps beginning in the sidebar below and to the left of this sentence."),
  
  # Line break
  htmltools::hr(),
  
  # sidebarLayout begins
  shiny::sidebarLayout(
    
    # UI - Sidebar -------------------------
    shiny::sidebarPanel(

      # UI - Sidebar - Step 1 --------------
      htmltools::h3("1) Attach a Picture"),
      
      ## Actual fileInput
      shiny::fileInput(inputId = "photo_file",
                       label = "PNG, JPEG, TIFF, and HEIC-format photos accepted",
                       accept = c(".png", ".jpeg", ".jpg",
                                  ".tiff", ".heic")),
      
      # UI - Sidebar - Step 2 --------------
      htmltools::h3("2) Extract Colors from Picture"),
      
      ## Button
      shiny::actionButton(inputId = "extract_button",
                          label = "Get Palette",
                          icon = shiny::icon("brush")),
      # Message
      shiny::verbatimTextOutput(outputId = "extract_message"),
    ), # End `sidebarPanel(...`

    # UI - Main panel ----------------------
    shiny::mainPanel(
      
      verbatimTextOutput(outputId = "test_1")
      
    ), # End `mainPanel(...`
    
    # Add some arguments for the `sidebarLayout()` call
    position = 'left', fluid = TRUE) # close `sidebarLayout(...`

) # End `fluidPage(...`

# Server Function ------------------------
server <- function(input, output, session){
  
  # UI - Sidebar - Step 2 ----------------
  # Respond to button press
  shiny::observeEvent(input$extract_button, {
    
    # Error out if no photo is attached
    if(base::is.null(input$photo_file)){
      output$extract_message <- shiny::renderPrint({"No picture attached." })
      
      # Otherwise: ...
      } else {
        # Identify path
        pic_path <- input$photo_file$datapath
        
        # Extract palette
        your_colors <- lterpalettefinder::palette_extract(image = pic_path, sort = TRUE, progress_bar = FALSE)
        
  # Print success message
  output$extract_message <- shiny::renderPrint({"Success!"}) }
    
    }) # End photo button's `observeEvent(..., {...`
  
  
  # Test Outputs ---------------------------
  
  
  
} # End `server ... {...`




# App Assembly ---------------------------
shinyApp(ui = ui, server = server)

# End ----
