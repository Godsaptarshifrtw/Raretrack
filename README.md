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
Drop_Down Search
latlong2
geolocator
flutter_map
url_launcher
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

Warning!

The backend of the app is hosted on Render using the free tier. Due to this, it may take a few minutes for the server to load, especially if it hasn't been accessed for a while. Additionally, if the server remains idle for 15 minutes, it will automatically shut down. However, it will restart automatically the next time it is accessed. We appreciate your understanding and patience while the server loads!

Link to PPT: https://1drv.ms/p/c/5d5cacc9ce8f979e/EcZOK-RIwgNEsiletLGJ_hYBM_j7jGugX9D__RWOii9uMA?e=3vd21H

Business Idea Based on the app: - 
  
  1. Subscription Plans : We have adjustable subscription plans for various users: Individuals can upgrade to unlimited predictions, viewing of previous results, and in-depth health insights.
                          Doctors & Professionals receive features such as batch predictions, API access, and patient-ready reports.
                          Hospitals & Institutions have our platform with customized dashboards, analytics, and support.
                         These plans assist us in continuing to improve while ensuring the app is accessible to all—everyday users and healthcare professionals alike.
  
  2. Ads & Partnerships:In order to keep the app free for general users, we have relevant, non-intrusive ads:
                        Medication-Based Ads: If a prediction indicates a condition, we might display sponsored treatments or products for it—only from reputable companies.
                        Affiliate Links: You can book teleconsults or purchase recommended medicines through our affiliates and we receive a small fee.





