# Human Activity Recognition Project

This repository contains the analysis and model for the Human Activity Recognition project completed as part of the **Practical Machine Learning** course on Coursera.

## 📌 Project Objective

Using data collected from wearable sensors placed on six individuals, this project aims to predict the **manner in which the subjects performed barbell lifts** — represented by the `classe` variable in the training data.

The goal was to:
- Clean and preprocess the sensor data
- Train a robust machine learning model
- Predict 20 unknown test cases
- Document the methodology clearly in a report

## 📂 Repository Contents

| File / Folder        | Description |
|----------------------|-------------|
| `analysis.Rmd`       | R Markdown report with code and explanations |
| `analysis.html`      | Rendered HTML version of the report |
| `pml-training.csv`   | Training data (160+ features, labeled) |
| `pml-testing.csv`    | Testing data (20 observations to predict) |
| `predictions/`       | Contains 20 individual `.txt` files with predictions (problem_id_1.txt to problem_id_20.txt) |
| `r program.R`        | Optional script version of the R Markdown |
| `README.md`          | This file |

---

## 📊 Data Source

- [Training Data](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv)
- [Testing Data](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv)
- [HAR Dataset Background](http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har)

The data come from accelerometers mounted on the belt, forearm, arm, and dumbbell of 6 participants. They performed barbell lifts correctly and incorrectly in 5 different ways.

---

## 🧠 Model Summary

- Algorithm: **Random Forest**
- Cross-validation: **3-fold CV**
- Validation Accuracy: **~99.4%**
- Expected Out-of-Sample Error: **~0.6%**

The model was trained using `caret` and `randomForest` packages in R.

---

## 📦 Getting Started (Coursera Sandbox Users)

If you're working in the **Coursera Lab Sandbox**:

1. Open the `analysis.Rmd` file.
2. Click "Knit" to generate the HTML report.
3. Use the `Files` tab to download your outputs.
4. Export individual predictions from the `predictions/` folder.
5. Zip the whole folder or upload files manually to GitHub.

See [Coursera's Learner Help Center](https://learner.coursera.help/hc/articles/360062301971) for sandbox-specific tips.

---

## 🚀 Usage

To reproduce this project locally:

```r
# Install packages (if not already installed)
install.packages(c("caret", "randomForest", "dplyr", "ggplot2"))

# Open R or RStudio and knit `analysis.Rmd` to produce `analysis.html`
rmarkdown::render("analysis.Rmd")
