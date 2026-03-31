//window.getDeviceInfo = () => {
//    return "" + window.screen.width +
//           "" + window.screen.height +
//           "" + window.innerWidth +
//           "" + window.innerHeight;
//};


window.getDeviceInfo = () => {
    let deviceId = localStorage.getItem("deviceId");

        if (!deviceId) {
            deviceId = crypto.randomUUID(); // ✅ unique per browser/device
            localStorage.setItem("deviceId", deviceId);
        }

        return deviceId;
};

//window.getDeviceInfo = function syncDeviceId() {
//    let deviceId = localStorage.getItem("deviceId");
//    if (!deviceId) {
//        deviceId = crypto.randomUUID();
//        localStorage.setItem("deviceId", deviceId);
//    }
//    // Force the value into the hidden input so Blazor captures it
//    const el = document.getElementById('hiddenDeviceId');
//    if (el) {
//        el.value = deviceId;
//        // Trigger an 'input' event so Blazor's binding system sees the change
//        el.dispatchEvent(new Event('input', { bubbles: true }));
//    }
//}