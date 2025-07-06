const int potPin = A3;
const int enablePin = 3;
const int in1 = 5;
const int in2 = 6;
const int buttonPin = 7;
const int encoder = 2;
volatile unsigned int pulseCount = 0;
unsigned long lastMillis = 0;
const unsigned long interval = 50; // cada 1 segundo

void setup() {
    pinMode(enablePin, OUTPUT);
    pinMode(in1, OUTPUT);
    pinMode(in2, OUTPUT);
    pinMode(buttonPin, INPUT); 
  	pinMode(encoder, INPUT_PULLUP);
  	attachInterrupt(digitalPinToInterrupt(encoder), countPulse, RISING);
  	digitalWrite(in1, HIGH);
  	digitalWrite(in2, LOW);
	Serial.begin(115200);
}

void loop() {
  int potValue = analogRead(potPin);
  int speed = map(potValue, 0, 1023, 0, 255);
  analogWrite(enablePin, speed);
  unsigned long currentMillis = millis();
  if (currentMillis - lastMillis >= interval) {
    noInterrupts(); 
    unsigned int pulses = pulseCount;
    pulseCount = 0;
    interrupts();

    float rpm = convertP(pulses);
    Serial.print("RPM: ");
    Serial.println(rpm);

    lastMillis = currentMillis;
  }
}

void countPulse() {
  pulseCount++;
}

float convertP(int Pulses){
	return (float)Pulses/0.05 /58.0 * 60.0;
}