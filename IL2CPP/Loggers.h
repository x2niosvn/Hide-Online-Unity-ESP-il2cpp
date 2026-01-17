#pragma once
#include <fstream>
#include <string>
#include <ctime>
#include <sstream>

class Logger {
private:
    static std::ofstream logFile;
    static std::string logPath;
    
    static std::string getCurrentDateTime() {
        std::time_t now = std::time(nullptr);
        std::string timestamp(30, '\0');
        std::strftime(&timestamp[0], timestamp.size(), 
                     "%Y-%m-%d %H:%M:%S", 
                     std::localtime(&now));
        return timestamp;
    }

public:
    static bool init(const std::string& gameName) {
        try {
            // Lấy đường dẫn Documents
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                               NSUserDomainMask, 
                                                               YES);
            NSString *documentsPath = [paths firstObject];
            
            // Tạo thư mục logs nếu chưa tồn tại
            NSString *logsDir = [documentsPath stringByAppendingPathComponent:@"logs"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:logsDir]) {
                [fileManager createDirectoryAtPath:logsDir
                     withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
            }
            
            // Tạo tên file log với timestamp
            std::string timestamp = getCurrentDateTime();
            std::replace(timestamp.begin(), timestamp.end(), ':', '-');
            std::string fileName = gameName + "_" + timestamp + ".log";
            
            // Đường dẫn đầy đủ đến file log
            logPath = std::string([logsDir UTF8String]) + "/" + fileName;
            
            // Mở file để ghi
            logFile.open(logPath, std::ios::out | std::ios::app);
            
            if (!logFile.is_open()) {
                return false;
            }

            log("Logger initialized");
            return true;
            
        } catch (...) {
            return false;
        }
    }
    
    static void log(const std::string& message, const char* level = "INFO") {
        if (!logFile.is_open()) return;
        
        std::stringstream ss;
        ss << "[" << getCurrentDateTime() << "] "
           << "[" << level << "] "
           << message << std::endl;
           
        logFile << ss.str();
        logFile.flush();
    }
    
    static void error(const std::string& message) {
        log(message, "ERROR");
    }
    
    static void warning(const std::string& message) {
        log(message, "WARNING"); 
    }
    
    static void debug(const std::string& message) {
        #ifdef _DEBUG
        log(message, "DEBUG");
        #endif
    }
    
    static std::string getLogPath() {
        return logPath;
    }
    
    static void close() {
        if (logFile.is_open()) {
            log("Logger closed");
            logFile.close();
        }
    }
    
    ~Logger() {
        close();
    }
};

std::ofstream Logger::logFile;
std::string Logger::logPath;