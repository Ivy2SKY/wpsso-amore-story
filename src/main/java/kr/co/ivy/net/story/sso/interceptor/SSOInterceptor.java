package kr.co.ivy.net.story.sso.interceptor;

import lombok.extern.slf4j.Slf4j;
import nets.sso.agent.web.v9.SSOAuthn;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Slf4j
@Component
public class SSOInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        boolean b = SSOAuthn.authnAndSet(request, response); // request 객체에 'ssoUser'와 'ssoUrl' 속성이 설정됩니다.

        log.info("SSOInterceptor result => " + b);

        return b;
//        return true;
    }

}