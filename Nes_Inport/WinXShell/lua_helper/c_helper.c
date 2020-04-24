#include <windows.h>

WINBASEAPI
int
WINAPI
GetSystemDefaultLocaleName(
    LPWSTR lpLocaleName,
    int cchLocaleName
);

int w2a(wchar_t *src, char *dst, int cb) {
    WideCharToMultiByte(CP_ACP, 0, src, -1, dst, cb, NULL, NULL);
    return 0;
}

char *localename(int out) {
    static char name[LOCALE_NAME_MAX_LENGTH] = {0};
    wchar_t buff[LOCALE_NAME_MAX_LENGTH] = {0};
    GetSystemDefaultLocaleName(buff, LOCALE_NAME_MAX_LENGTH);
    w2a(buff, name, LOCALE_NAME_MAX_LENGTH);
    if (out > 0) printf("%s\n", name);
    return name;
}

void load_resstr(char *file, char *sid) {
    HINSTANCE hDll;
    char buff[128] = {0};
    int id = atoi(sid);
    HINSTANCE res = LoadLibrary(file); 
    LoadString(res, id, buff, 128);
    FreeLibrary(res);
    printf("%s\n", buff);
}

void copyright() {
    load_resstr("Branding\\Basebrd\\basebrd.dll", "14");
    /*
    char *ln = localename(0);
    char resdll[MAX_PATH] ={0};
    sprintf(resdll, "Branding\\Basebrd\\%s\\basebrd.dll.mui", ln);
    load_resstr(resdll, "14");
    */
}

void meminfo() {
    ULONGLONG memInstalled = 0;
    MEMORYSTATUS memStatus;
    memset( &memStatus, 0x00, sizeof( MEMORYSTATUS ) );
    memStatus.dwLength = sizeof( MEMORYSTATUS );
    GlobalMemoryStatus( &memStatus );
    SIZE_T zt = memStatus.dwTotalPhys;
    GetPhysicallyInstalledSystemMemory(&memInstalled);
    int err = GetLastError();
    char *fmt = "%ld\n";
#ifdef _WIN64
    fmt = "%lld\n";
#endif
    printf(fmt, memInstalled);
    printf(fmt, memStatus.dwTotalPhys);
    printf(fmt, memStatus.dwAvailPhys);
    if (err) printf("GetPhysicallyInstalledSystemMemory error(ec=%d).\n", err);
}


int main(int argc, char *argv[]) {
    //char *cmdline = GetCommandLine();
    if (argc <= 1) return 0;

    if (strcmp(argv[1], "localename") == 0) {
        localename(1);
    } else if (strcmp(argv[1], "copyright") == 0) {
        copyright();
    } else if (strcmp(argv[1], "load_resstr") == 0) {
        if (argc <= 3) return 0;
        load_resstr(argv[2], argv[3]);
    } else if (strcmp(argv[1], "meminfo") == 0) {
        meminfo();
    }
    return 0;
}
