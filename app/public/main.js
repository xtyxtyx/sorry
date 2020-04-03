var submit_btn        = document.getElementById("submit_btn")
var show_sidebar_btn  = document.getElementById("show_sidebar")
var sidebar_close_btn = document.getElementById("sidebar_close")
var sidebar           = document.getElementById("sidebar")
var result            = document.getElementById("result")
var wechat_checkbox   = document.getElementById("wechat-checkbox")

function make_body() {
    var body = {}

    var inputs = document.getElementsByTagName("input")
    for (var i = 0; i < inputs.length; i++) {
        var elem = inputs[i];

        var text = elem.value === "" ? elem.placeholder : elem.value;
        body[i] = text;
    }

    return JSON.stringify(body);
}

function calculate_duration(begin_time) {
    return Date.now() - begin_time;
}

function submit() {
    submit_btn.disabled = true;
    submit_btn.innerHTML = "请稍候"

    var begin_time = Date.now();

    var xhttp = new XMLHttpRequest();

    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            if (this.status == 521 || this.status == 404) {
                result.innerHTML = "<p>请求出错！😵</p>";
            } else {
                result.innerHTML = this.responseText;
            }
            submit_btn.innerHTML = "生成";
            submit_btn.disabled = false;
        }
    };

    save_input()

    if (wechat_checkbox && wechat_checkbox.checked) {
        xhttp.open("POST", "wechat/make", true);
    } else {
        xhttp.open("POST", "make", true);        
    }

    xhttp.send(make_body());
}

function restore_input() {
    var item = "input";

    if (docCookies.hasItem(item)) {
        var stored_input = JSON.parse(docCookies.getItem(item));

        var inputs = document.getElementsByTagName("input")
        for (var i = 0; i < inputs.length; i++) {
            var elem = inputs[i];
            elem.value = stored_input[i] || "";
        }
    }
    
}

function save_input() {
    var obj = {}

    var inputs = document.getElementsByTagName("input")
    for (var i = 0; i < inputs.length; i++) {
        var elem = inputs[i];

        var text = elem.value;
        obj[i] = text;
    }
    docCookies.setItem("input", JSON.stringify(obj));
}

function sidebar_open() {
    sidebar.style.display = "block";
}

function sidebar_close() {
    sidebar.style.display = "none";
}

submit_btn.onclick        = submit;
show_sidebar_btn.onclick  = sidebar_open;
sidebar_close_btn.onclick = sidebar_close;

restore_input()
