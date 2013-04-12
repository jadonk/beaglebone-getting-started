function require(file) {
    throw 'Please perform setTargetAddress on a valid target';
}

function setTargetAddress(address, callback) {
    function loadScript(url, onload) {
        var head = document.getElementsByTagName('head')[0];
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = url;
        script.charset = 'UTF-8';
        var scriptObj = head.appendChild(script);
        scriptObj.onload = onload;
    }
    var url = address;
    url = url.replace(/^(http:\/\/|https:\/\/)*/, 'http://');
    url = url.replace(/(\/)*$/, '/bonescript.js');
    loadScript(url, callback);
}
