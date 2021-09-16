#include <LiquidCrystal.h>
#include <ESP8266WiFi.h>

const char *ssid = "TP-Link_58E5";
const char *password = "97001515";

LiquidCrystal lcd(5, 4, 2, 14, 12, 13); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7)
WiFiServer wifiServer(80);

// defines pins numbers
const int trigPin = 15;
const int echoPin = 16;

long duration;
int distanceCm, distanceInch;

void setup()
{
    lcd.begin(16, 2); // Initializes the interface to the LCD screen, and specifies the dimensions (width and height) of the display
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);
}
void loop()
{

    WiFiClient client = wifiServer.available();
    String command = "cm";

    if (client)
    {
        lcd.autoscroll(); /// Scroll to show connexted
        lcd.print("  Connected");
        client.write("Client connected");

        while (client.connected())
        {
            lcd.noAutoscroll(); /// Stop Scrol.
            lcd.noBlink();      // Turns off the blinking LCD cursor
            while (client.available() > 0)
            {
                char c = client.read();
                if (c == '\n')
                {
                    break;
                }
                command = c;
                Serial.write(c);
                client.write(c);
            }

            digitalWrite(trigPin, LOW);

            /// Delay
            delayMicroseconds(20);

            digitalWrite(trigPin, HIGH);

            /// Delay
            delayMicroseconds(100);

            digitalWrite(trigPin, LOW);
            duration = pulseIn(echoPin, HIGH);
            distanceCm = duration * 0.034 / 2;
            distanceInch = duration * 0.0133 / 2;
            if (command == "cm")
            {
                client.printf("%s cm", distanceCm); /// Sends to client
            }
            else
            {
                client.printf("%s inch", distanceInch); /// Sends to client
            }

            /// Print to LCD
            lcd.setCursor(0, 0); // Sets the location at which subsequent text written to the LCD will be displayed

            lcd.write("Distance: "); // Prints string "Distance" on the LCD
            lcd.write(distanceCm);   // Prints the distance value from the sensor
            lcd.write(" cm");

            /// Delay
            delay(30);

            /// Print to LCD
            lcd.setCursor(0, 1); // Sets the location at which subsequent text written to the LCD will be displayed

            lcd.write("Distance: "); // Prints string "Distance" on the LCD
            lcd.write(distanceInch); // Prints the distance value from the sensor
            lcd.write(" inch");

            /// Delay
            delay(30);
        }

        client.stop();
        lcd.clear();
        lcd.print("Disconnected");
    }
}
