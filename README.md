Disease Prediction App

OVERVIEW:

This application uses a machine learning model to predict possible diseases based on user-entered symptoms and medical history. The predictions are intended for informational purposes only and are not a substitute for professional medical consultation. There will also be suggestions or option to identify nearby doctors or medicine shops through our app.



Features
1.User login and authentication
2.Input for symptoms, current diseases, past medical history, and treatments
3.Machine learning model prediction


INSTALLATION

We will provide the Apk file in the repo once its completely built for now the apk is available in build\app\outputs\flutter-apk\app-release.apk.
or
Clone the Repository and then download the packages using 
flutter pub get
link a device or use a virtual device and run it using 
flutter run


USAGE

Download the APK file.
Log in with your credentials.
Enter the required information on the prediction screen.
Review the predicted results.
Consult the nearby doctors if needed.

DEPENDENCIES

Firebase Authentication Package
Http Package 
Firebase Core 
Cloud Firestore
Pandas 
Scikit-learn 
Xgboost 
Imbalanced-learn
Flask 
Joblib 
Numpy 

Working:
The user sends the symptoms and other problems and his own data through a post request and the ML model is run using FASTAPI which is trained on a dataset:https://data.mendeley.com/datasets/2cxccsxydc/1
this then sends the probable diseases that the user might have and then recommends medicine shops and doctors nearby.

Link to PPT: https://1drv.ms/p/c/5d5cacc9ce8f979e/EcZOK-RIwgNEsiletLGJ_hYBM_j7jGugX9D__RWOii9uMA?e=3vd21H
