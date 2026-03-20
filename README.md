# BMI Calculator & Health Advisor Shiny Application

## Project Overview
The BMI Calculator & Health Advisor Shiny application provides an interactive platform for users to calculate their Body Mass Index (BMI) and receive personalized health advice based on their BMI results. This application is designed to promote awareness of health and encourage individuals to maintain a healthy lifestyle.

## Features
- **Interactive Features**: Users can input their height and weight, and instantly see their BMI and health status.
- **Unit System Support**: Supports both metric (kg, cm) and imperial (lbs, ft) units for user convenience.
- **Personalized Health Advice**: Based on BMI results, users receive tailored recommendations related to their health and nutrition.
- **BMI Scale Visualization**: Graphical representation of the BMI scale to help users understand their position in relation to underweight, normal weight, overweight, and obesity categories.
- **Reference Tables**: Utilizes reference tables based on WHO guidelines to provide accurate health insights.

## Installation Instructions
To install the BMI Calculator & Health Advisor Shiny application, follow these steps:
1. Clone the repository:  
   `git clone https://github.com/rahulvijay007/BMI-Shiny-App.git`
2. Set up R and RStudio on your machine if not already installed.
3. Open the project in RStudio.
4. Install the required packages by running:  
   `install.packages(c('shiny', 'ggplot2', 'dplyr'))`
5. Run the application by executing:  
   `shiny::runApp()`

## Usage Guide
After installation, follow these steps to use the application:
1. Open the application in RStudio (or through a web browser if deployed).
2. Enter your height and weight in the appropriate fields.
3. Click the "Calculate" button to see your BMI and health status.
4. Review the personalized health advice and BMI scale visualization provided.

## Technical Details
- **Technologies Used**: R, Shiny framework
- **Packages**: shiny, ggplot2, dplyr, etc.
- **Architecture**: The application utilizes reactive programming for dynamic updates and visualizations based on user input.

## Contribution Guidelines
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new feature branch:  
   `git checkout -b feature/AmazingFeature`
3. Commit your changes:  
   `git commit -m 'Add some AmazingFeature'`
4. Push to the branch:  
   `git push origin feature/AmazingFeature`
5. Open a Pull Request to propose your changes.

Thank you for collaborating and improving the BMI Calculator & Health Advisor Shiny application!