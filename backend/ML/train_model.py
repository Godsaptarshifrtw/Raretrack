import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder, StandardScaler

# Load dataset
df = pd.read_csv("updated_medical_dataset.csv")

# Encode Gender
encoder = LabelEncoder()
df['Gender'] = encoder.fit_transform(df['Gender'])

# Create dummy variables for Symptoms
df = pd.get_dummies(df, columns=['Symptoms'], prefix='Symptom')

# Features and target
X = df.drop(['Disease Name', 'Medications', 'Consult Doctor'], axis=1)
y = df['Disease Name']

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scale numerical features
scaler = StandardScaler()
X_train[['Age', 'Disease Duration (days)']] = scaler.fit_transform(X_train[['Age', 'Disease Duration (days)']])
X_test[['Age', 'Disease Duration (days)']] = scaler.transform(X_test[['Age', 'Disease Duration (days)']])

# Train model
model = RandomForestClassifier(random_state=42)
model.fit(X_train, y_train)

# Save model, encoder, and scaler
joblib.dump(model, 'random_forest_model.pkl')
joblib.dump(encoder, 'encoder.pkl')
joblib.dump(scaler, 'scaler.pkl')

# Evaluate model
print("Model accuracy:", model.score(X_test, y_test))