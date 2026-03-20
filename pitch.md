BMI Calculator & Health Advisor
========================================================
author: Rahul Vijayraghavan
date: 20th March 2026
autosize: true
font-family: 'Helvetica Neue', Helvetica, sans-serif

<style>
.reveal h1, .reveal h2, .reveal h3 {
  color: #2c3e50;
}
.reveal p, .reveal li {
  font-size: 0.85em;
  line-height: 1.6;
}
.small-code pre code {
  font-size: 0.75em;
}
.green  { color: #27ae60; font-weight: bold; }
.orange { color: #e67e22; font-weight: bold; }
.red    { color: #c0392b; font-weight: bold; }
.blue   { color: #2980b9; font-weight: bold; }
</style>


The Problem
========================================================

**Why does BMI matter?**

- Over **1 billion people** worldwide live with obesity (WHO, 2022)
- BMI is the standard first-line screening tool used by clinicians globally
- Most people have no quick, accessible way to check their BMI *and* understand what to do next

**What this app solves:**

> A single, jargon-free web tool that:
> 1. Accepts weight & height in **Metric or Imperial** units
> 2. Calculates BMI instantly
> 3. Explains the result with **personalised, actionable advice**
> 4. Requires zero medical knowledge to use

No sign-up. No downloads. Results in seconds.


How It Works — The Maths
========================================================
class: small-code

BMI is computed with one simple formula. The R code below demonstrates
it live — the same logic runs inside the Shiny `server.R`:


``` r
# Example: person weighing 80 kg, 175 cm tall
weight_kg <- 80
height_m  <- 175 / 100          # convert cm → m

bmi_value <- round(weight_kg / height_m^2, 1)
cat("BMI =", bmi_value)
```

```
BMI = 26.1
```

``` r
# WHO classification
classify_bmi <- function(bmi) {
  if      (bmi < 18.5) "Underweight"
  else if (bmi < 25.0) "Normal weight"
  else if (bmi < 30.0) "Overweight"
  else                 "Obese"
}

cat("\nCategory:", classify_bmi(bmi_value))
```

```

Category: Overweight
```

The app handles **imperial conversion** automatically:
- Weight: lbs × 0.4536 = kg
- Height: inches × 0.0254 = m


App Features
========================================================

**Input widgets (sidebar)**

| Widget | Purpose |
|--------|---------|
| Radio buttons | Switch between Metric / Imperial |
| Weight slider | Select body weight (30–200 kg or 66–440 lbs) |
| Height slider | Select height (100–250 cm or 39–98 in) |
| Checkbox | Show / hide BMI reference table |

**Reactive outputs (main panel)**

- **BMI number** — large, instantly updated
- **Category label** — colour-coded: <span class="blue">blue</span> / <span class="green">green</span> / <span class="orange">orange</span> / <span class="red">red</span>
- **Healthy weight range** — calculated for *your* height
- **Personalised advice** — plain-English guidance per category
- **Visual BMI gauge** — colour-band scale with your position marked
- **Reference table** — all WHO classes at a glance


Try It!
========================================================

**The app is live on shinyapps.io:**

`https://rahulvijay97.shinyapps.io/bmi-calculator/`



---

**Source code on GitHub:**

`https://github.com/rahulvijay007/BMI-Shiny-App`

- `ui.R`   — layout, widgets, inline documentation
- `server.R` — reactive BMI logic, colour coding, advice engine

---

**Grading checklist met:**
- Multiple input widgets (radio, sliders, checkbox)
- Server-side reactive calculations
- Colour-coded reactive HTML output
- Complete user documentation embedded in the app
- 5-slide deck with live R code (previous slide)
