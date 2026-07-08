import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.metrics import accuracy_score
import time

# Cargar la base de datos
df_global = pd.read_csv('modelos_IA/datos/datos_educativos.csv')

# Separación de características y variable objetivo
X = df_global[['aciertos', 'errores', 'tiempo_respuesta', 'num_intentos']]
y = df_global['target']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

scaler = StandardScaler()
# Se retiró 'multi_class'; el modelo ahora lo detecta automáticamente
logreg = LogisticRegression(solver='lbfgs', random_state=42)

model_pipeline = make_pipeline(scaler, logreg)

start_time = time.time()
model_pipeline.fit(X_train, y_train)
train_time = time.time() - start_time

y_pred = model_pipeline.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f"--- Resultados Regresión Logística ---")
print(f"Precisión (Accuracy): {accuracy:.4f}")
print(f"Tiempo de entrenamiento: {train_time:.6f} segundos")

print("\n--- Parámetros para exportar a Dart ---")
print("Scaler Mean (Media):", scaler.mean_)
print("Scaler Scale (Desv. Std):", scaler.scale_)
print("Coeficientes (Pesos W):", logreg.coef_)
print("Interceptos (Sesgos b):", logreg.intercept_)