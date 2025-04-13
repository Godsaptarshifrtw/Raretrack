from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd
import numpy as np

# Initialize FastAPI app
app = FastAPI()

# Load the model, encoder, and scaler
model = joblib.load('random_forest_model.pkl')
encoder = joblib.load('encoder.pkl')
scaler = joblib.load('scaler.pkl')

# Load the dataset from data.py
dataset = pd.read_csv("updated_medical_dataset.csv")

# Extract symptoms from the dataset (assuming 'Symptoms' column contains symptoms)
valid_symptoms = set()

# Iterate over the rows and add symptoms to the valid_symptoms set
for symptoms in dataset['Symptoms']:
    valid_symptoms.update(symptom.strip() for symptom in symptoms.split(','))

# Convert the set back to a list for easy iteration
valid_symptoms = list(valid_symptoms)

# Define a dictionary for medications based on diseases
disease_to_medications = {
    "Flu": {"medications": ["Paracetamol 500mg", "Antihistamine 10mg"], "consult": "No"},
    "Diabetes": {"medications": ["Metformin 500mg", "Insulin 10 units"], "consult": "Yes"},
    "Hypertension": {"medications": ["Amlodipine 5mg", "Losartan 50mg"], "consult": "Yes"},
    "Asthma": {"medications": ["Salbutamol 100mcg", "Budesonide 200mcg"], "consult": "Yes"},
    "Migraine": {"medications": ["Ibuprofen 400mg", "Sumatriptan 50mg"], "consult": "No"},
    "COVID-19": {"medications": ["Paracetamol 500mg", "Vitamin C 1000mg"], "consult": "Yes"},
    "Hepatitis": {"medications": ["Tenofovir 300mg", "Entecavir 0.5mg"], "consult": "Yes"},
    "Osteoarthritis": {"medications": ["Paracetamol 500mg", "Diclofenac 50mg"], "consult": "Yes"},
    "Depression": {"medications": ["Fluoxetine 20mg", "Sertraline 50mg"], "consult": "Yes"},
    "Anxiety": {"medications": ["Alprazolam 0.5mg", "Clonazepam 0.25mg"], "consult": "Yes"},
    "Thyroid Disorder": {"medications": ["Levothyroxine 50mcg", "Methimazole 5mg"], "consult": "Yes"},
    "Pneumonia": {"medications": ["Azithromycin 500mg", "Ceftriaxone 1g"], "consult": "Yes"},
    "Crohn's Disease": {"medications": ["Mesalamine 800mg", "Prednisone 20mg"], "consult": "Yes"},
    "Allergic Rhinitis": {"medications": ["Levocetirizine 5mg", "Nasal Corticosteroids"], "consult": "No"},
    "Urinary Tract Infection (UTI)": {"medications": ["Nitrofurantoin 100mg", "Ciprofloxacin 500mg"], "consult": "Yes"},
    "Gastritis": {"medications": ["Omeprazole 20mg", "Ranitidine 150mg"], "consult": "No"},
    "Acne": {"medications": ["Benzoyl Peroxide 5%", "Clindamycin Gel"], "consult": "No"},
    "Eczema": {"medications": ["Hydrocortisone Cream", "Tacrolimus Ointment"], "consult": "No"},
    "Anemia": {"medications": ["Ferrous Sulfate 325mg", "Folic Acid 5mg"], "consult": "Yes"},
    "Chronic Kidney Disease": {"medications": ["Lisinopril 10mg", "Furosemide 40mg"], "consult": "Yes"},
    "Parkinson's Disease": {"medications": ["Levodopa 250mg", "Carbidopa 25mg"], "consult": "Yes"},
    "Multiple Sclerosis": {"medications": ["Interferon Beta 1a 30mcg", "Glatiramer Acetate 20mg"], "consult": "Yes"},
    "HIV/AIDS": {"medications": ["Tenofovir 300mg", "Emtricitabine 200mg"], "consult": "Yes"},
    "Tuberculosis": {"medications": ["Isoniazid 300mg", "Rifampicin 600mg"], "consult": "Yes"}
}

# Define input data structure
class DiseasePredictionRequest(BaseModel):
    age: int
    gender: str
    duration: int
    symptoms: list

# Function to validate input
def validate_input(data):
    if data.age <= 0 or data.duration <= 0:
        raise HTTPException(status_code=400, detail="Age and duration must be positive integers.")
    
    valid_genders = ["Male", "Female"]
    if data.gender not in valid_genders:
        raise HTTPException(status_code=400, detail="Gender must be 'Male' or 'Female'.")
    
    if not data.symptoms or any(symptom.strip() not in valid_symptoms for symptom in data.symptoms):
        raise HTTPException(status_code=400, detail="Symptoms contain invalid or missing data.")

# Define prediction endpoint
@app.post("/predict")
def predict_disease(request: DiseasePredictionRequest):
    # Validate input
    validate_input(request)
    
    # Prepare input features
    symptoms_str = ', '.join(sorted(request.symptoms))
    input_data = {
        'Age': [request.age],
        'Gender': [request.gender],
        'Disease Duration (days)': [request.duration],
        'Symptoms': [symptoms_str]
    }
    
    # Convert to DataFrame
    input_df = pd.DataFrame(input_data)
    
    # Encode and scale
    input_df['Gender'] = encoder.transform(input_df['Gender'])
    input_df = pd.get_dummies(input_df, columns=['Symptoms'], prefix='Symptom')
    
    # Ensure all expected symptom columns are present
    expected_columns = [col for col in model.feature_names_in_ if col.startswith('Symptom_')]
    for col in expected_columns:
        if col not in input_df.columns:
            input_df[col] = 0
    input_df = input_df[model.feature_names_in_]
    
    input_df[['Age', 'Disease Duration (days)']] = scaler.transform(input_df[['Age', 'Disease Duration (days)']])
    
    # Make prediction
    prediction = model.predict(input_df)
    prediction_prob = model.predict_proba(input_df)
    
    # Get top predictions
    top_predictions = sorted(zip(model.classes_, prediction_prob[0]), key=lambda x: x[1], reverse=True)[:5]
    
    predicted_disease = prediction[0]
    predicted_prob = prediction_prob[0][np.where(model.classes_ == predicted_disease)][0]
    
    # Get corresponding medications and consultation advice for the predicted disease
    disease_info = disease_to_medications.get(predicted_disease, {"medications": ["No specific medications found"], "consult": "Yes"})
    
    # Prepare response
    response = {
        "predicted_disease": predicted_disease,
        "probability": round(predicted_prob, 2),
        "top_predictions": [{"disease": disease, "probability": round(prob, 2)} for disease, prob in top_predictions],
        "medications": disease_info["medications"],
        "consult_doctor": disease_info["consult"]
    }
    
    return response