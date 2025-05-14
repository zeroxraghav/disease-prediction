# Disease Prediction ML Project

This project predicts diseases based on symptoms using a machine learning model. It includes a Jupyter notebook for model training and a FastAPI backend for serving predictions.

---

## 1. Model Training

- All training and feature selection is done in `ModelTraining/Model.ipynb`.
- The notebook:
  - Loads and cleans the data.
  - Trains a `DecisionTreeClassifier`.
  - Selects important features (removes features with low importance).
  - Saves the trained model as `model.pkl` and the feature list as `features.pkl`.

**To retrain the model:**

1. Open the notebook and run all cells.
2. Uncomment and run the code that saves `model.pkl` and `features.pkl`:

   ```python
   # Save the trained model
   with open('model.pkl', 'wb') as f:
       pickle.dump(tree, f)

   # Save the selected features
   important_features = list(training_new.columns)
   important_features.remove('prognosis')
   with open('features.pkl', 'wb') as f:
       pickle.dump(important_features, f)
   ```

---

## 2. Backend API

The backend is a FastAPI app that loads the trained model and features, and exposes a `/predict` endpoint.

### Setup

1. Navigate to the `Backend` folder:
   ```sh
   cd Backend
   ```
2. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```
3. Ensure `model.pkl` and `features.pkl` are present in this folder.

### Running the API

```sh
uvicorn app:app --reload
```

- The API will be available at: [http://127.0.0.1:8000](http://127.0.0.1:8000)

### `/predict` Endpoint

- **Method:** POST
- **Request Body:**

  ```json
  {
    "input_data": {
      "itching": 1,
      "skin_rash": 0,
      ...
    }
  }
  ```

  - Each key is a symptom (feature), value is 1 (present) or 0 (absent).
  - You can omit features; missing ones default to 0.

- **Response:**

  ```json
  {
    "prediction": "DiseaseName"
  }
  ```

- **Example cURL:**
  ```sh
  curl -X POST "http://127.0.0.1:8000/predict" \
    -H "Content-Type: application/json" \
    -d "{\"input_data\": {\"itching\": 1, \"skin_rash\": 0}}"
  ```

---

## 3. Requirements

- Python 3.8+
- See `Backend/requirements.txt` for backend dependencies:
  - fastapi
  - uvicorn
  - scikit-learn
  - pandas

---

## 4. Notes

- The model expects the same features as in `features.pkl`.
- If you retrain or change feature selection, regenerate and copy both `model.pkl` and `features.pkl` to the `Backend` folder.
- For any issues, check the error messages returned by the API.

---
