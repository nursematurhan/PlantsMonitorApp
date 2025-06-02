#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>
#include <time.h>

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Wi-Fi credentials
#define WIFI_SSID "xxx"
#define WIFI_PASSWORD "xxx"

// Firebase credentials
#define API_KEY "xxxxxxxxx"
#define DATABASE_URL "xxxxxxxxx"

// DHT11 setup
#define DHTPIN D4
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Soil moisture sensor
int soilPin = A0;

void setup() {
    Serial.begin(9600);
    dht.begin();

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("📡 Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(500);
    }
    Serial.println("\n✅ Wi-Fi connected");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    // TLS time sync (required)
    configTime(3 * 3600, 0, "pool.ntp.org", "time.nist.gov");
    Serial.print("🕒 Syncing time");
    time_t now = time(nullptr);
    while (now < 8 * 3600 * 2) {
        Serial.print(".");
        delay(1000);
        now = time(nullptr);
    }
    Serial.println("\n⏱ Time synchronized");
    Serial.print("⏰ Current time: ");
    Serial.println(ctime(&now)); // Print time for debug

    // Firebase config
    config.api_key = API_KEY;
    config.database_url = DATABASE_URL;
    config.signer.test_mode = true;

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
    Serial.println("🔥 Firebase initialized");

    // Test TLS connection (optional but useful)
    WiFiClientSecure testClient;
    testClient.setInsecure();
    if (testClient.connect(DATABASE_URL, 443)) {
        Serial.println("✅ TLS connection to Firebase successful");
    } else {
        Serial.println("❌ TLS connection to Firebase failed");
    }
}

void loop() {
    float temp = dht.readTemperature();
    float hum = dht.readHumidity();
    int soil = analogRead(soilPin);

    if (isnan(temp) || isnan(hum)) {
        Serial.println("⚠️ Failed to read from DHT sensor!");
        delay(10000);
        return;
    }

    if (Firebase.ready()) {
        if (Firebase.RTDB.setFloat(&fbdo, "/data/temperature", temp)) {
            Serial.println("✅ Temperature sent");
        } else {
            Serial.println("❌ Temp error: " + fbdo.errorReason());
        }

        if (Firebase.RTDB.setFloat(&fbdo, "/data/humidity", hum)) {
            Serial.println("✅ Humidity sent");
        } else {
            Serial.println("❌ Hum error: " + fbdo.errorReason());
        }

        if (Firebase.RTDB.setInt(&fbdo, "/data/soilMoisture", soil)) {
            Serial.println("✅ Soil moisture sent");
        } else {
            Serial.println("❌ Soil error: " + fbdo.errorReason());
        }
    } else {
        Serial.println("❌ Firebase not ready");
    }

    delay(30000);
}