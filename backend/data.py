import pandas as pd
import random

diseases = {
    "Flu": {"symptoms": "Cough, Fever, Sore throat, Sweating", "meds": "Paracetamol (500mg), Antihistamine (10mg)", "consult": "No"},
    "Diabetes": {"symptoms": "Frequent urination, Increased thirst, Fatigue, Sweating, Headache, Blurred vision", "meds": "Metformin (500mg), Insulin (10 units)", "consult": "Yes"},
    "Migraine": {"symptoms": "Throbbing headache, Nausea, Sensitivity to light", "meds": "Ibuprofen (400mg), Sumatriptan (50mg)", "consult": "No"},
    "COVID-19": {"symptoms": "Fever, Loss of taste, Loss of smell, Dry cough, Sweating", "meds": "Paracetamol (500mg), Vitamin C (1000mg)", "consult": "Yes"},
    "Allergy": {"symptoms": "Sneezing, Itchy eyes, Runny nose", "meds": "Cetirizine (10mg), Loratadine (10mg)", "consult": "No"},
    "Asthma": {"symptoms": "Shortness of breath, Wheezing, Chest tightness", "meds": "Salbutamol (100mcg), Budesonide (200mcg)", "consult": "Yes"},
    "Hypertension": {"symptoms": "Headache, Dizziness, Blurred vision, Sweating", "meds": "Amlodipine (5mg), Losartan (50mg)", "consult": "Yes"}
}

data = []
genders = ["Male", "Female", "Other"]
for disease, info in diseases.items():
    for _ in range(70):  # ~70 rows per disease
        data.append({
            "Gender": random.choice(genders),
            "Age": random.randint(1, 99),
            "Disease Name": disease,
            "Symptoms": info["symptoms"],
            "Disease Duration (days)": random.randint(1, 60),
            "Medications": info["meds"],
            "Consult Doctor": info["consult"]
        })

df = pd.DataFrame(data)
df.to_csv("updated_medical_dataset.csv", index=False)