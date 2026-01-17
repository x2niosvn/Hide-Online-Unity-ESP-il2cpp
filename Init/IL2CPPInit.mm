//
//  IL2CPPInit.mm

//
//  Created by AlexZero on 2024
//

#import "IL2CPPInit.h"
#import "IL2CPP/x2nios.h"
#import "Esp/ImGuiDrawView.h"
#import <Foundation/Foundation.h>
#import <os/log.h>
#import "pthread.h"
#include <math.h>
#include <deque>
#include <vector>
#include <fstream>
// #include "oxorany/oxorany_include.h" // Disabled - oxorany removed
#include "IMGUI/imgui.h"
#include "IMGUI/imgui_internal.h"
#include "IMGUI/Il2cpp.h"
#include <vector>
#import <dlfcn.h>
#include <map>
#include <set>
#include <algorithm>
#include <string>
#import <QuartzCore/QuartzCore.h>
#include <unistd.h>
#include <string.h>

// ===== Startup function check state =====
static bool g_hasRunFunctionCheck = false;
static bool g_functionCheckDone = false;
static bool g_functionCheckPassed = false;
static bool g_userConsentedPartial = false;
static int  g_checkStep = 0;
static const int g_preCheckSteps = 2; // 0: Attach, 1: Verify IL2CPP pointers
static const char* g_currentCheckLabel = "";
static float g_lastStepTime = 0.0f;
static bool g_precheckCompleted = false; // Track if precheck has been completed
static bool g_menuReady = false; // Track if menu is ready to show

struct MethodCheck {
    const char* image;
    const char* namespaze;
    const char* clazz;
    const char* method;
    int argsCount;
    const char* label;
};

static const MethodCheck g_methodChecks[] = {
    {"mscorlib.dll", "System", "Type", "GetType", 1, "System.Type.GetType"},
    {"mscorlib.dll", "System", "String", "CreateString", 3, "System.String.CreateString"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Object", "FindObjectsOfType", 1, "Object.FindObjectsOfType"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "get_activeInHierarchy", 0, "GameObject.activeInHierarchy"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "GetComponentsInternal", 6, "GameObject.GetComponentsInternal"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "get_transform", 0, "GameObject.transform"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_childCount", 0, "Transform.childCount"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "GetChild", 1, "Transform.GetChild"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "TransformPoint", 1, "Transform.TransformPoint"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_allCameras", 0, "Camera.allCameras"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToViewportPoint", 1, "Camera.WorldToViewportPoint"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToScreenPoint", 1, "Camera.WorldToScreenPoint"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_worldToCameraMatrix", 0, "Camera.worldToCameraMatrix"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_projectionMatrix", 0, "Camera.projectionMatrix"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_main", 0, "Camera.main"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Component", "get_gameObject", 0, "Component.gameObject"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Component", "get_transform", 0, "Component.transform"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_position", 0, "Transform.position"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_parent", 0, "Transform.parent"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Renderer", "get_bounds", 0, "Renderer.bounds"},
    {"UnityEngine.PhysicsModule.dll", "UnityEngine", "Collider", "get_bounds", 0, "Collider.bounds"},
    {"UnityEngine.PhysicsModule.dll", "UnityEngine", "Physics", "Raycast", 3, "Physics.Raycast"},
    {"UnityEngine.PhysicsModule.dll", "UnityEngine", "Rigidbody", "get_velocity", 0, "Rigidbody.velocity"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_forward", 0, "Transform.forward"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "SkinnedMeshRenderer", "get_bones", 0, "SkinnedMeshRenderer.bones"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Object", "GetName", 1, "Object.GetName"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "Object", "ToString", 1, "Object.ToString"},
    {"UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "GetInstanceID", 0, "GameObject.GetInstanceID"}
};

static const int g_methodsCount = (int)(sizeof(g_methodChecks) / sizeof(g_methodChecks[0]));
static std::vector<std::string> g_checkFailures;

static void runFunctionCheckOneStep() {
    using namespace IL2Cpp;
    // Step 0: Attach
    if (g_checkStep == 0) {
        g_currentCheckLabel = "Attach il2cpp symbols";
        IL2Cpp::Attach();
        g_checkStep++;
        return;
    }
    // Step 1: verify core il2cpp pointers
    if (g_checkStep == 1) {
        g_currentCheckLabel = "Verify IL2CPP core pointers";
        struct PtrCheck { void* ptr; const char* name; };
        PtrCheck ptrs[] = {
            {(void*)il2cpp_domain_get, "il2cpp_domain_get"},
            {(void*)il2cpp_domain_get_assemblies, "il2cpp_domain_get_assemblies"},
            {(void*)il2cpp_assembly_get_image, "il2cpp_assembly_get_image"},
            {(void*)il2cpp_image_get_name, "il2cpp_image_get_name"},
            {(void*)il2cpp_class_from_name, "il2cpp_class_from_name"},
            {(void*)il2cpp_class_get_method_from_name, "il2cpp_class_get_method_from_name"},
            {(void*)il2cpp_class_get_field_from_name, "il2cpp_class_get_field_from_name"},
            {(void*)il2cpp_field_get_offset, "il2cpp_field_get_offset"}
        };
        for (auto &p : ptrs) {
            if (p.ptr == nullptr) {
                g_checkFailures.push_back(std::string("Missing core: ") + p.name);
            }
        }
        g_checkStep++;
        return;
    }
    // Steps 2..: verify Unity methods via GetMethodOffset
    int idx = g_checkStep - g_preCheckSteps;
    if (idx >= 0 && idx < g_methodsCount) {
        const MethodCheck &mc = g_methodChecks[idx];
        g_currentCheckLabel = mc.label;
        const void* off = IL2Cpp::GetMethodOffset(mc.image, mc.namespaze, mc.clazz, mc.method, mc.argsCount);
        if (off == nullptr) {
            g_checkFailures.push_back(std::string("Missing method: ") + mc.label);
        }
        g_checkStep++;
        return;
    }
    // Completed
    g_functionCheckDone = true;
    g_functionCheckPassed = g_checkFailures.empty();
}

std::string string_format(const char* fmt, ...) {
    std::vector<char> str(100,'\0');
    va_list ap;
    while (1) {
        va_start(ap, fmt);
        auto n = vsnprintf(str.data(), str.size(), fmt, ap);
        va_end(ap);
        if ((n > -1) && (size_t(n) < str.size())) {
            return str.data();
        }
        if (n > -1)
            str.resize( n + 1 );
        else
            str.resize( str.size() * 2);
    }
    return str.data();
}

// ===================== ImGui Initialization Overlay =====================
static bool s_showInitOverlay = false;
static double s_overlayStartTime = 0.0;
static double s_minOverlayDuration = 1.25; // seconds
static int s_dotCount = 0;
static double s_lastDotTime = 0.0;

@implementation IL2CPPInit

+ (void)startPrecheck {
    // If precheck is already completed, just show the menu directly
    if (g_precheckCompleted && g_menuReady) {
        [ImGuiDrawView showChange:true];
        return;
    }
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self startPrecheck]; });
        return;
    }

    // Show ImGui overlay
    s_showInitOverlay = true;
    s_overlayStartTime = CACurrentMediaTime();
    s_lastDotTime = s_overlayStartTime;
    s_dotCount = 0;

    // Reset checker state
    g_hasRunFunctionCheck = true;
    g_checkStep = 0;
    g_checkFailures.clear();
    g_functionCheckDone = false;
    g_functionCheckPassed = false;
    g_userConsentedPartial = false;
    g_lastStepTime = 0.0f;

    // Start ImGuiDrawView to show overlay
    [ImGuiDrawView showChange:true];
}

// ImGui-based initialization progress - handled in ImGuiDrawView
+ (void)updateInitializationProgress {
    if (!s_showInitOverlay) return;
    
    const int totalSteps = g_preCheckSteps + g_methodsCount;
    double now = CACurrentMediaTime();
    
    // animate dots in label every 0.25s
    if (now - s_lastDotTime > 0.25) { 
        s_dotCount = (s_dotCount % 3) + 1; 
        s_lastDotTime = now; 
    }
    
    if (!g_functionCheckDone) {
        runFunctionCheckOneStep();
        return;
    }

    // ensure minimum duration and smooth finish
    double elapsed = now - s_overlayStartTime;
    if (elapsed < s_minOverlayDuration) {
        return;
    }

    // Hide overlay and proceed to menu
    s_showInitOverlay = false;
    g_precheckCompleted = true;
    g_menuReady = true;
    
    // Force ImGui to redraw and show main menu
    dispatch_async(dispatch_get_main_queue(), ^{
        // Menu will automatically show due to isInitializationComplete check
    });
}

+ (void)showMenuDirectly {
    if (g_precheckCompleted && g_menuReady) {
        [ImGuiDrawView showChange:true];
    } else {
        // If precheck not completed, run it first
        [self startPrecheck];
    }
}

+ (void)resetPrecheckState {
    g_precheckCompleted = false;
    g_menuReady = false;
    g_hasRunFunctionCheck = false;
    g_functionCheckDone = false;
    g_functionCheckPassed = false;
    g_userConsentedPartial = false;
    g_checkStep = 0;
    g_checkFailures.clear();
}

// ImGui initialization status functions
+ (bool)isShowingInitOverlay {
    return s_showInitOverlay;
}

+ (const char*)getCurrentCheckLabel {
    return g_currentCheckLabel;
}

+ (float)getInitializationProgress {
    const int totalSteps = g_preCheckSteps + g_methodsCount;
    if (totalSteps <= 0) return 1.0f;
    return (float)std::min(g_checkStep, totalSteps) / (float)totalSteps;
}

+ (int)getDotCount {
    return s_dotCount;
}

+ (bool)isInitializationComplete {
    return g_precheckCompleted && g_menuReady;
}

+ (bool)hasInitializationFailures {
    return !g_checkFailures.empty();
}

+ (const std::vector<std::string>&)getInitializationFailures {
    return g_checkFailures;
}

// Game info methods
+ (NSString *)getGameBundleIdentifier {
    @autoreleasepool {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *bundleId = [mainBundle bundleIdentifier];
        if (bundleId) {
            return bundleId;
        }
        return @"Unknown";
    }
}

+ (NSString *)getGameVersion {
    @autoreleasepool {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *version = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (version) {
            return version;
        }
        
        // Fallback na CFBundleVersion
        NSString *buildVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
        if (buildVersion) {
            return buildVersion;
        }
        
        return @"Unknown";
    }
}

+ (NSString *)getGameDisplayName {
    @autoreleasepool {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *displayName = [mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (displayName) {
            return displayName;
        }
        
        // Fallback na CFBundleName
        NSString *bundleName = [mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
        if (bundleName) {
            return bundleName;
        }
        
        return @"Unknown Game";
    }
}

@end

// ===== IL2CPP Initialization at startup =====
void hooking(){
}

void *hack_thread(void *) {
    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}
