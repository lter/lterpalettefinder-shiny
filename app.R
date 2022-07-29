## ------------------------------------ ##
     # `lterpalettefinder` Shiny App
## ------------------------------------ ##

# Load libraries
# devtools::install_github("lter/lterpalettefinder", force = TRUE)
library(htmltools); library(lterpalettefinder)
library(sass); library(shiny); library(shinyWidgets); library(tidyverse)

# User Interface -------------------------
ui <- shiny::fluidPage(
  
  # UI - Aesthetic Customization ---------
  # Add browser tab title
  title = "lterpalettefinder",
  
  # Develop custom theme
  ui <- fluidPage(
    theme = bslib::bs_theme(
      bg = "#f0f0f0", # Background
      fg = "#000000", # Font color ('foreground')
      primary = "#2b8cbe" # Hyperlink color ('1° accent color')
      ) ),
  
  # UI - Header Text ---------------------
  
  # Top level title
  shiny::headerPanel(list(title = htmltools::h1("Welcome to ", htmltools::code("lterpalettefinder")),
                          img(src = "lterpalettefinder_hex.png",
                              height = 200, align = "right"))),
  
  # Subheading
  htmltools::h2("Overview"),
  
  # Explanation of app
  htmltools::h4(htmltools::code("lterpalettefinder"), " ",
                htmltools::a(href = "https://github.com/lter/lterpalettefinder#readme", "(code linked here)", target = "_blank"),
  " is a package developed for the program R. It allows users to extract colors from a user-supplied photo to then use in visualization or figure construction.",
  htmltools::strong("This website is meant to allow people to use the functions in this package without needing to learn or use R.")),
  
  # Line break
  htmltools::hr(),
  
  # sidebarLayout begins
  shiny::sidebarLayout(
    
    # UI - Sidebar -------------------------
    shiny::sidebarPanel(

      # UI - Step 1 ------------------------
      htmltools::h2("1) Attach a Picture"),
      
      ## Actual fileInput
      shiny::fileInput(inputId = "photo_file",
                       label = "PNG, JPEG, and TIFF photos accepted",
                       accept = c(".png", ".jpeg", ".jpg", ".tiff")),
      
      # UI - Step 2 -----------------------
      htmltools::h2("2) Extract the Colors"),
      
      # Add a note on the time it takes to complete
      "Note that this step may take a few seconds depending on file size.",
      shiny::br(),
      
      # Message
      htmltools::h4("Completed with the function", htmltools::code("palette_extract")),
      shiny::br(),
      
      ## Button
      shiny::actionButton(inputId = "extract_button",
                          label = "Extract",
                          icon = shiny::icon("eye-dropper")),
      
      # Message
      shiny::textOutput(outputId = "extract_message")
      
    ), # End `sidebarPanel(...`
    
    # UI - Main panel ----------------------
    shiny::mainPanel(
      
      # ggplot2 demo
      htmltools::h3(htmltools::strong("ggplot2 Demo")),
      htmltools::h4("Generated with the function",
                      htmltools::code("palette_ggdemo")),
      shiny::br(),
      
      shiny::plotOutput(outputId = "extract_gg",
                        width = "100%",
                        height = "300px"),
      
      # Base R plot demo
      htmltools::h3(htmltools::strong("Base R Demo")),
      htmltools::h4("Generated with the function",
                      htmltools::code("palette_demo")),
      shiny::br(),
      
      shiny::plotOutput(outputId = "extract_simp",
                        width = "50%",
                        height = "300px")
    ), # End `mainPanel(...`
    
    # Add some arguments for the `sidebarLayout` call
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
  output$extract_message <- shiny::renderText({"Success!"})
  
  # Render both types of demo graph
  ## ggplot2 demo
  output$extract_gg <- shiny::renderPlot(
    lterpalettefinder::palette_ggdemo(palette = your_colors) )
  
  ## Base R graph Demo
  output$extract_simp <- shiny::renderPlot(
    lterpalettefinder::palette_demo(palette = your_colors, export = FALSE) )
  
      } # Close `else{...`
  }) # End extract button's `observeEvent(..., {...`
  
} # End `server ... {...`

# App Assembly ---------------------------
shinyApp(ui = ui, server = server)

# End ----
