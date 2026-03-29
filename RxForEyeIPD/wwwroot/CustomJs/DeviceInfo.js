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