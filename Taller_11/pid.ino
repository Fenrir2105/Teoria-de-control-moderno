const int potPin = A3;
const int enablePin = 3;
const int encoder = 2;
volatile unsigned int pulseCount = 0;
unsigned long lastMillis = 0;
const unsigned long interval = 50;
float ts = interval / 1000.0;
float u;
float ref;
float e[3];
float Kp = 0.5;
float Ti = 0.7;
float Td = 0.001;

void setup() {
  pinMode(enablePin, OUTPUT);
  pinMode(encoder, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(encoder), countPulse, RISING);
  Serial.begin(115200);
  u = 0;
  e[0] = e[1] = e[2] = 0;
}

void loop() {
  int potValue = analogRead(potPin);
  ref = map(potValue, 0, 1023, 0, 4800); // RPM deseada

  unsigned long currentMillis = millis();
  if (currentMillis - lastMillis >= interval) {
    noInterrupts(); 
    unsigned int pulses = pulseCount;
    pulseCount = 0;
    interrupts();

    float rpm = convertP(pulses);

    // Control PID (forma de posición)
    e[2] = e[1];
    e[1] = e[0];
    e[0] = ref - rpm;

    u += Kp * ((e[0] - e[1]) + (ts/Ti) * e[0] + (Td/ts) * (e[0] - 2*e[1] + e[2]));

    if (u > 255) u = 255;
    if (u < 0)   u = 0;

    analogWrite(enablePin, (int)u);

    Serial.print(rpm);
    Serial.print(',');
    Serial.println(ref);

    lastMillis = currentMillis;
  }
}

void countPulse() {
  pulseCount++;
}

float convertP(int Pulses){
  return (float)Pulses / 0.05 / 36.0 * 60.0;
}
