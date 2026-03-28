window.getDeviceInfo = () => {
    console.log("getDeviceInfo was called from Blazor!");
    return {
        UserAgent: navigator.userAgent,
        ScreenWidth: window.screen.width,
        ScreenHeight: window.screen.height,
        DeviceMemory: navigator.deviceMemory || 0,
        Language: navigator.language
    };
};

