#import "Esp/ImGuiDrawView.h"
#import "Init/IL2CPPInit.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include "IMGUI/imgui.h"
#include "IMGUI/imgui_internal.h"
#include "IMGUI/imgui_impl_metal.h"
#include "IMGUI/zzz.h"
#include "IMGUI/Il2cpp.h"
#include <vector>
#include <string>
#define oxorany(x) x
#include "IL2CPP/Vector3.h"
#include "IL2CPP/Vector2.h"
#include "IL2CPP/Vector4.h"
#include "IL2CPP/Quaternion.h"
#include "IL2CPP/Matrix4x4.h"
#include "IL2CPP/Monostring.h"
#include "ESPConfig.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#include "IL2CPP/Hooks.h"
#import <Foundation/Foundation.h>
#import <os/log.h>
#import "pthread.h"
#include <math.h>
#include <deque>
#include <vector>
#include <fstream>
#include <vector>
#import <dlfcn.h>
#include <map>
#include <set>
#include <algorithm>
#include <string>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <unistd.h>
#include <string.h>
#include <float.h>
ImFont* verdana_smol;
#define kScale [UIScreen mainScreen].scale
static void* selectedCamera = nullptr;
static bool espInitialized = false;
static bool esp_line = false;
static bool esp_distance_enabled = false;
static bool esp_box_2d = false;
static bool esp_box_3d = false;
static bool esp_corners = false;
static int esp_line_position = 1;
static bool esp_draw_all_players = false;
std::string decodeBase64(const char* encoded) {
    NSString *encodedStr = [NSString stringWithUTF8String:encoded];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encodedStr options:0];
    if (decodedData) {
        NSString *decodedStr = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        return std::string([decodedStr UTF8String]);
    }
    return std::string(encoded);
}
bool isInBattle() {
    const char* playerClassNames[] = {PLAYER_CLASS_NAME_HUNTER, PLAYER_CLASS_NAME_PROP};
    int numClasses = sizeof(playerClassNames) / sizeof(playerClassNames[0]);
    for (int classIdx = 0; classIdx < numClasses; classIdx++) {
        std::string typeString = std::string(playerClassNames[classIdx]) + ", " + std::string(PLAYER_ASSEMBLY_NAME);
        void* playerRootType = Type_GetType(String_CreateString(typeString.c_str()));
        if (!playerRootType) continue;
        monoArray<void**>* playerList = Object_FindObjectsOfType(playerRootType);
        if (!playerList) continue;
        for (int i = 0; i < playerList->getLength(); i++) {
            void* object = playerList->getPointer()[i];
            if (!object) continue;
            void* gameObject = Component_get_gameObject(object);
            if (!gameObject) continue;
            if (!GameObject_get_activeInHierarchy(gameObject)) continue;
            void* transform = Component_get_transform(object);
            if (!transform) continue;
            Vector3 position = Transform_get_position(transform);
            if (position.x == 0 && position.y == 0 && position.z == 0) continue;
            return true;
        }
    }
    return false;
}
void* getMainCamera() {
    static int lastCheckFrame = 0;
    static int frameCount = 0;
    frameCount++;
    if (!selectedCamera || frameCount - lastCheckFrame > 30) {
        lastCheckFrame = frameCount;
        void* mainCam = Camera_get_main();
        if (mainCam) {
            void* transform = Component_get_transform(mainCam);
            if (transform) {
                Vector3 pos = Transform_get_position(transform);
                if (pos.x != 0 || pos.y != 0 || pos.z != 0) {
                    selectedCamera = mainCam;
                    return selectedCamera;
                }
            }
        }
        void* CameraType = Type_GetType(String_CreateString("UnityEngine.Camera, UnityEngine.CoreModule.dll"));
        if (CameraType) {
            monoArray<void**>* allCameras = Object_FindObjectsOfType(CameraType);
            if (allCameras) {
                void* bestCamera = nullptr;
                for (int i = 0; i < allCameras->getLength(); i++) {
                    void* cam = allCameras->getPointer()[i];
                    if (!cam) continue;
                    void* gameObject = Component_get_gameObject(cam);
                    if (!gameObject) continue;
                    if (!GameObject_get_activeInHierarchy(gameObject)) continue;
                    void* transform = Component_get_transform(cam);
                    if (!transform) continue;
                    Vector3 pos = Transform_get_position(transform);
                    if (pos.x == 0 && pos.y == 0 && pos.z == 0) continue;
                    if (!bestCamera) {
                        bestCamera = cam;
                    }
                }
                if (bestCamera) {
                    selectedCamera = bestCamera;
    return selectedCamera;
                }
            }
        }
    }
    return selectedCamera;
}
int getLocalPlayerType() {
    static int cachedType = -1;
    static int lastCheckFrame = 0;
    static int frameCounter = 0;
    frameCounter++;
    if (cachedType >= 0 && frameCounter - lastCheckFrame < 120) {
        return cachedType;
    }
    lastCheckFrame = frameCounter;
    cachedType = -1;
    std::string hunterTypeString = std::string(PLAYER_CLASS_NAME_HUNTER) + ", " + std::string(PLAYER_ASSEMBLY_NAME);
    void* hunterType = Type_GetType(String_CreateString(hunterTypeString.c_str()));
    if (hunterType) {
        monoArray<void**>* hunterList = Object_FindObjectsOfType(hunterType);
        if (hunterList) {
            for (int i = 0; i < hunterList->getLength(); i++) {
                void* hunterObj = hunterList->getPointer()[i];
                if (!hunterObj) continue;
                void* gameObject = Component_get_gameObject(hunterObj);
                if (!gameObject || !GameObject_get_activeInHierarchy(gameObject)) continue;
                if (Hunter_get_IsLocallyControlled(hunterObj)) {
                    cachedType = 0; 
                    return cachedType;
                }
            }
        }
    }
    std::string propTypeString = std::string(PLAYER_CLASS_NAME_PROP) + ", " + std::string(PLAYER_ASSEMBLY_NAME);
    void* propType = Type_GetType(String_CreateString(propTypeString.c_str()));
    if (propType) {
        monoArray<void**>* propList = Object_FindObjectsOfType(propType);
        if (propList) {
            void* camera = getMainCamera();
            Vector3 cameraPos;
            if (camera && isCameraValid(camera)) {
                cameraPos = Transform_get_position(Component_get_transform(camera));
            }
            void* closestProp = nullptr;
            float minDist = FLT_MAX;
            for (int i = 0; i < propList->getLength(); i++) {
                void* propObj = propList->getPointer()[i];
                if (!propObj) continue;
                void* gameObject = Component_get_gameObject(propObj);
                if (!gameObject || !GameObject_get_activeInHierarchy(gameObject)) continue;
                if (camera && isCameraValid(camera)) {
                    void* transform = Component_get_transform(propObj);
                    if (transform) {
                        Vector3 pos = Transform_get_position(transform);
                        if (pos.x != 0 || pos.y != 0 || pos.z != 0) {
                            float dist = Vector3::Distance(cameraPos, pos);
                            if (dist < minDist && dist < 20.0f) {
                                minDist = dist;
                                closestProp = propObj;
                            }
                        }
                    }
                }
            }
            if (closestProp && minDist < 20.0f) {
                cachedType = 1; 
                return cachedType;
            }
        }
    }
    return cachedType;
}
void updateESPVariables(bool line, bool distance, int linePos, bool box2d, bool box3d, bool corners) {
    esp_line = line;
    esp_distance_enabled = distance;
    esp_line_position = linePos;
    esp_box_2d = box2d;
    esp_box_3d = box3d;
    esp_corners = corners;
}
struct PlayerData {
    void* object;
    void* gameObject;
    void* transform;
    Vector3 position;
    Vector3 w2sPosition;
    bool isVisible;
    float distance;
    int playerKind; 
    bool isLocalPlayer; 
    PlayerData() : object(nullptr), gameObject(nullptr), transform(nullptr), 
                   isVisible(false), distance(0.0f), playerKind(-1), isLocalPlayer(false) {}
};
int drawPlayerRootESP(ImDrawList* draw_list) {
    if (!isInBattle()) {
        return 0;
    }
    void* camera = getMainCamera();
    if (!isCameraValid(camera)) {
        return 0;
    }
    Vector3 cameraPosition = Transform_get_position(Component_get_transform(camera));
    bool shouldDrawESP = (esp_line || esp_distance_enabled || esp_box_2d || esp_box_3d || esp_corners);
    if (shouldDrawESP) {
        const char* playerClassNames[2];
        int numClasses = 0;
        if (esp_draw_all_players) {
            playerClassNames[0] = PLAYER_CLASS_NAME_HUNTER;
            playerClassNames[1] = PLAYER_CLASS_NAME_PROP;
            numClasses = 2;
        } else {
            int localPlayerType = getLocalPlayerType();
            if (localPlayerType == 0) {
                playerClassNames[0] = PLAYER_CLASS_NAME_PROP;
                numClasses = 1;
            } else if (localPlayerType == 1) {
                playerClassNames[0] = PLAYER_CLASS_NAME_HUNTER;
                numClasses = 1;
            } else {
                playerClassNames[0] = PLAYER_CLASS_NAME_HUNTER;
                playerClassNames[1] = PLAYER_CLASS_NAME_PROP;
                numClasses = 2;
            }
        }
        for (int classIdx = 0; classIdx < numClasses; classIdx++) {
            std::string typeString = std::string(playerClassNames[classIdx]) + ", " + std::string(PLAYER_ASSEMBLY_NAME);
            void* playerRootType = Type_GetType(String_CreateString(typeString.c_str()));
            if (!playerRootType) {
                continue;
            }
            monoArray<void**>* playerList = Object_FindObjectsOfType(playerRootType);
            if (!playerList) {
                continue;
            }
            int playerCount = playerList->getLength();
            std::vector<PlayerData> validPlayers;
            validPlayers.reserve(playerCount);
            for (int i = 0; i < playerCount; i++) {
                    void* object = playerList->getPointer()[i];
                    if (!object) continue;
                PlayerData playerData;
                playerData.object = object;
                playerData.gameObject = Component_get_gameObject(object);
                if (!playerData.gameObject) continue;
                if (!GameObject_get_activeInHierarchy(playerData.gameObject)) continue;
                playerData.transform = Component_get_transform(object);
                if (!playerData.transform) continue;
                playerData.position = Transform_get_position(playerData.transform);
                if (playerData.position.x == 0 && playerData.position.y == 0 && playerData.position.z == 0) continue;
                playerData.distance = Vector3::Distance(cameraPosition, playerData.position);
                if (classIdx == 0 && std::string(playerClassNames[classIdx]) == PLAYER_CLASS_NAME_HUNTER) {
                    playerData.isLocalPlayer = Hunter_get_IsLocallyControlled(object);
                }
                WorldToScreen(camera, playerData.position, playerData.w2sPosition, playerData.isVisible);
                if (playerData.isVisible) {
                    playerData.playerKind = (std::string(playerClassNames[classIdx]) == PLAYER_CLASS_NAME_HUNTER) ? 0 : 1;
                    validPlayers.push_back(playerData);
                }
            }
            for (const auto& playerData : validPlayers) {
                if (playerData.isLocalPlayer) continue;
                if (shouldDrawESP) {
        if (esp_line) {
            ImVec2 start, target;
            switch (esp_line_position) {
                case 0: start = ImVec2(kWidth * 0.5f, 5.0f); break;
                case 1: start = ImVec2(kWidth * 0.5f, kHeight * 0.5f); break;
                default: start = ImVec2(kWidth * 0.5f, kHeight - 5.0f); break;
            }
                        target = ImVec2(playerData.w2sPosition.x, playerData.w2sPosition.y);
                        ImU32 lineColor = IM_COL32(255, 255, 255, 255);
            float lineThickness = ESP_LINE_THICKNESS;
            draw_list->AddLine(start, target, lineColor, lineThickness);
        }
        if (esp_box_2d || esp_box_3d || esp_corners) {
                        Vector3 c = playerData.position;
                        float distance = playerData.distance;
                        float baseHeight = 0.9f;  
                        float baseWidth = 0.4f;   
                        float baseDepth = 0.4f;   
                        float distanceScale = std::max(0.5f, std::min(1.0f, 1.0f - (distance - 5.0f) * 0.02f));
                        Vector3 e = Vector3(
                            baseWidth * distanceScale,
                            baseHeight * distanceScale,
                            baseDepth * distanceScale
                        );
                        e.x = std::max(0.2f, std::min(e.x, 1.5f));
                        e.y = std::max(0.4f, std::min(e.y, 2.0f));
                        e.z = std::max(0.2f, std::min(e.z, 1.5f));
            float dynamicThickness = std::max(0.8f, 1.2f - (distance * 0.02f));
            float alpha = std::max(0.7f, 1.0f - (distance * 0.01f));
            ImU32 boxColor = IM_COL32(255, 255, 255, (int)(255 * alpha));
            Vector3 corners3D[8] = {
                Vector3(c.x - e.x, c.y - e.y, c.z - e.z),
                Vector3(c.x + e.x, c.y - e.y, c.z - e.z),
                Vector3(c.x + e.x, c.y - e.y, c.z + e.z),
                Vector3(c.x - e.x, c.y - e.y, c.z + e.z),
                Vector3(c.x - e.x, c.y + e.y, c.z - e.z),
                Vector3(c.x + e.x, c.y + e.y, c.z - e.z),
                Vector3(c.x + e.x, c.y + e.y, c.z + e.z),
                Vector3(c.x - e.x, c.y + e.y, c.z + e.z)
            };
            ImVec2 pts[8];
            bool cornerVisible[8];
            int visibleCorners = 0;
            for (int k = 0; k < 8; k++) {
                Vector3 sp; bool vis;
                WorldToScreen(camera, corners3D[k], sp, vis);
                pts[k] = ImVec2(sp.x, sp.y);
                cornerVisible[k] = vis;
                if (vis) visibleCorners++;
            }
            if (visibleCorners >= 3) {
                float minX = FLT_MAX, maxX = -FLT_MAX, minY = FLT_MAX, maxY = -FLT_MAX;
                for (int k = 0; k < 8; k++) {
                    if (cornerVisible[k]) {
                        minX = std::min(minX, pts[k].x);
                        maxX = std::max(maxX, pts[k].x);
                        minY = std::min(minY, pts[k].y);
                        maxY = std::max(maxY, pts[k].y);
                    }
                }
                float boxHeight = maxY - minY;
                float boxWidth = maxX - minX;
                if (esp_box_2d) {
                    ImVec2 playerFeetPos(playerData.w2sPosition.x, playerData.w2sPosition.y);
                    ImVec2 boxCenter(playerFeetPos.x, playerFeetPos.y - boxHeight * 0.5f);
                    ImVec2 corners[4] = {
                        ImVec2(boxCenter.x - boxWidth * 0.5f, boxCenter.y - boxHeight * 0.5f),
                        ImVec2(boxCenter.x + boxWidth * 0.5f, boxCenter.y - boxHeight * 0.5f),
                        ImVec2(boxCenter.x + boxWidth * 0.5f, boxCenter.y + boxHeight * 0.5f),
                        ImVec2(boxCenter.x - boxWidth * 0.5f, boxCenter.y + boxHeight * 0.5f)
                    };
                    for (int j = 0; j < 4; j++) {
                        int next = (j + 1) % 4;
                        draw_list->AddLine(corners[j], corners[next], boxColor, dynamicThickness);
                    }
                }
                if (esp_box_3d) {
                    Vector3 adjustedCenter = Vector3(playerData.position.x, playerData.position.y + e.y, playerData.position.z);
                    Vector3 corners3D_adjusted[8] = {
                        Vector3(adjustedCenter.x - e.x, adjustedCenter.y - e.y, adjustedCenter.z - e.z),
                        Vector3(adjustedCenter.x + e.x, adjustedCenter.y - e.y, adjustedCenter.z - e.z),
                        Vector3(adjustedCenter.x + e.x, adjustedCenter.y - e.y, adjustedCenter.z + e.z),
                        Vector3(adjustedCenter.x - e.x, adjustedCenter.y - e.y, adjustedCenter.z + e.z),
                        Vector3(adjustedCenter.x - e.x, adjustedCenter.y + e.y, adjustedCenter.z - e.z),
                        Vector3(adjustedCenter.x + e.x, adjustedCenter.y + e.y, adjustedCenter.z - e.z),
                        Vector3(adjustedCenter.x + e.x, adjustedCenter.y + e.y, adjustedCenter.z + e.z),
                        Vector3(adjustedCenter.x - e.x, adjustedCenter.y + e.y, adjustedCenter.z + e.z)
                    };
                    ImVec2 pts_adjusted[8];
                    bool cornerVisible_adjusted[8];
                    int visibleCorners_adjusted = 0;
                    for (int k = 0; k < 8; k++) {
                        Vector3 sp; bool vis;
                        WorldToScreen(camera, corners3D_adjusted[k], sp, vis);
                        pts_adjusted[k] = ImVec2(sp.x, sp.y);
                        cornerVisible_adjusted[k] = vis;
                        if (vis) visibleCorners_adjusted++;
                    }
                    if (visibleCorners_adjusted >= 3) {
                        int edges[12][2] = {
                            {0,1}, {1,2}, {2,3}, {3,0},
                            {4,5}, {5,6}, {6,7}, {7,4},
                            {0,4}, {1,5}, {2,6}, {3,7}
                        };
                        for (int eidx = 0; eidx < 12; eidx++) {
                            int a = edges[eidx][0];
                            int b = edges[eidx][1];
                            if (cornerVisible_adjusted[a] && cornerVisible_adjusted[b]) {
                                draw_list->AddLine(pts_adjusted[a], pts_adjusted[b], boxColor, dynamicThickness);
                            }
                        }
                    }
                }
                if (esp_corners) {
                    float cornerWidth = boxWidth;
                    float cornerHeight = boxHeight;
                    ImVec2 playerFeetPos(playerData.w2sPosition.x, playerData.w2sPosition.y);
                    ImVec2 cornerCenter(playerFeetPos.x, playerFeetPos.y - cornerHeight * 0.5f);
                    ImVec2 corners[4] = {
                        ImVec2(cornerCenter.x - cornerWidth * 0.5f, cornerCenter.y - cornerHeight * 0.5f),
                        ImVec2(cornerCenter.x + cornerWidth * 0.5f, cornerCenter.y - cornerHeight * 0.5f),
                        ImVec2(cornerCenter.x + cornerWidth * 0.5f, cornerCenter.y + cornerHeight * 0.5f),
                        ImVec2(cornerCenter.x - cornerWidth * 0.5f, cornerCenter.y + cornerHeight * 0.5f)
                    };
                    float cornerLength = std::max(10.0f, std::min(cornerWidth, cornerHeight) * 0.3f);
                    draw_list->AddLine(corners[0], ImVec2(corners[0].x + cornerLength, corners[0].y), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[0], ImVec2(corners[0].x, corners[0].y + cornerLength), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[1], ImVec2(corners[1].x - cornerLength, corners[1].y), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[1], ImVec2(corners[1].x, corners[1].y + cornerLength), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[2], ImVec2(corners[2].x - cornerLength, corners[2].y), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[2], ImVec2(corners[2].x, corners[2].y - cornerLength), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[3], ImVec2(corners[3].x + cornerLength, corners[3].y), boxColor, dynamicThickness);
                    draw_list->AddLine(corners[3], ImVec2(corners[3].x, corners[3].y - cornerLength), boxColor, dynamicThickness);
                }
                if (esp_box_2d || esp_box_3d || esp_corners) {
                            ImVec2 playerFeetPos(playerData.w2sPosition.x, playerData.w2sPosition.y);
                            ImVec2 boxTopCenter(playerFeetPos.x, playerFeetPos.y - boxHeight * 0.5f);
                    std::string playerName = std::string(playerClassNames[classIdx]);
                    ImVec2 textSize = ImGui::CalcTextSize(playerName.c_str());
                    float nameX = boxTopCenter.x - textSize.x * 0.5f;
                    float nameY = boxTopCenter.y - boxHeight * 0.5f - textSize.y - 5.0f;
                    draw_list->AddRectFilled(
                        ImVec2(nameX - 3, nameY - 2),
                        ImVec2(nameX + textSize.x + 3, nameY + textSize.y + 2),
                        IM_COL32(0, 0, 0, 180),
                        2.0f
                    );
                    draw_list->AddText(
                        ImVec2(nameX, nameY),
                        IM_COL32(255, 255, 255, 255),
                        playerName.c_str()
                    );
                }
            }
        }
                    if (esp_distance_enabled) {
                        std::string distanceStr = std::to_string((int)playerData.distance) + "M";
                        ImU32 distanceColor = ESP_DISTANCE_COLOR;
                        draw_list->AddText(ImVec2(playerData.w2sPosition.x + 5, playerData.w2sPosition.y - 10), distanceColor, distanceStr.c_str());
                    }
                }
            }
        }
    }
    return 0;
}
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end
@implementation ImGuiDrawView
static bool show_s0 = false;
static bool MenDeal = true;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    if (!self.device) abort();
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();
    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowRounding = 0.0f;
    style.ChildRounding = 0.0f;
    style.FrameRounding = 0.0f;
    style.PopupRounding = 0.0f;
    style.ScrollbarRounding = 0.0f;
    style.GrabRounding = 0.0f;
    style.TabRounding = 0.0f;
    style.WindowBorderSize = 0.0f;
    style.ChildBorderSize = 0.0f;
    style.PopupBorderSize = 0.0f;
    style.FrameBorderSize = 0.0f;
    ImVec4* colors = style.Colors;
    colors[ImGuiCol_WindowBg] = ImVec4(0.08f, 0.05f, 0.12f, 0.94f); 
    colors[ImGuiCol_ChildBg] = ImVec4(0.06f, 0.04f, 0.10f, 0.94f);
    colors[ImGuiCol_PopupBg] = ImVec4(0.10f, 0.07f, 0.15f, 0.94f);
    colors[ImGuiCol_Border] = ImVec4(0.30f, 0.20f, 0.40f, 0.50f);
    colors[ImGuiCol_FrameBg] = ImVec4(0.15f, 0.10f, 0.20f, 1.0f);
    colors[ImGuiCol_FrameBgHovered] = ImVec4(0.20f, 0.15f, 0.30f, 1.0f);
    colors[ImGuiCol_FrameBgActive] = ImVec4(0.25f, 0.18f, 0.35f, 1.0f);
    colors[ImGuiCol_TitleBg] = ImVec4(0.12f, 0.08f, 0.18f, 1.0f);
    colors[ImGuiCol_TitleBgActive] = ImVec4(0.40f, 0.20f, 0.60f, 1.0f);
    colors[ImGuiCol_CheckMark] = ImVec4(0.60f, 0.30f, 0.90f, 1.0f);
    colors[ImGuiCol_Button] = ImVec4(0.40f, 0.20f, 0.60f, 0.60f);
    colors[ImGuiCol_ButtonHovered] = ImVec4(0.50f, 0.30f, 0.70f, 0.80f);
    colors[ImGuiCol_ButtonActive] = ImVec4(0.60f, 0.40f, 0.80f, 1.0f);
    colors[ImGuiCol_Header] = ImVec4(0.40f, 0.20f, 0.60f, 0.40f);
    colors[ImGuiCol_HeaderHovered] = ImVec4(0.50f, 0.30f, 0.70f, 0.60f);
    colors[ImGuiCol_HeaderActive] = ImVec4(0.60f, 0.40f, 0.80f, 0.80f);
    colors[ImGuiCol_Tab] = ImVec4(0.15f, 0.10f, 0.20f, 1.0f);
    colors[ImGuiCol_TabHovered] = ImVec4(0.50f, 0.30f, 0.70f, 0.60f);
    colors[ImGuiCol_TabActive] = ImVec4(0.40f, 0.20f, 0.60f, 1.0f);
    colors[ImGuiCol_Text] = ImVec4(0.95f, 0.90f, 1.0f, 1.0f);
    ImFont* font = io.Fonts->AddFontFromMemoryCompressedTTF((void*)zzz_compressed_data, zzz_compressed_size, 60.0f, NULL, io.Fonts->GetGlyphRangesVietnamese());
    ImGui_ImplMetal_Init(_device);
    return self;
}
+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}
- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}
- (void)loadView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor clearColor];
    self.mtkView.clipsToBounds = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [IL2CPPInit startPrecheck];
    });
}
#pragma mark - Interaction
- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}
#pragma mark - Initialization Overlay
- (void)drawInitializationOverlay {
}
#pragma mark - MTKViewDelegate
- (void)drawInMTKView:(MTKView*)view
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    static bool esp_enabled = false;
    static bool esp_box_2d = false;
    static bool esp_box_3d = true; 
    static bool esp_corners = false;
        if (MenDeal == true) {
            [self.view setUserInteractionEnabled:YES];
        } else if (MenDeal == false) {
            [self.view setUserInteractionEnabled:NO];
        }
        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];
            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            [IL2CPPInit updateInitializationProgress];
            if ([IL2CPPInit isShowingInitOverlay] && ![IL2CPPInit isInitializationComplete]) {
            }
            ImFont* font = ImGui::GetFont();
            if (font && font->FontSize > 0) {
                font->Scale = 15.f / font->FontSize;
            }
            CGFloat x = (([UIScreen mainScreen].bounds.size.width) - 300) / 2;
            CGFloat y = (([UIScreen mainScreen].bounds.size.height) - 200) / 2;
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(300, 200), ImGuiCond_FirstUseEver);
            if (MenDeal == true && [IL2CPPInit isInitializationComplete])
            {                
                std::string menuTitle = std::string("IOSTUTS | ") + decodeBase64("WDJOSU9T") + std::string(" | HIDE ONLINE ESP");
                ImGui::Begin(menuTitle.c_str(), &MenDeal, ImGuiWindowFlags_NoResize);
                if (ImGui::BeginTabBar("MainTabBar"))
                {
                    if (ImGui::BeginTabItem("ESP"))
                    {
                        ImGui::Checkbox("ESP Enable", &esp_enabled);
                        ImGui::Separator();
                        if (esp_enabled) {
                            ImGui::Checkbox("ESP Line", &esp_line);
                            esp_line_position = 1;
                            ImGui::Checkbox("ESP Box", &esp_box_3d);
                                esp_box_2d = false;
                                esp_corners = false;
                            ImGui::Checkbox("ESP Distance", &esp_distance_enabled);
                            ImGui::Checkbox("Draw All Players", &esp_draw_all_players);
                            updateESPVariables(esp_line, esp_distance_enabled, esp_line_position, esp_box_2d, esp_box_3d, esp_corners);
                        }
                        ImGui::EndTabItem();
                    }
                    if (ImGui::BeginTabItem("Info")) {
                        ImGui::Text("Made with love by @x2nios");
                        ImGui::Text("Telegram: @x2nios");
                        ImGui::EndTabItem();
                    }
                    }
                    ImGui::EndTabBar();
                ImGui::End();
            }
            ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
            float topCenterX = kWidth * 0.5f;
            float topY = 35.0f; 
            std::string brandText = decodeBase64("WDJOSU9T");
            ImVec2 brandTextSize = ImGui::CalcTextSize(brandText.c_str());
            float brandX = topCenterX - brandTextSize.x * 0.5f;
            float brandY = topY;
            for (int offsetX = -2; offsetX <= 2; offsetX++) {
                for (int offsetY = -2; offsetY <= 2; offsetY++) {
                    if (offsetX != 0 || offsetY != 0) {
                        draw_list->AddText(
                            ImVec2(brandX + offsetX, brandY + offsetY),
                            IM_COL32(0, 0, 0, 255),
                            brandText.c_str()
                        );
                    }
                }
            }
            draw_list->AddText(ImVec2(brandX, brandY), IM_COL32(138, 43, 226, 255), brandText.c_str());
            if (esp_enabled) {
                drawPlayerRootESP(draw_list);
            }
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];
            [commandBuffer presentDrawable:view.currentDrawable];
        }
        [commandBuffer commit];
}
- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
}
@end
