import processing.serial.*;
Serial myPort;  // Generamos una variable tipo Serials

int rectX, rectY;    
int ancho = 90;       // Tamaño de los botones
int nivel = 0;        // Variable de estado

// Variables para el estado de los LEDs y pulsadores
int estadoL1 = 0; // Estado del LED 1
int estadoL2 = 0; // Estado del LED 2

void setup() {
  size(640, 360);
  frameRate(60);  
  rectX = width / 8;
  rectY = height / 8;
  background(50, 50, 0);
  // Conexión serial igual al ejemplo del profe
  String portName = Serial.list()[0]; // Cambiá el índice [1] si tu Arduino está en otro puerto
  myPort = new Serial(this, portName, 9600);
  
}

void draw(){
// 1. Dibujamos el fondo y actualizamos la interfaz al inicio del frame[cite: 8]
  background(50, 50, 50); 
  
  textSize(16);
  fill(255);
  text("BOTONES (Clic para enviar):", rectX, rectY - 15);
  text("INDICADORES (LEDs / Pelotitas):", rectX, rectY + 110);

  // 2. ESCUCHAR AL ARDUINO: 
  // Si el Arduino manda '1' o '2' (porque apretaste el botón físico allá), 
  // alternamos el estado de las pelotitas L1 o L2 en la pantalla.
  if (myPort.available() > 0) {
    char datoRecibido = (char) myPort.read();
    
    if (datoRecibido == '1') {
      estadoL1 = 1 - estadoL1; // Cambia el estado visual de la pelotita L1
    } else if (datoRecibido == '2') {
      estadoL2 = 1 - estadoL2; // Cambia el estado visual de la pelotita L2
    }
  }

  // 3. Llamamos a la función de los botones (estructura de la cátedra)[cite: 5, 8]
  nivel = cuatrobotones();
  // 4. ENVIAR AL ARDUINO Y ACTUALIZAR LOCALMENTE:
  // Al hacer clic con el mouse en E1 o E2, mandamos la orden y también 
  // conmutamos la pelotita correspondiente para que se prenda en el acto.
  switch(nivel) {
    case 1: 
      myPort.write('1');       // Le avisa al Arduino que prenda/apague su LED 1
      estadoL1 = 1 - estadoL1; // Prende/apaga la pelotita L1 en Processing
      break;
      
    case 2: 
      myPort.write('2');       // Le avisa al Arduino que prenda/apague su LED 2
      estadoL2 = 1 - estadoL2; // Prende/apaga la pelotita L2 en Processing
      break;
  }
}

// Función auxiliar provista por la cátedra para verificar clics en rectángulos[cite: 3]
boolean enRect(int x, int y, int ancho, int alto) {
  if (mouseX >= x && mouseX <= x + ancho && 
      mouseY >= y && mouseY <= y + alto) {
    return true;
  } else {
    return false;
  }
}

// --- FUNCIÓN DE BOTONES Y LUCES 
int cuatrobotones() {
  int i;
  
  // --- FILA SUPERIOR: E1 y E2 (BOTONES INTERACTIVOS DE PROCESSING) ---
  for (i = 0; i <= 1; i++) {
    stroke(255);
    fill(100); 
    rect(rectX + (i * 120), rectY, ancho, ancho);
    
    fill(255);
    textSize(18);
    text("E" + (i + 1), rectX + (i * 120) + 35, rectY + 50);
  }
  
  // --- CREACION : L1 y L2 (PELOTITAS / INDICADORES VISUALES) ---
  int centroY = rectY + 180;
  
  // Pelotita L1 (Se prende con Arduino o con el botón E1)
  stroke(255);
  fill(estadoL1 == 1 ? color(0, 255, 0) : color(100)); // Verde si está prendido, gris si no
  ellipse(rectX + 45, centroY, ancho, ancho); //tamaño y ubicacion de la pelotita
  fill(255);
  text("L1", rectX + 38, centroY + 6);

  // Pelotita L2 (Se prende con Arduino o con el botón E2)
  fill(estadoL2 == 1 ? color(255,0, 0) : color(100));
  ellipse(rectX + 165, centroY, ancho, ancho);
  fill(255);
  text("L2", rectX + 158, centroY + 6);

  // --- DETECCIÓN DE CLICS para E1 y E2 ---
  if (enRect(rectX, rectY, ancho, ancho) && mousePressed) {
    delay(200);
    return 1;   
  }
  else if (enRect(rectX + 120, rectY, ancho, ancho) && mousePressed) {
    delay(200);
    return 2;   
  }

  return 0;      
}
