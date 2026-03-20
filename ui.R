library(shiny)

fluidPage(

  # App title and styling
  tags$head(
    tags$style(HTML("
      body { background-color: #f8f9fa; }
      .well { background-color: #e8f4f8; border: 1px solid #bee5eb; }
      .result-box {
        background-color: white;
        border-radius: 8px;
        padding: 20px;
        margin: 10px 0;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      .bmi-number {
        font-size: 48px;
        font-weight: bold;
        text-align: center;
      }
      .category-label {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
      }
      .advice-text {
        font-size: 15px;
        line-height: 1.6;
      }
      h2 { color: #2c3e50; }
      h4 { color: #34495e; }
    "))
  ),

  titlePanel(
    div(
      h2(icon("heartbeat"), "BMI Calculator & Health Advisor"),
      p("Instantly calculate your Body Mass Index and get personalized health guidance.",
        style = "color: #7f8c8d; font-size: 14px;")
    )
  ),

  # ── DOCUMENTATION PANEL ──────────────────────────────────────────────────────
  # (All documentation is on the Shiny site itself — no external links needed)
  fluidRow(
    column(12,
      wellPanel(
        h4(icon("info-circle"), " How to Use This App"),
        tags$ol(
          tags$li("Select your preferred ", strong("unit system"), " (Metric or Imperial) using the radio buttons."),
          tags$li("Adjust the ", strong("Weight"), " slider to your current body weight."),
          tags$li("Adjust the ", strong("Height"), " slider to your height."),
          tags$li("Your ", strong("BMI, health category, and personalised advice"), " update instantly — no button needed!")
        ),
        hr(),
        p(strong("What is BMI?"), " Body Mass Index (BMI) is a widely used screening tool that estimates
          body fatness from a person's weight and height."),
        p(strong("Formula:"), " BMI = weight (kg) / height (m)\u00b2"),
        p(strong("Note:"), " BMI is a useful population-level measure but does not account for muscle mass,
          age, or ethnicity. Always consult a healthcare professional for personalised advice.",
          style = "font-size: 12px; color: #7f8c8d;")
      )
    )
  ),

  # ── MAIN LAYOUT ──────────────────────────────────────────────────────────────
  sidebarLayout(

    # Sidebar: all input widgets
    sidebarPanel(
      width = 4,

      h4(icon("sliders-h"), " Input Your Measurements"),

      # Widget 1 – Radio buttons: unit system selection
      radioButtons(
        inputId  = "units",
        label    = "Unit System:",
        choices  = list("Metric (kg / cm)"    = "metric",
                        "Imperial (lbs / in)" = "imperial"),
        selected = "metric"
      ),

      hr(),

      # Widget 2 – Dynamic slider: weight (rendered by server based on unit choice)
      uiOutput("weight_ui"),

      # Widget 3 – Dynamic slider: height (rendered by server based on unit choice)
      uiOutput("height_ui"),

      hr(),

      # Widget 4 – Checkbox: show/hide reference table
      checkboxInput(
        inputId = "show_table",
        label   = "Show BMI Reference Table",
        value   = TRUE
      ),

      hr(),
      div(
        h5(icon("book"), " About"),
        p("BMI categories follow ",
          a("WHO guidelines", href = "#",
            onclick = "return false;",
            title   = "World Health Organization BMI classification"),
          ":"),
        tags$ul(
          tags$li(span("< 18.5",  style = "color: #2980b9; font-weight: bold;"), " — Underweight"),
          tags$li(span("18.5 – 24.9", style = "color: #27ae60; font-weight: bold;"), " — Normal weight"),
          tags$li(span("25.0 – 29.9", style = "color: #e67e22; font-weight: bold;"), " — Overweight"),
          tags$li(span("\u2265 30.0", style = "color: #c0392b; font-weight: bold;"), " — Obese")
        ),
        style = "font-size: 13px;"
      )
    ),

    # Main panel: reactive outputs
    mainPanel(
      width = 8,

      h3("Your Results"),

      fluidRow(
        # BMI numeric value
        column(4,
          div(class = "result-box",
            h4("Your BMI", style = "text-align: center; color: #7f8c8d;"),
            textOutput("bmi_value") |>
              tagAppendAttributes(class = "bmi-number")
          )
        ),
        # BMI category
        column(4,
          div(class = "result-box",
            h4("Category", style = "text-align: center; color: #7f8c8d;"),
            uiOutput("bmi_category")
          )
        ),
        # Healthy weight range
        column(4,
          div(class = "result-box",
            h4("Healthy Range", style = "text-align: center; color: #7f8c8d;"),
            uiOutput("healthy_range")
          )
        )
      ),

      # Health advice
      fluidRow(
        column(12,
          div(class = "result-box",
            h4(icon("stethoscope"), " Personalised Health Advice"),
            uiOutput("bmi_advice")
          )
        )
      ),

      # BMI progress bar visual
      fluidRow(
        column(12,
          div(class = "result-box",
            h4(icon("chart-bar"), " BMI Scale"),
            uiOutput("bmi_gauge")
          )
        )
      ),

      # Reference table (conditionally shown)
      conditionalPanel(
        condition = "input.show_table == true",
        fluidRow(
          column(12,
            div(class = "result-box",
              h4(icon("table"), " BMI Reference Table"),
              tableOutput("bmi_table")
            )
          )
        )
      )
    )
  )
)
