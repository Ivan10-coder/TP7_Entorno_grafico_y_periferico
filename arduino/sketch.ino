int pinE1 = 2;
int pinE2 = 3;
int pinL1 = 8;
int pinL2 = 9;
bool estadoL1 = false;
bool estadoL2 = false;

void setup() {
// Entradas pulsadores
pinMode(pinE1, INPUT_PULLUP);
pinMode(pinE2, INPUT_PULLUP);

// Salidas digitales
pinMode(pinL1, OUTPUT);
pinMode(pinL2, OUTPUT);

// Iniciamos la comunicacion con processing
Serial.begin(9600);


}

void loop() {
  // --- 1. LECTURA DE PULSADORES (Físico -> Arduino -> Processing) ---
  if (digitalRead(pinE1) == LOW) { // Si apretás el botón 1
    estadoL1 = !estadoL1;         // Invertimos el estado del LED 1
    digitalWrite(pinL1, estadoL1 ? HIGH : LOW); // Actualizamos el LED físico
    
    Serial.write('1');            // Le mandamos un aviso por serial a Processing (como hacía el profe)
    delay(200);                   // Pausa anti-rebote
  }

  if (digitalRead(pinE2) == LOW) { // Si apretás el botón 2
    estadoL2 = !estadoL2;
    digitalWrite(pinL2, estadoL2 ? HIGH : LOW);
    
    Serial.write('2');            // Avisamos a Processing que se activó el 2
    delay(200);
  }

  // --- 2. LECTURA DE PROCESSING (PC -> Arduino) ---
  if (Serial.available() > 0) {
    char datoRecibido = Serial.read();
    
    if (datoRecibido == '1') {
      estadoL1 = !estadoL1;
      digitalWrite(pinL1, estadoL1 ? HIGH : LOW);
    }
    if (datoRecibido == '2') {
      estadoL2 = !estadoL2;
      digitalWrite(pinL2, estadoL2 ? HIGH : LOW);
    }
  }
}

