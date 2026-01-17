# Hide Online Unity ESP - IL2CPP

iOS ESP (Extra Sensory Perception) mod for Hide Online Unity game using IL2CPP hooking technology.

![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

## ⚠️ Disclaimer

This project is for **educational purposes only**. Use responsibly and at your own risk. The developers are not responsible for any consequences resulting from the use of this software.

## 📋 Features

- **ESP Line** - Draw lines pointing to players
- **ESP 3D Box** - Draw 3D boxes around players
- **ESP Distance** - Display distance to players
- **Draw All Players** - Show ESP for all players (Hunter & Prop)
- **Modern ImGui Menu** - Easy-to-use interface
- **Rootless Support** - Compatible with rootless jailbreaks

## 🎮 Supported Game

- **Hide Online** (`com.hitrock.hideonline`)
- Unity IL2CPP based game

## 📦 Requirements

- iOS 14.0+
- Jailbroken device (rootless compatible)
- Theos development environment
- Hide Online game installed

## 🛠️ Building

1. Install [Theos](https://theos.dev/)
2. Clone this repository:
```bash
git clone https://github.com/x2niosvn/Hide-Online-Unity-ESP-il2cpp.git
cd Hide-Online-Unity-ESP-il2cpp
```

3. Configure your device IP in `Makefile` (optional):
```makefile
THEOS_DEVICE_IP = YOUR_DEVICE_IP
```

4. Build and install:
```bash
make package install
```

## ⚙️ Configuration

Edit `ESPConfig.h` to customize ESP settings:

```cpp
// Player classes
#define PLAYER_CLASS_NAME_HUNTER "Hunter"
#define PLAYER_CLASS_NAME_PROP "Prop"
#define PLAYER_ASSEMBLY_NAME "Assembly-CSharp.dll"

// ESP distances
#define ESP_MAX_DISTANCE 100.0f

// ESP colors (RGBA)
#define ESP_LINE_COLOR_R 255
#define ESP_LINE_COLOR_G 0
#define ESP_LINE_COLOR_B 0
#define ESP_LINE_COLOR_A 255
```

## 📱 Usage

1. Install the tweak on your jailbroken device
2. Launch Hide Online game
3. The ESP menu will appear automatically
4. Enable ESP features from the menu
5. Customize settings as needed

## 🎯 Menu Controls

- **ESP Tab**: Enable/disable ESP features
  - ESP Enable: Master switch for all ESP features
  - ESP Line: Draw lines to players
  - ESP Box: Draw 3D boxes around players
  - ESP Distance: Show distance to players
  - Draw All Players: Include all players (not just enemies)

## 🏗️ Project Structure

```
Hide-Online-Unity-ESP-il2cpp/
├── Esp/              # ESP implementation files
├── IL2CPP/           # IL2CPP hooking utilities
├── IMGUI/            # ImGui library
├── Init/             # Initialization code
├── ESPConfig.h       # Configuration file
├── ImGuiDrawView.mm  # Main drawing view
└── Makefile          # Build configuration
```

## 🙏 Credits

- **Author**: [x2niosvn](https://github.com/x2niosvn) (@x2nios)
- **Base Project**: [IOS-ESP-AutoUpdate](https://github.com/xS3Cx/IOS-ESP-AutoUpdate) by [xS3Cx](https://github.com/xS3Cx)
- **ImGui**: [Dear ImGui](https://github.com/ocornut/imgui)
- **IL2CPP**: Unity IL2CPP runtime

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Telegram**: [@x2nios](https://t.me/x2nios)
- **GitHub**: [@x2niosvn](https://github.com/x2niosvn)

## 🔗 Related Projects

- [IOS-ESP-AutoUpdate](https://github.com/xS3Cx/IOS-ESP-AutoUpdate) - Base ESP framework for Unity IL2CPP games

---

**Note**: This project is based on the excellent work by xS3Cx. Please support the original project!

---

# Hide Online Unity ESP - IL2CPP (Tiếng Việt)

Mod ESP (Extra Sensory Perception) cho game Hide Online Unity trên iOS sử dụng công nghệ hook IL2CPP.

## ⚠️ Lưu Ý

Dự án này chỉ dành cho **mục đích giáo dục**. Sử dụng có trách nhiệm và tự chịu rủi ro. Các nhà phát triển không chịu trách nhiệm về bất kỳ hậu quả nào phát sinh từ việc sử dụng phần mềm này.

## 📋 Tính Năng

- **ESP Line** - Vẽ đường chỉ về phía người chơi
- **ESP 3D Box** - Vẽ hộp 3D xung quanh người chơi
- **ESP Distance** - Hiển thị khoảng cách đến người chơi
- **Draw All Players** - Hiển thị ESP cho tất cả người chơi (Hunter & Prop)
- **Menu ImGui Hiện Đại** - Giao diện dễ sử dụng
- **Hỗ Trợ Rootless** - Tương thích với jailbreak rootless

## 🎮 Game Hỗ Trợ

- **Hide Online** (`com.hitrock.hideonline`)
- Game Unity IL2CPP

## 📦 Yêu Cầu

- iOS 14.0+
- Thiết bị đã jailbreak (tương thích rootless)
- Môi trường phát triển Theos
- Đã cài đặt game Hide Online

## 🛠️ Cách Build

1. Cài đặt [Theos](https://theos.dev/)
2. Clone repository này:
```bash
git clone https://github.com/x2niosvn/Hide-Online-Unity-ESP-il2cpp.git
cd Hide-Online-Unity-ESP-il2cpp
```

3. Cấu hình IP thiết bị trong `Makefile` (tùy chọn):
```makefile
THEOS_DEVICE_IP = IP_THIET_BI_CUA_BAN
```

4. Build và cài đặt:
```bash
make package install
```

## ⚙️ Cấu Hình

Chỉnh sửa `ESPConfig.h` để tùy chỉnh cài đặt ESP:

```cpp
// Lớp người chơi
#define PLAYER_CLASS_NAME_HUNTER "Hunter"
#define PLAYER_CLASS_NAME_PROP "Prop"
#define PLAYER_ASSEMBLY_NAME "Assembly-CSharp.dll"

// Khoảng cách ESP
#define ESP_MAX_DISTANCE 100.0f

// Màu sắc ESP (RGBA)
#define ESP_LINE_COLOR_R 255
#define ESP_LINE_COLOR_G 0
#define ESP_LINE_COLOR_B 0
#define ESP_LINE_COLOR_A 255
```

## 📱 Cách Sử Dụng

1. Cài đặt tweak trên thiết bị đã jailbreak
2. Khởi động game Hide Online
3. Menu ESP sẽ xuất hiện tự động
4. Bật các tính năng ESP từ menu
5. Tùy chỉnh cài đặt theo nhu cầu

## 🎯 Điều Khiển Menu

- **Tab ESP**: Bật/tắt các tính năng ESP
  - ESP Enable: Công tắc chính cho tất cả tính năng ESP
  - ESP Line: Vẽ đường đến người chơi
  - ESP Box: Vẽ hộp 3D xung quanh người chơi
  - ESP Distance: Hiển thị khoảng cách đến người chơi
  - Draw All Players: Bao gồm tất cả người chơi (không chỉ địch)

## 🏗️ Cấu Trúc Dự Án

```
Hide-Online-Unity-ESP-il2cpp/
├── Esp/              # Các file triển khai ESP
├── IL2CPP/           # Tiện ích hook IL2CPP
├── IMGUI/            # Thư viện ImGui
├── Init/             # Code khởi tạo
├── ESPConfig.h       # File cấu hình
├── ImGuiDrawView.mm  # View vẽ chính
└── Makefile          # Cấu hình build
```

## 🙏 Ghi Công

- **Tác Giả**: [x2niosvn](https://github.com/x2niosvn) (@x2nios)
- **Dự Án Gốc**: [IOS-ESP-AutoUpdate](https://github.com/xS3Cx/IOS-ESP-AutoUpdate) bởi [xS3Cx](https://github.com/xS3Cx)
- **ImGui**: [Dear ImGui](https://github.com/ocornut/imgui)
- **IL2CPP**: Unity IL2CPP runtime

## 📄 Giấy Phép

Dự án này được cấp phép theo MIT License - xem file [LICENSE](LICENSE) để biết thêm chi tiết.

## 📞 Liên Hệ

- **Telegram**: [@x2nios](https://t.me/x2nios)
- **GitHub**: [@x2niosvn](https://github.com/x2niosvn)

## 🔗 Dự Án Liên Quan

- [IOS-ESP-AutoUpdate](https://github.com/xS3Cx/IOS-ESP-AutoUpdate) - Framework ESP cơ sở cho game Unity IL2CPP

---

**Lưu ý**: Dự án này dựa trên công việc tuyệt vời của xS3Cx. Vui lòng ủng hộ dự án gốc!

