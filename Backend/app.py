from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import pandas as pd

app = FastAPI()

with open("model.pkl", "rb") as f:
    model = pickle.load(f)

with open("features.pkl", "rb") as f:
    feature_columns = pickle.load(f)

class InputData(BaseModel):
    input_data: dict  

# API endpoint
@app.post("/predict")
def predict(data: InputData):
    input_dict = data.input_data

   
    try:
        full_input = {}
        for feature in feature_columns:
            full_input[feature] = input_dict.get(feature, 0)
        input_df = pd.DataFrame([input_dict], columns=feature_columns)
    except Exception as e:
        return {"error": "Input data does not match expected features", "details": str(e)}

    prediction = model.predict(input_df)

    return {"prediction": prediction[0]}
