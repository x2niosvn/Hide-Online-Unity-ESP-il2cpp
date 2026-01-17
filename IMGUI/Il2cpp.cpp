#include "Il2cpp.h"
#include "dlfcn.h"
#include <string.h>
#include <stdio.h>
#include <mach-o/dyld.h>
#include <vector>
#include <string>
#include <set>

#include "dlfcn.h"
#include <string.h>
#include <stdio.h>
#include <mach-o/dyld.h>
#include <vector>
#include <string>
#include <set>

/* made by feendly for ios */

// Global info variable
MemoryInfo IL2Cpp::info;

MemoryInfo IL2Cpp::getBaseAddress(const std::string &fileName) {
    MemoryInfo _info;

    const uint32_t imageCount = _dyld_image_count();

    for (uint32_t i = 0; i < imageCount; i++) {
        const char *name = _dyld_get_image_name(i);
        if (!name)
            continue;

        std::string fullpath(name);

        if (fullpath.length() < fileName.length() || fullpath.compare(fullpath.length() - fileName.length(), fileName.length(), fileName) != 0)
            continue;

        _info.index = i;
        _info.header = _dyld_get_image_header(i);
        _info.name = _dyld_get_image_name(i);
        _info.address = _dyld_get_image_vmaddr_slide(i);

        break;
    }
    return _info;
}

namespace IL2Cpp 
{
    // IL2CPP function pointers
    char* (*il2cpp_thread_get_name)(void* thread, uint32_t* len);
    void* (*il2cpp_thread_current)();
    void* (*il2cpp_thread_attach)(void* domain);
    void (*il2cpp_thread_detach)(void* thread);
    void* (*il2cpp_runtime_invoke)(const void* method, void* obj, void** params, void** exc);
    void* (*il2cpp_class_get_field_from_name)(void* klass, const char* name);
    void* (*il2cpp_class_get_method_from_name)(void* klass, const char* name, int argsCount);
    size_t (*il2cpp_field_get_offset)(void* field);
    void* (*il2cpp_domain_get)();
    void** (*il2cpp_domain_get_assemblies)(const void* domain, size_t* size);
    const void* (*il2cpp_assembly_get_image)(const void* assembly);
    const char* (*il2cpp_image_get_name)(void* image);
    void* (*il2cpp_image_get_class)(void* image, size_t index);
    size_t (*il2cpp_image_get_class_count)(void* image);
    const char* (*il2cpp_class_get_name)(void* klass);
    const char* (*il2cpp_class_get_namespace)(void* klass);
    void* (*il2cpp_class_get_methods)(void* klass, void** iter);
    const char* (*il2cpp_method_get_name)(void* method);
    uint32_t (*il2cpp_method_get_flags)(void* method, uint32_t* iflags);
    void* (*il2cpp_class_get_properties)(void* klass, void** iter);
    const char* (*il2cpp_property_get_name)(void* property);
    void* (*il2cpp_property_get_get_method)(void* property);
    void* (*il2cpp_property_get_set_method)(void* property);
    void* (*il2cpp_class_get_fields)(void* klass, void** iter);
    const char* (*il2cpp_field_get_name)(void* field);
    const char* (*il2cpp_field_get_type)(void* field);
    int32_t (*il2cpp_field_get_flags)(void* field);
    char* (*il2cpp_type_get_name)(void* type);
    void* (*il2cpp_method_get_return_type)(void* method);
    void* (*il2cpp_class_from_type)(void* type);
    int32_t (*il2cpp_method_get_param_count)(void* method);
    void* (*il2cpp_method_get_param)(void* method, uint32_t index);
    const char* (*il2cpp_method_get_param_name)(void* method, uint32_t index);
    uint32_t (*il2cpp_type_get_attrs)(void* type);
    bool (*il2cpp_type_is_byref)(void* type);
    void* (*il2cpp_class_from_name)(const void* image, const char* namespaze, const char* name);
    void* (*il2cpp_object_unbox)(void* obj);
    void* (*il2cpp_object_new)(const void* klass);
    void (*il2cpp_field_static_get_value)(void* field, void* value);
    void (*il2cpp_field_static_set_value)(void* field, void* value);
    uint32_t (*il2cpp_gchandle_new)(void* obj, bool pinned);
    void (*il2cpp_gchandle_free)(uint32_t gchandle);
    
    void Attach()
    {
        if (!il2cpp_thread_get_name) 
        *(void**)&il2cpp_thread_get_name = IL2Cpp::Resolve("il2cpp_thread_get_name");
        if (!il2cpp_thread_current) 
        *(void**)&il2cpp_thread_current = IL2Cpp::Resolve("il2cpp_thread_current");
        if (!il2cpp_thread_attach) 
        *(void**)&il2cpp_thread_attach = IL2Cpp::Resolve("il2cpp_thread_attach");
        if (!il2cpp_thread_detach) 
        *(void**)&il2cpp_thread_detach = IL2Cpp::Resolve("il2cpp_thread_detach");
        if (!il2cpp_runtime_invoke) 
        *(void**)&il2cpp_runtime_invoke = IL2Cpp::Resolve("il2cpp_runtime_invoke");
        if (!il2cpp_class_get_field_from_name) 
        *(void**)&il2cpp_class_get_field_from_name = IL2Cpp::Resolve("il2cpp_class_get_field_from_name");
        if (!il2cpp_class_get_method_from_name) 
        *(void**)&il2cpp_class_get_method_from_name = IL2Cpp::Resolve("il2cpp_class_get_method_from_name");
        if (!il2cpp_field_get_offset) 
        *(void**)&il2cpp_field_get_offset = IL2Cpp::Resolve("il2cpp_field_get_offset");
        if (!il2cpp_domain_get) 
        *(void**)&il2cpp_domain_get = IL2Cpp::Resolve("il2cpp_domain_get");
        if (!il2cpp_domain_get_assemblies) 
        *(void**)&il2cpp_domain_get_assemblies = IL2Cpp::Resolve("il2cpp_domain_get_assemblies");
        if (!il2cpp_assembly_get_image) 
        *(void**)&il2cpp_assembly_get_image = IL2Cpp::Resolve("il2cpp_assembly_get_image");
        if (!il2cpp_image_get_name) 
        *(void**)&il2cpp_image_get_name = IL2Cpp::Resolve("il2cpp_image_get_name");
        if (!il2cpp_class_from_name) 
        *(void**)&il2cpp_class_from_name = IL2Cpp::Resolve("il2cpp_class_from_name");
        if (!il2cpp_object_unbox) 
        *(void**)&il2cpp_object_unbox = IL2Cpp::Resolve("il2cpp_object_unbox");
        if (!il2cpp_object_new) 
        *(void**)&il2cpp_object_new = IL2Cpp::Resolve("il2cpp_object_new");
        if (!il2cpp_field_static_get_value) 
        *(void**)&il2cpp_field_static_get_value = IL2Cpp::Resolve("il2cpp_field_static_get_value");
        if (!il2cpp_field_static_set_value) 
        *(void**)&il2cpp_field_static_set_value = IL2Cpp::Resolve("il2cpp_field_static_set_value");
        if (!il2cpp_gchandle_new) 
        *(void**)&il2cpp_gchandle_new = IL2Cpp::Resolve("il2cpp_gchandle_new");
        if (!il2cpp_gchandle_free) 
        *(void**)&il2cpp_gchandle_free = IL2Cpp::Resolve("il2cpp_gchandle_free");
        if (!il2cpp_image_get_class) 
        *(void**)&il2cpp_image_get_class = IL2Cpp::Resolve("il2cpp_image_get_class");
        if (!il2cpp_image_get_class_count) 
        *(void**)&il2cpp_image_get_class_count = IL2Cpp::Resolve("il2cpp_image_get_class_count");
        if (!il2cpp_class_get_name) 
        *(void**)&il2cpp_class_get_name = IL2Cpp::Resolve("il2cpp_class_get_name");
        if (!il2cpp_class_get_namespace) 
        *(void**)&il2cpp_class_get_namespace = IL2Cpp::Resolve("il2cpp_class_get_namespace");
        if (!il2cpp_class_get_methods) 
        *(void**)&il2cpp_class_get_methods = IL2Cpp::Resolve("il2cpp_class_get_methods");
        if (!il2cpp_method_get_name) 
        *(void**)&il2cpp_method_get_name = IL2Cpp::Resolve("il2cpp_method_get_name");
        if (!il2cpp_method_get_flags) 
        *(void**)&il2cpp_method_get_flags = IL2Cpp::Resolve("il2cpp_method_get_flags");
        if (!il2cpp_class_get_properties) 
        *(void**)&il2cpp_class_get_properties = IL2Cpp::Resolve("il2cpp_class_get_properties");
        if (!il2cpp_property_get_name) 
        *(void**)&il2cpp_property_get_name = IL2Cpp::Resolve("il2cpp_property_get_name");
        if (!il2cpp_property_get_get_method) 
        *(void**)&il2cpp_property_get_get_method = IL2Cpp::Resolve("il2cpp_property_get_get_method");
        if (!il2cpp_property_get_set_method) 
        *(void**)&il2cpp_property_get_set_method = IL2Cpp::Resolve("il2cpp_property_get_set_method");
        if (!il2cpp_class_get_fields) 
        *(void**)&il2cpp_class_get_fields = IL2Cpp::Resolve("il2cpp_class_get_fields");
        if (!il2cpp_field_get_name) 
        *(void**)&il2cpp_field_get_name = IL2Cpp::Resolve("il2cpp_field_get_name");
        if (!il2cpp_field_get_type) 
        *(void**)&il2cpp_field_get_type = IL2Cpp::Resolve("il2cpp_field_get_type");
        if (!il2cpp_field_get_flags) 
        *(void**)&il2cpp_field_get_flags = IL2Cpp::Resolve("il2cpp_field_get_flags");
        if (!il2cpp_type_get_name) 
        *(void**)&il2cpp_type_get_name = IL2Cpp::Resolve("il2cpp_type_get_name");
        if (!il2cpp_method_get_return_type) 
        *(void**)&il2cpp_method_get_return_type = IL2Cpp::Resolve("il2cpp_method_get_return_type");
        if (!il2cpp_class_from_type) 
        *(void**)&il2cpp_class_from_type = IL2Cpp::Resolve("il2cpp_class_from_type");
        if (!il2cpp_method_get_param_count) 
        *(void**)&il2cpp_method_get_param_count = IL2Cpp::Resolve("il2cpp_method_get_param_count");
        if (!il2cpp_method_get_param) 
        *(void**)&il2cpp_method_get_param = IL2Cpp::Resolve("il2cpp_method_get_param");
        if (!il2cpp_method_get_param_name) 
        *(void**)&il2cpp_method_get_param_name = IL2Cpp::Resolve("il2cpp_method_get_param_name");
        if (!il2cpp_type_get_attrs) 
        *(void**)&il2cpp_type_get_attrs = IL2Cpp::Resolve("il2cpp_type_get_attrs");
        if (!il2cpp_type_is_byref) 
        *(void**)&il2cpp_type_is_byref = IL2Cpp::Resolve("il2cpp_type_is_byref");
        
        info = getBaseAddress("UnityFramework");
    }

    void* Resolve(const char* symbol)
    {   
        void* mode = RTLD_DEFAULT;
        void* fptr = dlsym(mode, symbol);

        if (!fptr)
        {
            printf("Il2cpp: couldn't find %s", symbol);
            return nullptr;
        }

        return fptr;
    }

    void* GetImage(const char* img_name)
    {
        void* domain = il2cpp_domain_get();

        if (!domain) 
        {
            return nullptr;
        }

        size_t size;
        void** assemblies = il2cpp_domain_get_assemblies(domain, &size);

        for (int i = 0; i < size; i++) {
            void *cur = (void*)il2cpp_assembly_get_image(assemblies[i]); 

            if(strcmp(img_name, il2cpp_image_get_name(cur)) == 0) {
                return cur;
            }
        
        }
        return nullptr;
    }

    const void* GetMethodOffset(const char* image, const char* namespaze, const char* klass_name, const char* name, int argsCount)
    {   
        void* img = GetImage(image);

        if(!img) 
        {
            return nullptr;
        }

        void* klass = il2cpp_class_from_name(img, namespaze, klass_name);

        if(!klass) 
        {
            return nullptr;
        }

        void** method = (void **)il2cpp_class_get_method_from_name(klass, name, argsCount);

        if (!method) 
        {
            return nullptr;
        }

        return *method;
    }

    uint64_t GetBaseAddress() {
        const uint32_t imageCount = _dyld_image_count();
        
        for (uint32_t i = 0; i < imageCount; i++) {
            const char *name = _dyld_get_image_name(i);
            if (!name) continue;
            
            std::string fullpath(name);
            
            // Look for UnityFramework or main executable
            if (fullpath.find("UnityFramework") != std::string::npos || 
                fullpath.find("Application") != std::string::npos) {
                return _dyld_get_image_vmaddr_slide(i);
            }
        }
        
        // Fallback to first image if UnityFramework not found
        if (imageCount > 0) {
            return _dyld_get_image_vmaddr_slide(0);
        }
        
        return 0;
    }
}
