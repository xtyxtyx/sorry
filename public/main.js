var btn    = document.getElementById("submit_btn")
var result = document.getElementById("result")

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
    btn.disabled = true;
    btn.innerHTML = "请稍候"

    var begin_time = Date.now();

    var xhttp = new XMLHttpRequest();
    xhttp.timeout = 3 * 1000;

    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            if (this.status == 200) {
                result.innerHTML = this.responseText;
            } else {
                result.innerHTML = "<p>请求出错！❌</p>";
            }
            btn.innerHTML = "生成";
            btn.disabled = false;
        }
    };

    save_input()
    xhttp.open("POST", "/make", true);
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

btn.onclick = submit;
restore_input()
