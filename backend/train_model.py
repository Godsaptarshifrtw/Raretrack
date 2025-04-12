import pandas as pd
from sklearn.preprocessing import LabelEncoder, MultiLabelBinarizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import joblib

# Load the CSV
df = pd.read_csv("medical_dataset.csv")

# Encode gender
gender_enc = LabelEncoder()
df["Gender_enc"] = gender_enc.fit_transform(df["Gender"])

# Encode symptoms
symptom_list = set()
for symptoms in df["Symptoms"]:
    symptom_list.update(symptoms.split(", "))
symptom_list = sorted(symptom_list)

mlb = MultiLabelBinarizer(classes=symptom_list)
symptom_encoded = mlb.fit_transform(df["Symptoms"].str.split(", "))

# Prepare features
X = pd.DataFrame(symptom_encoded, columns=mlb.classes_)
X["Age"] = df["Age"]
X["Gender"] = df["Gender_enc"]
X["Duration"] = df["Disease Duration (days)"]

# Target variable
y = df["Disease Name"]

# Train model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Save model and encoders
joblib.dump(model, "disease_model.pkl")
joblib.dump(gender_enc, "gender_encoder.pkl")
joblib.dump(mlb, "symptom_encoder.pkl")
