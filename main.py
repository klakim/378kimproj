from fastapi import FastAPI, HTTPException # Works, how I run my API instead of Vetiver
from pydantic import BaseModel
import joblib
import pandas as pd

app = FastAPI()
model = joblib.load('penguin_model.pkl')  # Ensure this is the correct path

class PenguinFeatures(BaseModel):
    bill_length_mm: float
    species_Chinstrap: bool
    species_Gentoo: bool
    sex_male: bool

@app.post('/predict')  # Removed the trailing slash
async def predict(features: PenguinFeatures):
    print(features.dict()) 
    # Convert the Pydantic model to a DataFrame
    data = pd.DataFrame([features.dict()])
    prediction = model.predict(data)
    return {"prediction": prediction.tolist()}

