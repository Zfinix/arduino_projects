#include <LiquidCrystal.h>
#include <ESP8266WiFi.h>

const char *ssid = "TP-Link_58E5";
const char *password = "97001515";

const int LED_PIN = 16;

const int WAITTIME = 50;
const int STEP = 5;


LiquidCrystal lcd(5, 4, 2, 14, 12, 13); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7)
WiFiServer wifiServer(80);

void setup()
{
  lcd.begin(16, 2); // Initializes the interface to the LCD screen, and specifies the dimensions (width and height) of the display }
  Serial.begin(115200);

  delay(1000); /// Minor delay

  WiFi.begin(ssid, password);    /// Connect to wifi
  Serial.println(WiFi.status()); /// Print status to serial

  while (WiFi.status() != WL_CONNECTED)
  {
    lcd.clear();
    lcd.print("Connecting...");
    delay(1000);
    lcd.cursor();
    lcd.blink();
  }

  lcd.clear();
  lcd.print("IP Address:");
  lcd.setCursor(0, 2); ///  Move to Next line
  lcd.print(WiFi.localIP());

  wifiServer.begin(); /// Srart wifi Server
}

void loop()
{
  WiFiClient client = wifiServer.available();
  String command = "";

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

        command  = client.readStringUntil('\n'); /// Read from client
        

        Serial.print(command);
        client.print(command);
      }

      if (command == "clear")
      {
        lcd.clear(); /// Clear LCD
      }
      else if(command != "")
      {
        analogWrite(LED_PIN, command.toInt());
       lcd.print("Brightness: ");
       lcd.setCursor(0, 2);
       float percentage = (float)command.toInt() / 255 * 100.0;
       lcd.print(100-percentage);
       lcd.print("%");
      }

      command = "";
      lcd.setCursor(0, 0);
      delay(10);
    }

    client.stop();
    lcd.clear();
    lcd.print("Disconnected");
  }
}
