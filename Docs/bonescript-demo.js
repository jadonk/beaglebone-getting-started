var cssUrls = [
    'jquery.terminal.css',         // http://terminal.jcubic.pl/js/jquery.terminal.css
    'jquery-ui.css',               // http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css
    'client.css'
];

var scriptUrls = [
    'jquery.js',
    'jquery.svg.js',
    'jquery.terminal.js',          // http://terminal.jcubic.pl/js/jquery.terminal-0.4.12.min.js
    'jquery.mousewheel.js',        // http://terminal.jcubic.pl/js/jquery.mousewheel-min.js
    'jquery-ui.min.js',         // http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js
    'ajaxorg-ace-builds-c2f3abb/ace.js' // https://github.com/ajaxorg/ace-builds/commit/c2f3abb2ecd3287f90225d804132f0fd26cfb639
];

var doAlert = function(m) {
    alert(JSON.stringify(m));
};

var demoRun = function(id) {
    var myScript = document.getElementById(id).innerHTML;
    myScript = myScript.replace("&lt;", "<");
    myScript = myScript.replace("&gt;", ">");
    myScript = myScript.replace("&amp;", "&");
    eval(myScript);
};

var initClient = function() {
    $("#buttons").append("<p>" +
      "<button class=\"dynlink\" onclick=\"demoRun('code')\">Run</button>" +
      "</p>");

    demoEdit = function(id) {
        var editor = ace.edit(id);
        editor.setTheme("ace/theme/monokai");
        editor.getSession().setMode("ace/mode/javascript");
        var originalDemoRun = demoRun;
        demoRun = function(myid) {
            if(myid == id) eval(editor.getValue());
            else originalDemoRun(myid);
        }
    };
};

var loadScript = function(url, callback) {
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url;
    script.charset = 'UTF-8';
    var scriptObj = head.appendChild(script);
    scriptObj.onload = callback;
}

// based loosely on http://stackoverflow.com/questions/950087/include-javascript-file-inside-javascript-file
var loadScripts = function() {
    var url = scriptUrls.shift();
    if(url) {
        loadScript(url, loadScripts);
    } else {
        initClient();
    }
};

var loadCss = function() {
    var url = cssUrls.shift();
    if(url) {
        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');
        link.rel = 'stylesheet';
        link.type = 'text/css';
        link.href = url;
        var linkObj = head.appendChild(link);
        loadCss();
    } else {
        loadScripts();
    }
};

loadCss();
