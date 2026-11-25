# CareLoop Clinics — No-Show Guard

## Project Overview

CareLoop Clinics — No-Show Guard is an end-to-end Data Analytics and Machine Learning project designed to help clinics understand and reduce patient appointment no-shows.

The project analyzes appointment data, identifies patterns associated with missed appointments, builds a machine learning model to predict no-show risk, and uses Generative AI to classify patient follow-up notes.

## Business Problem

Patient no-shows cause lost revenue, wasted appointment slots, and inefficient clinic operations.

This project aims to help clinics:
- Understand why patients miss appointments.
- Identify appointment patterns associated with no-shows.
- Predict patients who may be at higher risk of missing appointments.
- Analyze patient feedback and recommend follow-up actions.

## Project Workflow

### 1. Data Cleaning and Preparation
- Loaded raw appointment, clinic, and follow-up note datasets.
- Removed duplicate records.
- Handled missing values.
- Identified and handled invalid values and outliers.
- Created features such as `lead_days` and `no_show`.
- Enriched clinic data with weather information.

**Final cleaned dataset:** 990 appointments.

### 2. SQL Analysis
Used MySQL to analyze appointment and clinic data.

Key analyses:
- Clinic-wise no-show rates.
- Booking lead-time analysis.
- Monthly no-show trends.
- Clinic ranking within cities.
- Duplicate appointment ID validation.

**Key finding:** Appointments booked 31 or more days in advance had a 60.5% no-show rate, compared with 16.2% for appointments booked 1–7 days in advance.

### 3. Machine Learning — No-Show Prediction

Built and compared multiple classification models:
- Logistic Regression
- Decision Tree
- Random Forest
- Tuned Random Forest

**Selected model:** Logistic Regression.

Test performance at a 0.35 prediction threshold:

| Metric | Result |
|---|---:|
| Accuracy | 78.79% |
| Precision | 57.14% |
| Recall | 57.14% |
| F1 Score | 57.14% |
| ROC-AUC | 0.789 |

The model detected 28 of 49 actual no-shows in the test dataset.

### 4. Generative AI — Follow-up Note Analysis

Used the Gemini API with structured output validation using Pydantic.

Classified patient notes into:
- Forgot or no reminder
- Distance or transport
- Cost or fee
- Illness or emergency
- Work or schedule
- Other

Results from the 10-note sample:
- 5 successfully classified
- 4 API/processing errors
- 1 blank note skipped

The sample is small and illustrative, not representative of all clinic patients.

## Technology Stack

- Python
- Pandas
- NumPy
- Matplotlib / Seaborn
- Scikit-learn
- MySQL
- Google Colab
- Gemini API
- Pydantic
- GitHub

## Repository Structure

```text
CareLoop-Clinics-No-Show-Guard/
│
├── data/
│   ├── appointments.csv
│   ├── clinics.csv
│   └── followup_notes.csv
│
├── 01_ingest_clean.ipynb
├── 02_queries.sql
├── 03_model.ipynb
├── 04_genai.ipynb
│
├── appointments_clean.csv
├── clinics_enriched.csv
├── rejected_rows.json
├── load_data.sql
├── test_risk_scores.csv
├── notes_analysed.csv
│
└── README.md
```

## Business Recommendations

1. Send reminders to patients well before appointments.
2. Monitor appointments booked far in advance because they show higher no-show rates in this dataset.
3. Use model risk scores to prioritize follow-up calls.
4. Investigate transport, cost, and scheduling barriers.
5. Track no-show rates regularly to evaluate improvements.

## Limitations

- The dataset is limited to 990 cleaned appointments.
- The model's performance is based on a single train-test split.
- The prediction threshold involves a trade-off between missed no-shows and false alerts.
- GenAI analysis uses only 10 follow-up notes, so its results should not be generalized.
- Associations in the dataset do not necessarily establish causation.

## Disclaimer

This is an educational portfolio project using a sample dataset. Predictions should support, not replace, clinic staff decisions.

---

**Created as a Data Analytics and Machine Learning portfolio project.**
