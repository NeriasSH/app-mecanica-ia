import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.metrics import accuracy_score
import time

df_global = pd.read_csv('modelos_IA/datos/datos_educativos.csv')

X = df_global[['aciertos', 'errores', 'tiempo_respuesta', 'num_intentos']]
y = df_global['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

scaler = StandardScaler()
mlp_model = MLPClassifier(hidden_layer_sizes=(8,), max_iter=500, activation='relu', solver='adam', random_state=42)

model_pipeline = make_pipeline(scaler, mlp_model)

start_time = time.time()
model_pipeline.fit(X_train, y_train)
train_time = time.time() - start_time

y_pred = model_pipeline.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f"--- Resultados Red Neuronal Simple (MLP) ---")
print(f"Precisión (Accuracy): {accuracy:.4f}")
print(f"Tiempo de entrenamiento: {train_time:.6f} segundos")
print(f"Arquitectura: {mlp_model.hidden_layer_sizes} neuronas ocultas")