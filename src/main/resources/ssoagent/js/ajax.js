var Ajax = function (url, params, callback, method) {
    this.url = url;
    this.params = params;
    this.callback = callback;
    this.method = method != null && method.length > 0 ? method : 'POST';
    this.type = 'TEXT';
    this.async = true;
    this.request = null;
    this.errHandler = null;
    this.tmpData = null;
};
Ajax.prototype.setType = function (type) {
    if (type == 'XML' || type == 'TEXT') this.type = type;
    else alert("${ajax.invalidtype}".format(type));
};
Ajax.prototype.setAsync = function (flag) {
    this.async = flag;
};
Ajax.prototype.setErrHandler = function (handler) {
    this.errHandler = handler;
};
Ajax.prototype.setTmpData = function (tmp) {
    this.tmpData = tmp;
};
Ajax.prototype.newXMLHttpRequest = function () {
    if (window.ActiveXObject) {
        try {
            return new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e1) {
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e2) {
                return null;
            }
        }
    } else if (window.XMLHttpRequest) {
        return new XMLHttpRequest();
    }
    else {
        return null;
    }
};
Ajax.prototype.send = function () {
    this.request = this.newXMLHttpRequest();
    var httpMethod = this.method ? this.method : 'GET';
    if (httpMethod != 'GET' && httpMethod != 'POST') httpMethod = 'GET';

    var httpParams = (this.params == null || this.params == '') ? null : this.params;
    var httpUrl = this.url;
    if (httpMethod == 'GET' && httpParams != null) httpUrl = httpUrl + "?" + httpParams;

    this.request.open(httpMethod, httpUrl, this.async);
    this.request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

    var req = this;
    this.request.onreadystatechange = function () {
        req.onStateChange.call(req);
    };
    this.request.send(httpMethod == 'POST' ? httpParams : null);

    return !this.async ? (this.type == 'XML' ? this.request.responseXML : this.request.responseText) : null;
};
Ajax.prototype.onStateChange = function () {
    if (this.async && this.request.readyState == 4) {
        if (this.request.status == 200) {
            if (this.type == 'XML') {
                if (this.tmpData == null) this.callback(this.request.responseXML);
                else this.callback(this.request.responseXML, this.tmpData);
            } else {
                if (this.tmpData == null) this.callback(this.request.responseText);
                else this.callback(this.request.responseText, this.tmpData);
            }
        } else {
            if (this.errHandler == null) {
                alert("HTTP error " + this.request.status + ": " + this.request.statusText);
            } else {
                if (this.tmpData == null) this.errHandler(this.request);
                else this.errHandler(this.request, this.tmpData);
            }
        }
    }
};