import 'package:flutter/material.dart';
import 'mqtt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MQTTManager mqttManager = MQTTManager(
    host: "test.mosquitto.org",
    topic: "multi/window",
    identifier: "flutterdroid",
  );

  @override
  void initState() {
    super.initState();
    mqttManager.initializeMQTTClient();
    mqttManager.connect();
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    super.dispose();
  }

  bool status = true;

  void _setStatusOff() {
    mqttManager.publish("false", "device/window");
    setState(() {
      status = false;
    });
  }

  void _setStatusOn() {
    mqttManager.publish("true", "device/window");
    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.deepPurple[200],
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: status
                      ? const Icon(Icons.sensor_window_outlined,
                          color: Colors.white, size: 64)
                      : const Icon(Icons.lock_outline_rounded,
                          color: Colors.white, size: 64),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ValueListenableBuilder<String>(
                    valueListenable: mqttManager.windowAngle,
                    builder: (BuildContext context, String value, child) {
                      return Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0),
                        "$value% Opened",
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _setStatusOn,
                  child: const Text("ON - Auto"),
                ),
                ElevatedButton(
                  onPressed: _setStatusOff,
                  child: const Text("OFF - Locked"),
                ),
              ]),
          appBar: AppBar(
            title: const Text("Air Indoors"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            elevation: 0,
          ),
        ));
  }
}
