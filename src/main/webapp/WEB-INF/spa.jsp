<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="./ssoagent/css/login.css"/>
    <script type="text/javascript" src="./ssoagent/js/spa/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="./ssoagent/js/spa/nsso.js"></script>
    <script type="text/javascript" src="./ssoagent/js/ajax.js"></script>
    <script type="text/javascript" src="./ssoagent/js/rsa/rsa.js"></script>
    <script type="text/javascript" src="./ssoagent/js/rsa/jsbn.js"></script>
    <script type="text/javascript" src="./ssoagent/js/rsa/prng4.js"></script>
    <script type="text/javascript" src="./ssoagent/js/rsa/rng.js"></script>
    <script type="text/javascript">
        function OnLogon() {
            var userId = $("#user_id");
            var userPw = $("#user_pw");
            if (!userId.val()) {
                userId.focus();
                return;
            }
            if (!userPw.val()) {
                userPw.focus();
                return;
            }
            if ($("input:checkbox[id='chk_enc']").is(":checked")) {
                logonEnc(userId.val(), userPw.val());
            } else {
                logon(userId.val(), userPw.val());
            }
        }

        function OnLogoff() {
            location.href = urlSSOLogoffService + "?ssosite=" + ssosite + "&returnURL=" + encodeURIComponent(location.href);
        }

        function OnDupLogon() {
            $("#dupChoice").css("visibility", "hidden");
            dupChoiceLogon();
        }

        function OnDupCancel() {
            $("#dupChoice").css("visibility", "hidden");
            dupChoiceCancel();
        }

        function OnTFALogon() {
            var code = $("#code");
            if (!code.val()) {
                code.focus();
                return;
            }
            logonTfa(code.val());
        }
    </script>

</head>
<body>
<div class="log_wrap">
    <header>
        <h1>Single Page Application</h1>
    </header>
    <section>
        <!-- LOGON UI -->
        <div id="logonUi" class="log_form" style="visibility: hidden">
            <div class="form_content">
                <dl class="input_id">
                    <dt>ID</dt>
                    <dd>
                        <input class="clearInput" type="text" id="user_id"/>
                    </dd>
                </dl>
                <dl class="input_pass">
                    <dt>PASSWORD</dt>
                    <dd>
                        <input class="passInput" type="password" id="user_pw"/>
                    </dd>
                </dl>
                <div id="infoBox" class="info_box">
                    Encryption
                    <input style="width: unset" type="checkbox" id="chk_enc"/>
                </div>
                <div id="infoBox" class="info_box">
                    <p id="errorMsg"></p>
                </div>
                <button type="button" onclick="OnLogon()">Logon</button>
            </div>
        </div>
        <!-- LOGON SUCCESS -->
        <div id="userInfo" class="log_form" style="visibility: hidden">
            <div class="form_content">
                <dl class="input_id">
                    <dt>ID</dt>
                    <dd>
                        <p id="UserId"></p>
                    </dd>
                </dl>
                <dl class="input_pass">
                    <dt>Attributes</dt>
                    <dd>
                        <p id="UserAttribute"></p>
                    </dd>
                </dl>
                <div id="infoBox" class="info_box">
                    <p id="warnMsg"></p>
                </div>
                <button type="button" onclick="OnLogoff()">Logoff</button>
            </div>
        </div>
        <!-- Duplication Choice -->
        <div id="dupChoice" class="log_form" style="visibility: hidden">
            <div class="form_content">
                <dl class="input_id">
                    <dt>Duplication Info</dt>
                    <dd>
                        <p id="dupInfo"></p>
                    </dd>
                </dl>
                <dl class="input_pass">
                    <dt>Choice</dt>
                    <dd>
                        <button type="button" onclick="OnDupLogon()">Let me logon</button>
                        <button type="button" onclick="OnDupCancel()">Cancel logon</button>
                    </dd>
                </dl>
            </div>
        </div>
        <!-- TFA Code Input -->
        <div id="tfaCode" class="log_form" style="visibility: hidden">
            <div class="form_content">
                <dl class="input_id">
                    <dt>Code</dt>
                    <dd>
                        <input class="clearInput" type="text" id="code"/>
                        <p id="tfaInfo"></p>
                    </dd>
                </dl>
                <button type="button" onclick="OnTFALogon()">Logon</button>
            </div>
        </div>
    </section>
</div>
</body>
<script type="text/javascript">
    /*================================
    페이지가 로드되면, SSO 환경설정 & 인증 체크 시작
    ================================*/
    $(document).ready(function () {
        setNssoConfiguration(
            // 업무 시스템 별로, URI를 변경해주세요. 예) https://sso.nets.co.kr/sample/ssoagent/spa
            "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/ssoagent/spa",
            // 인증 실패 시 호출되는 함수
            callbackLogonFail,
            // 인증 성공 시 호출되는 함수
            callbackLogonSuccess,
            // 2차인증 필요 시 호출되는 함수
            callbackReceiveTfa,
            // 중복 로그온 선택 시 호출되는 함수
            callbackReceiveDuplication,
            // SSO 서비스 장애 시 호출되는 함수
            callbackSsoUnavailable
        )
    });

    /*================================
    페이지를 벗어날 때 타이머 제거
    ================================*/
    $(window).on("unload", disableTimer());

    /*================================
    중복 로그온 선택 시 호출되는 메서드
    ================================*/
    function callbackReceiveDuplication() {
        $("#logonUi").css("visibility", "hidden");
        $("#tfaCode").css("visibility", "hidden");
        $("#userInfo").css("visibility", "hidden");
        $("#dupChoice").css("visibility", "visible");

        $("#UserAttribute").text("time:" + ssoDuplication['time'] + ", ip:" + ssoDuplication['ip']);
    }

    /*================================
    2차 인증 필요 시 호출되는 메서드
    ================================*/
    function callbackReceiveTfa() {
        $("#logonUi").css("visibility", "hidden");
        $("#dupChoice").css("visibility", "hidden");
        $("#userInfo").css("visibility", "hidden");
        $("#tfaCode").css("visibility", "visible");
        $("#tfaInfo").text(ssoTfa['remainCount'] >= 1 ? ssoTfa['remainCount'] + "회 가능" : "");
        $("#code").focus();
    }

    /*================================
    인증 성공 시 호출되는 메서드
    ================================*/
    function callbackLogonSuccess() {
        if (!ssoSuccess)
            return;

        // 하위 호환성을 위해 GATE 페이지로 이동해야 하는지 확인
        if (gateUrl !== "") {
            location.href = gateUrl;
            return;
        }

        // 이동해야할 URL이 존재하는지 확인
        var returnURL = getUrlParameter("returnURL");
        if (!returnURL === false) {
            // 페이지 이동
            location.href = returnURL;
            return;
        }

        $("#logonUi").css("visibility", "hidden");
        $("#dupChoice").css("visibility", "hidden");
        $("#tfaCode").css("visibility", "hidden");
        $("#userInfo").css("visibility", "visible");

        /*==== 사용자 아이디 추출 ====*/
        $("#UserId").text(ssoUserId);

        if (null === ssoUserAttribute)
            return;

        /*==== 사용자 속성 데이터 추출 ====*/
        var orgcode = getNssoUserAttribute('orgcode');
        var companycode = getNssoUserAttribute('companycode');
        var email = getNssoUserAttribute('email');
        var name = getNssoUserAttribute('name');
        var pwddt = getNssoUserAttribute('pwddt');
        $("#UserAttribute").text("orgCode:" + orgcode + ", companyCode=" + companycode + ", email=" + email + ", name=" + name + ", pwdDate=" + pwddt);

        var msg = "";
        var expireDate = getNssoMisc('expireDate');
        var remainDays = getNssoMisc('remainDays');
        if (expireDate !== "" && remainDays !== "")
            msg += "비밀번호가 " + expireDate + "일(" + remainDays + "전)에 만료됩니다.";
        if (msg !== "")
            $("#warnMsg").text(msg);
    }

    /*================================
    인증 실패 시 호출되는 메서드
    ================================*/
    function callbackLogonFail() {
        $("#dupChoice").css("visibility", "hidden");
        $("#tfaCode").css("visibility", "hidden");
        $("#userInfo").css("visibility", "hidden");
        $("#logonUi").css("visibility", "visible");

        if (!ssoErrorMessage && ssoErrorCode === 0)
            return;
        var msg = ssoErrorMessage;
        if (ssoErrorCode !== 0)
            msg += "(" + ssoErrorCode + ")";
        var failedCount = getNssoMisc('pwdFailedCount');
        if (failedCount !== "")
            msg += "(" + failedCount + "회 연속 틀림)";
        if (ssoErrorCode === 11060002) {
            // 중복 로그인 발생
            disableTimer();
            alert(msg);
            OnLogoff();
        } else {
            $("#errorMsg").text(msg);
        }
    }

    /*================================
    SSO 장애 시 호출되는 메서드
    ================================*/
    function callbackSsoUnavailable() {
        $("#dupChoice").css("visibility", "hidden");
        $("#tfaCode").css("visibility", "hidden");
        $("#userInfo").css("visibility", "hidden");
        $("#logonUi").css("visibility", "visible");

        var msg = ssoErrorMessage;
        if (ssoErrorCode !== 0)
            msg += "(" + ssoErrorCode + ")";
        $("#errorMsg").text(msg);
    }

    /*================================
    현재 URL에서 전달된 Parameter 값 추출
    ================================*/
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }
</script>
</html>