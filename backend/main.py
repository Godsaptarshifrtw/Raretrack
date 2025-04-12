from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd

# Load model and encoders
model = joblib.load("disease_model.pkl")
gender_encoder = joblib.load("gender_encoder.pkl")
symptom_encoder = joblib.load("symptom_encoder.pkl")

# Mocked medication data
medication_info = {
    "Flu": {"medications": ["Paracetamol 500mg", "Antihistamine 10mg"], "consult": "No"},
    "Diabetes": {"medications": ["Metformin 500mg", "Insulin 10 units"], "consult": "Yes"},
    "Hypertension": {"medications": ["Amlodipine 5mg", "Losartan 50mg"], "consult": "Yes"},
    "Asthma": {"medications": ["Salbutamol 100mcg", "Budesonide 200mcg"], "consult": "Yes"},
    "Migraine": {"medications": ["Ibuprofen 400mg", "Sumatriptan 50mg"], "consult": "No"},
    "COVID-19": {"medications": ["Paracetamol 500mg", "Vitamin C 1000mg"], "consult": "Yes"},
    "Allergy": {"medications": ["Cetirizine 10mg", "Loratadine 10mg"], "consult": "No"}
}

app = FastAPI()

class PredictRequest(BaseModel):
    age: int
    gender: str
    duration: int
    symptoms: list[str]

@app.get("/")
def home():
    return {"message": "Disease Prediction API is live"}

@app.post("/predict")
def predict_disease(data: PredictRequest):
    try:
        gender_encoded = gender_encoder.transform([data.gender])[0]
        symptom_input = symptom_encoder.transform([data.symptoms])
        
        df_input = pd.DataFrame(symptom_input, columns=symptom_encoder.classes_)
        df_input["Age"] = data.age
        df_input["Gender"] = gender_encoded
        df_input["Duration"] = data.duration

        prediction = model.predict(df_input)[0]
        result = {
            "disease": prediction,
            "medications": medication_info[prediction]["medications"],
            "consult_doctor": medication_info[prediction]["consult"]
        }
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
