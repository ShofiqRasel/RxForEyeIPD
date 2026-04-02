//window.getDeviceInfo = () => {
//    return "" + window.screen.width +
//           "" + window.screen.height +
//           "" + window.innerWidth +
//           "" + window.innerHeight;
//};


window.getDeviceInfo = () => {
    let id = localStorage.getItem('DeviceUniqueId');
    if (!id) {
        id = crypto.randomUUID();
        localStorage.setItem('DeviceUniqueId', id);
    }
    return id;
};