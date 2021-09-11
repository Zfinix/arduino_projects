#include <LiquidCrystal.h>
#include <ESP8266WiFi.h>

const char *ssid = "TP-Link_58E5";
const char *password = "97001515";

LiquidCrystal lcd(5, 4, 2, 14, 12, 13); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7)
WiFiServer wifiServer(80);
int whichLine = 0;

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

        char c = client.read(); /// Read from client
        if (c == '\n')
        {
          break;
        }

        command += c;
        Serial.write(c);
        client.write(c);
      }

      if (command == "clear")
      {
        lcd.clear(); /// Clear LCD
      }

      else
      {

        if (command.length() > 16) /// Handle when text is longer than 16 chars
        {
          lcd.print(command.substring(0, 16));                /// Print first line to LCD
          lcd.setCursor(0, 2);                                /// Move to new line
          lcd.print(command.substring(16, command.length())); /// Print second line to LCD
        }
        else
        {
          lcd.print(command); /// Print command to LCD
        }
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
