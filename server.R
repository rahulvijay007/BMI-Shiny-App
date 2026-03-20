library(shiny)

# ── BMI reference table (static data) ────────────────────────────────────────
bmi_reference <- data.frame(
  Category      = c("Underweight", "Normal weight", "Overweight",
                    "Obese Class I", "Obese Class II", "Obese Class III"),
  `BMI Range`   = c("< 18.5", "18.5 – 24.9", "25.0 – 29.9",
                    "30.0 – 34.9", "35.0 – 39.9", "\u2265 40.0"),
  `Health Risk` = c("Increased", "Minimal", "Increased",
                    "High", "Very High", "Extremely High"),
  check.names   = FALSE
)

# ── Server function ───────────────────────────────────────────────────────────
function(input, output, session) {

  # ── Dynamic UI: weight slider (changes labels/ranges based on unit choice) ──
  output$weight_ui <- renderUI({
    if (input$units == "metric") {
      sliderInput("weight", "Weight (kg):",
                  min = 30, max = 200, value = 70, step = 0.5)
    } else {
      sliderInput("weight", "Weight (lbs):",
                  min = 66, max = 440, value = 154, step = 1)
    }
  })

  # ── Dynamic UI: height slider ─────────────────────────────────────────────
  output$height_ui <- renderUI({
    if (input$units == "metric") {
      sliderInput("height", "Height (cm):",
                  min = 100, max = 250, value = 170, step = 1)
    } else {
      sliderInput("height", "Height (inches):",
                  min = 39, max = 98, value = 67, step = 1)
    }
  })

  # ── Reactive: convert inputs to metric and compute BMI ────────────────────
  bmi <- reactive({
    req(input$weight, input$height)

    if (input$units == "metric") {
      weight_kg <- input$weight
      height_m  <- input$height / 100
    } else {
      weight_kg <- input$weight * 0.453592
      height_m  <- input$height * 0.0254
    }

    round(weight_kg / height_m^2, 1)
  })

  # ── Reactive: WHO category ────────────────────────────────────────────────
  bmi_category <- reactive({
    b <- bmi()
    if      (b < 18.5) "Underweight"
    else if (b < 25.0) "Normal weight"
    else if (b < 30.0) "Overweight"
    else if (b < 35.0) "Obese (Class I)"
    else if (b < 40.0) "Obese (Class II)"
    else               "Obese (Class III)"
  })

  # ── Reactive: colour for the category label ───────────────────────────────
  bmi_color <- reactive({
    cat <- bmi_category()
    if      (grepl("Underweight", cat))  "#2980b9"   # blue
    else if (grepl("Normal",      cat))  "#27ae60"   # green
    else if (grepl("Overweight",  cat))  "#e67e22"   # orange
    else                                 "#c0392b"   # red (any Obese class)
  })

  # ── Reactive: personalised advice text ───────────────────────────────────
  bmi_advice_text <- reactive({
    cat <- bmi_category()
    if (grepl("Underweight", cat)) {
      list(
        icon    = "arrow-up",
        heading = "Your BMI suggests you may be underweight.",
        body    = "Being underweight can be associated with nutrient deficiencies,
                   weakened immunity, and reduced bone density. Consider consulting
                   a registered dietitian or your GP. Focus on balanced, nutrient-dense
                   meals and, if appropriate, strength-based exercise to build muscle mass."
      )
    } else if (grepl("Normal", cat)) {
      list(
        icon    = "check-circle",
        heading = "Great news — your BMI is in the healthy range!",
        body    = "Maintaining a healthy weight is associated with lower risk of
                   cardiovascular disease, type 2 diabetes, and many other conditions.
                   Keep up your current lifestyle: regular physical activity (aim for
                   150 min/week of moderate exercise), a balanced diet rich in vegetables,
                   whole grains, and lean proteins, and regular health check-ups."
      )
    } else if (grepl("Overweight", cat)) {
      list(
        icon    = "exclamation-triangle",
        heading = "Your BMI indicates you are in the overweight range.",
        body    = "Carrying excess weight increases risk of high blood pressure, type 2
                   diabetes, and joint problems. Even modest weight loss (5–10% of body
                   weight) can significantly improve health markers. Consider increasing
                   physical activity, reducing portion sizes, and limiting processed foods.
                   A healthcare professional can provide personalised support."
      )
    } else {
      list(
        icon    = "exclamation-circle",
        heading = paste0("Your BMI falls in the ", bmi_category(), " category."),
        body    = "Obesity is associated with increased risk of serious health conditions
                   including heart disease, stroke, type 2 diabetes, and certain cancers.
                   We strongly recommend speaking with a healthcare provider to develop a
                   safe, personalised plan. Small, sustainable changes to diet and activity
                   levels — supported by professional guidance — can make a meaningful difference."
      )
    }
  })

  # ── Reactive: healthy weight range for user's height ─────────────────────
  healthy_range_text <- reactive({
    req(input$height)

    if (input$units == "metric") {
      h_m     <- input$height / 100
      low_kg  <- round(18.5 * h_m^2, 1)
      high_kg <- round(24.9 * h_m^2, 1)
      paste0(low_kg, " – ", high_kg, " kg")
    } else {
      h_m     <- input$height * 0.0254
      low_kg  <- 18.5 * h_m^2
      high_kg <- 24.9 * h_m^2
      low_lb  <- round(low_kg  / 0.453592, 1)
      high_lb <- round(high_kg / 0.453592, 1)
      paste0(low_lb, " – ", high_lb, " lbs")
    }
  })

  # ── Output: BMI numeric value ─────────────────────────────────────────────
  output$bmi_value <- renderText({
    bmi()
  })

  # ── Output: coloured category label ──────────────────────────────────────
  output$bmi_category <- renderUI({
    tags$div(
      class = "category-label",
      style = paste0("color: ", bmi_color(), ";"),
      bmi_category()
    )
  })

  # ── Output: healthy weight range ─────────────────────────────────────────
  output$healthy_range <- renderUI({
    tags$div(
      class = "category-label",
      style = "color: #27ae60; font-size: 18px;",
      healthy_range_text()
    )
  })

  # ── Output: advice block ──────────────────────────────────────────────────
  output$bmi_advice <- renderUI({
    adv <- bmi_advice_text()
    div(
      class = "advice-text",
      tags$p(
        strong(adv$heading),
        style = paste0("color: ", bmi_color(), ";")
      ),
      tags$p(adv$body)
    )
  })

  # ── Output: visual BMI gauge (HTML progress bar) ─────────────────────────
  output$bmi_gauge <- renderUI({
    b          <- bmi()
    # Clamp position to 0–100% across a display range of 10–45
    pct        <- min(100, max(0, round((b - 10) / (45 - 10) * 100)))
    bar_color  <- bmi_color()

    tagList(
      # Colour-band background bar
      div(
        style = "position: relative; height: 30px; border-radius: 15px;
                 background: linear-gradient(to right,
                   #2980b9 0%, #2980b9 22%,
                   #27ae60 22%, #27ae60 42%,
                   #e67e22 42%, #e67e22 57%,
                   #c0392b 57%, #c0392b 100%);",
        # Marker for the user's BMI
        div(
          style = paste0(
            "position: absolute; top: -5px; left: ", pct, "%;",
            "width: 4px; height: 40px; background-color: #2c3e50;",
            "border-radius: 2px; transform: translateX(-50%);"
          )
        )
      ),
      # Scale labels
      div(
        style = "display: flex; justify-content: space-between;
                 font-size: 12px; color: #7f8c8d; margin-top: 4px;",
        span("10"),
        span("18.5"),
        span("25"),
        span("30"),
        span("40+")
      ),
      div(
        style = "display: flex; justify-content: space-between;
                 font-size: 11px; color: #7f8c8d;",
        span(""),
        span("Under-", br(), "weight", style = "text-align:center; color: #2980b9;"),
        span("Normal", style = "text-align:center; color: #27ae60;"),
        span("Over-", br(), "weight", style = "text-align:center; color: #e67e22;"),
        span("Obese", style = "text-align:center; color: #c0392b;"),
        span("")
      ),
      tags$p(
        paste0("Your BMI of ", b, " is marked by the black bar above."),
        style = "font-size: 13px; color: #7f8c8d; margin-top: 8px;"
      )
    )
  })

  # ── Output: reference table ───────────────────────────────────────────────
  output$bmi_table <- renderTable({
    bmi_reference
  }, striped = TRUE, hover = TRUE, bordered = TRUE, align = "c")
}
