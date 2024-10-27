# memento_mori_ft

A new Flutter project.

## Getting Started

### launch.json 세팅(각 로컬 세팅에 맞게 커스텀)  

### debug run 환경에서 선택후 run debug  
![image](https://github.com/user-attachments/assets/fb1a2bfe-e617-48dc-9fe4-2b527d8516b9)


```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "cmake",
            "request": "launch",
            "name": "CMake: Externally launched",
            "cmakeDebugType": "external",
            "pipeName": "<...>"
        },
        {
            "name": "Flutter iPhone 16 Pro",
            "request": "launch",
            "type": "dart",
            "deviceId": "78A7FACA-5860-4D75-99AD-94D6D74B73CD", // Use the device ID from `flutter devices`
            "program": "lib/main.dart"
        },
        {
            "name": "android(emulator-5554)",
            "request": "launch",
            "type": "dart",
            "deviceId": "emulator-5554", // Use the device ID from `flutter devices`
            "program": "lib/main.dart"
        },
        {
            "name": "Flutter Medium Phone API 35",
            "request": "launch",
            "type": "dart",
            "deviceId": "Medium_Phone_API_35", // Use the device ID from `flutter devices`
            "program": "lib/main.dart"
        },
        {
            "name": "memento_mori_ft",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "memento_mori_ft (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "memento_mori_ft (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release"
        },
        {
            "name": "memento_mori_ft (Chrome)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "debug",
            "deviceId": "chrome"
        }
    ]
}
```



