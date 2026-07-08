import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import time

# Cargar la base de datos (reemplaza 'tus_datos.csv' con la ruta de tu archivo real)
df_global = pd.read_csv('modelos_IA/datos/datos_educativos.csv')

X = df_global[['aciertos', 'errores', 'tiempo_respuesta', 'num_intentos']]
y = df_global['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

tree_model = DecisionTreeClassifier(max_depth=4, random_state=42)

start_time = time.time()
tree_model.fit(X_train, y_train)
train_time = time.time() - start_time

y_pred = tree_model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print(f"--- Resultados Árbol de Decisión ---")
print(f"Precisión (Accuracy): {accuracy:.4f}")
print(f"Tiempo de entrenamiento: {train_time:.6f} segundos")

sample_idx = 0
sample_input = X_test.iloc[sample_idx].values.reshape(1, -1)
sample_pred = tree_model.predict(sample_input)
print(f"Predicción de ejemplo (Input: {X_test.iloc[sample_idx].values}): Clase Predicha {sample_pred[0]}")
