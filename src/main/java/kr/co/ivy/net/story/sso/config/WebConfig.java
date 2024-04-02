package kr.co.ivy.net.story.sso.config;

import kr.co.ivy.net.story.sso.interceptor.SSOInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    SSOInterceptor ssoInterceptor;


    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(ssoInterceptor)
                .excludePathPatterns("/health-check") //, "/cert/story"
                .addPathPatterns("/**/*");
    }


}
