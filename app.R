## ------------------------------------ ##
     # `lterpalettefinder` Shiny App
## ------------------------------------ ##

# Load libraries
library(shiny)
library(shinyWidgets)
library(htmltools)
# devtools::install_github("lter/lterpalettefinder", force = TRUE)
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

      # UI - Step 1 ------------------------
      htmltools::h3("1) Attach a Picture"),
      
      ## Actual fileInput
      shiny::fileInput(inputId = "photo_file",
                       label = "PNG, JPEG, TIFF photos accepted",
                       accept = c(".png", ".jpeg", ".jpg", ".tiff")),
      
      # UI - Step 2 -----------------------
      htmltools::h3("2) Extract Colors from Picture"),
      
      # Message
      "This is equivalent to the function `palette_extract()`",
      shiny::br(),
      
      ## Button
      shiny::actionButton(inputId = "extract_button",
                          label = "Extract",
                          icon = shiny::icon("eye-dropper")),
      # Message
      shiny::verbatimTextOutput(outputId = "extract_message"),
      
      # Return the vector
      "This function returns a vector of the hexadecimal codes of the 25 colors identified by `palette_extract()`",
      shiny::verbatimTextOutput(outputId = "palette_vector"),
      
      # UI - Step 3 -----------------------
      htmltools::h3("3) Print the Palette"),
      
      ## Button
      shiny::actionButton(inputId = "print_button",
                          label = "Display",
                          icon = shiny::icon("brush")),
      # Message
      shiny::verbatimTextOutput(outputId = "print_message"),
      
    ), # End `sidebarPanel(...`
    
    # UI - Main panel ----------------------
    shiny::mainPanel(
      
      # ggplot2 demo
      shiny::column(width = 6,
                    htmltools::h4(htmltools::strong("ggplot2 Demo")),
                    
                    "Generated with the function `palette_ggdemo()`",
                    
                    shiny::plotOutput(outputId = "extract_gg")
                    ),
      
      # Base R plot demo
      shiny::column(width = 6,
                    htmltools::h4(htmltools::strong("Base R Demo")),
                    
                    "Generated with the function `palette_demo()`",
                    
                    shiny::plotOutput(outputId = "extract_simp")
                    )
    ), # End `mainPanel(...`
    
    # Add some arguments for the `sidebarLayout()` call
    position = 'left', fluid = TRUE) # close `sidebarLayout(...`

) # End `fluidPage(...`

# Server Function ------------------------
server <- function(input, output, session){
  
  # Server - Step 2 ----------------------
  # Respond to extract button press
  shiny::observeEvent(input$extract_button, {
    
    # Error out if no photo is attached
    if(base::is.null(input$photo_file)){
      output$extract_message <- shiny::renderPrint({"No picture attached."})
      
      # Otherwise: ...
      } else {
        # Identify path
        pic_path <- input$photo_file$datapath
        
        # Extract palette
        your_colors <- lterpalettefinder::palette_extract(image = pic_path, sort = TRUE, progress_bar = FALSE)
        
       
  # Print success message
  output$extract_message <- shiny::renderPrint({"Success!"})
  
  # Also print this as an output
  output$palette_vector <- renderPrint({your_colors})
  
      } # Close `else{...`
  }) # End extract button's `observeEvent(..., {...`
  
  # Server - Step 3 ----------------------
  # Respond to print button press
  shiny::observeEvent(input$print_button, {
    # Error out if no photo is attached
    if(base::is.null(input$photo_file)){
      output$print_message <- shiny::renderPrint({"No picture attached."}) } else {
      # Otherwise...
        # Identify path again
        pic_path <- input$photo_file$datapath
        
          # Strip out the colors again
          your_colors <- lterpalettefinder::palette_extract(image = pic_path, sort = TRUE, progress_bar = FALSE)
          
          # Render both types of demo graph
          ## ggplot2 demo
          output$extract_gg <- shiny::renderPlot(
            lterpalettefinder::palette_ggdemo(palette = your_colors) )
          
          ## Base R graph Demo
          output$extract_simp <- shiny::renderPlot(
            lterpalettefinder::palette_demo(palette = your_colors) )
          
          # Return a message
          output$print_message <- renderPrint({"Success!"})
      } # close the `else {...`
    
  }) # Close print button's `observeEvent(..., {...`
  
} # End `server ... {...`

# App Assembly ---------------------------
shinyApp(ui = ui, server = server)

# End ----
