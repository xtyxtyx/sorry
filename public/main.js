const btn    = document.getElementById("submit_btn")
const result = document.getElementById("result")

function gen_req_path() {
    var path = 'make?'
    var args = []

    const inputs = document.getElementsByTagName("input")
    console.log(inputs);
    for (var i = 0; i < inputs.length; i++) {
        const elem = inputs[i];

        var text = elem.value === "" ? elem.placeholder : elem.value
        args.push(i + "=" + text);
    }

    return path + args.join("&");
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
            result.innerHTML = this.responseText;
            btn.innerHTML = "生成";
            btn.disabled = false;
        }
    };

    xhttp.open("GET", gen_req_path(), true);
    xhttp.send();
}

btn.onclick = submit;