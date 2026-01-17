#import "Loggers.h"
#include "ext.h"
#include "../ESPConfig.h"

// IL2CPP Class Metadata Structure
struct Il2CppClassMetadata
{
    void* image; // 0x0
    void* gc_desc; // 0x8
    const char* name; // 0x10
    const char* namespaze; // 0x18
};

// IL2CPP Hook Functions - Only used functions
void *Type_GetType(monoString *instance) {
    try {
        const void* methodPtr = IL2Cpp::GetMethodOffset("mscorlib.dll", "System", "Type", "GetType", 1);
        if (!methodPtr) {
            //Logger::error("Type_GetType method offset is null");
            return nullptr;
        }
        return reinterpret_cast<void *(__fastcall *)(monoString *)>((uint64_t) methodPtr)(instance);
    } catch (...) {
        //Logger::error("Failed to get Type_GetType method offset");
        return nullptr;
    }
}

monoArray<void **>*Object_FindObjectsOfType(void *instance) {
    try {
        const void* methodPtr = IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Object", "FindObjectsOfType", 1);
        if (!methodPtr) {
            //Logger::error("Object_FindObjectsOfType method offset is null");
            return nullptr;
        }
        return reinterpret_cast<monoArray<void **>*(__fastcall *)(void *)>((uint64_t) methodPtr)(instance);
    } catch (...) {
        //Logger::error("Failed to get Object_FindObjectsOfType method offset");
        return nullptr;
    }
}

bool GameObject_get_activeInHierarchy(void *instance) {
    try {
        const void* methodPtr = IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "get_activeInHierarchy", 0);
        if (!methodPtr) {
            //Logger::error("GameObject_get_activeInHierarchy method offset is null");
            return false;
        }
        return reinterpret_cast<bool(__fastcall *)(void *)>((uint64_t) methodPtr)(instance);
    } catch (...) {
        //Logger::error("Failed to get GameObject_get_activeInHierarchy method offset");
        return false;
    }
}

void *Component_get_gameObject(void *component) {
    try {
        return reinterpret_cast<void *(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Component", "get_gameObject", 0))(component);
    } catch (...) {
        //Logger::error("Failed to get Component_get_gameObject method offset");
        return nullptr;
    }
}

void *Component_get_transform(void *instance) {
    try {
        return reinterpret_cast<void *(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Component", "get_transform", 0))(instance);
    } catch (...) {
        //Logger::error("Failed to get Component_get_transform method offset");
        return nullptr;
    }
}

void *GameObject_get_transform(void *instance) {
    try {
        return reinterpret_cast<void *(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "get_transform", 0))(instance);
    } catch (...) {
        //Logger::error("Failed to get GameObject_get_transform method offset");
        return nullptr;
    }
}

monoArray<void **>*GameObject_GetComponentsInternal(void *instance, void *type, bool useSearch, bool recursive, bool includeInactive, bool reverse, void *object) {
    try {
        return reinterpret_cast<monoArray<void **>*(__fastcall *)(void *, void *, bool, bool, bool, bool, void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "GameObject", "GetComponentsInternal", 6))(instance, type, useSearch, recursive, includeInactive, reverse, object);
    } catch (...) {
        //Logger::error("Failed to get GameObject_GetComponentsInternal method offset");
        return nullptr;
    }
}

Vector3 Transform_get_position(void *instance) {
    try {
        return reinterpret_cast<Vector3(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_position", 0))(instance);
    } catch (...) {
        //Logger::error("Failed to get Transform_get_position method offset");
        return Vector3();
    }
}

void* Transform_get_parent(void* transform) {
    try {
        return reinterpret_cast<void*(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_parent", 0))(transform);
    } catch (...) {
        //Logger::error("Failed to get Transform_get_parent method offset");
        return nullptr;
    }
}

int Transform_get_childCount(void* transform) {
    try {
        return reinterpret_cast<int(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Transform", "get_childCount", 0))(transform);
    } catch (...) {
        //Logger::error("Failed to get Transform_get_childCount method offset");
        return 0;
    }
}

void *Camera_get_main() {
    try {
        return reinterpret_cast<void *(__fastcall *)()>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_main", 0))();
    } catch (...) {
        //Logger::error("Failed to get Camera_get_main method offset");
        return nullptr;
    }
}

monoString *String_CreateString(const char *str) {
    try {
        return reinterpret_cast<monoString *(__fastcall *)(void *, const char *, int, int)>((uint64_t) IL2Cpp::GetMethodOffset("mscorlib.dll", "System", "String", "CreateString", 3))(NULL, str, 0, strlen(str));
    } catch (...) {
        //Logger::error("Failed to get String_CreateString method offset");
        return nullptr;
    }
}

Vector3 Camera_WorldToViewportPoint(void *camera, Vector3 position) {
    try {
        return reinterpret_cast<Vector3(__fastcall *)(void *, Vector3)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToViewportPoint", 1))(camera, position);
    } catch (...) {
        //Logger::error("Failed to get Camera_WorldToViewportPoint method offset");
        return Vector3();
    }
}

Vector3 Camera_WorldtoscreenPoint(void* camera, Vector3 position){
    try {
        return reinterpret_cast<Vector3(__fastcall *)(void *, Vector3)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToScreenPoint", 1))(camera, position);
    } catch (...) {
        //Logger::error("Failed to get Camera_WorldToScreenPoint method offset");
        return Vector3();
    }
}

monoArray<void**>* SkinnedMeshRenderer_get_bones(void* smr) {
    try {
        return reinterpret_cast<monoArray<void**>*(__fastcall *)(void *)>((uint64_t) IL2Cpp::GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "SkinnedMeshRenderer", "get_bones", 0))(smr);
    } catch (...) {
        //Logger::error("Failed to get SkinnedMeshRenderer_get_bones method offset");
        return nullptr;
    }
}

// World to Screen conversion functions
void WorldToScreen(void *camera, Vector3 position, Vector3 &screen, bool &checker) {
    if (!camera) return;
    screen = Camera_WorldToViewportPoint(camera, position);
    if (screen.z > 0) {
        screen.x *= kWidth; screen.y = kHeight - screen.y * kHeight;
    } else {
        screen.x = kWidth - screen.x * kWidth; screen.y *= kHeight;
    }
    checker = (screen.z > 0);
}

void WorldToScreenPoint(void* camera, Vector3 position, Vector3 &screen, bool &checker) {
    if (!camera) return;
    screen = Camera_WorldtoscreenPoint(camera, position);
    if (screen.z > 0) {
        screen.x = screen.x;
        screen.y = kHeight - screen.y;
    } else {
        screen.x = kWidth - screen.x;
        screen.y = screen.y;
    }
    checker = (screen.z > 0);
}

// Camera validation function
bool isCameraValid(void* camera) {
    if (!camera) return false;
    
    // Check if camera has valid transform
    void* transform = Component_get_transform(camera);
    if (!transform) return false;
    
    // Check if transform has valid position
    Vector3 pos = Transform_get_position(transform);
    if (pos.x == 0 && pos.y == 0 && pos.z == 0) return false;
    
    // Check if GameObject is active
    void* gameObject = Component_get_gameObject(camera);
    if (!gameObject) return false;
    if (!GameObject_get_activeInHierarchy(gameObject)) return false;
    
    return true;
}

// Hunter::get_IsLocallyControlled() - Check if Hunter is local player
bool Hunter_get_IsLocallyControlled(void* hunterInstance) {
    try {
        const void* methodPtr = IL2Cpp::GetMethodOffset(PLAYER_ASSEMBLY_NAME, "", "Hunter", "get_IsLocallyControlled", 0);
        if (!methodPtr) {
            return false;
        }
        return reinterpret_cast<bool(__fastcall *)(void *)>((uint64_t) methodPtr)(hunterInstance);
    } catch (...) {
        return false;
    }
}

// IPlayerInGame::get_Kind() - Get PlayerKind (0 = Hunter, 1 = Prop)
int IPlayerInGame_get_Kind(void* playerInstance) {
    try {
        // Try to get from interface - first try Hunter
        const void* methodPtr = IL2Cpp::GetMethodOffset(PLAYER_ASSEMBLY_NAME, "", "Hunter", "get_Kind", 0);
        if (methodPtr) {
            return reinterpret_cast<int(__fastcall *)(void *)>((uint64_t) methodPtr)(playerInstance);
        }
        // Try Prop
        methodPtr = IL2Cpp::GetMethodOffset(PLAYER_ASSEMBLY_NAME, "", "Prop", "get_Kind", 0);
        if (methodPtr) {
            return reinterpret_cast<int(__fastcall *)(void *)>((uint64_t) methodPtr)(playerInstance);
        }
        return -1;
    } catch (...) {
        return -1;
    }
}
