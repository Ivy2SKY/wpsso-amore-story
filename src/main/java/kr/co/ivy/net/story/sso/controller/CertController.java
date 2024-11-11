package kr.co.ivy.net.story.sso.controller;

import kr.co.ivy.net.story.sso.util.CommonUtil;
import lombok.extern.slf4j.Slf4j;
import nets.sso.agent.web.v9.SSOAuthn;
import nets.sso.agent.web.v9.SSOUser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;

@Slf4j
@Controller
public class CertController {

    @Value("${amore.story.url}")
    private String amoreStoryUrl;


//    @GetMapping("/cert")
    @RequestMapping(value = "/cert", method = { RequestMethod.GET, RequestMethod.POST})
    public void ssoCert(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String ut = "";
        String uk = "";
        try {

            SSOUser ssoUser = SSOAuthn.authn(request, response);
            String userId = "";

            if (!ObjectUtils.isEmpty(ssoUser)) {
                userId = ssoUser.getUserID();

                uk = CommonUtil.shaEncrypt(userId);
                if (userId.length() > 2) {
                    ut = userId.substring(0, 2);
                }
            }

        } catch (Exception e) {
            log.error("" + e);
        }

//        response.sendRedirect(amoreStoryUrl + "/?uk=" + uk);
        response.sendRedirect(amoreStoryUrl + "/?ut=" + ut + "&uk=" + uk + "&haneul=" + "2SKY");

    }




//    @GetMapping("/cert")
//    public ModelAndView ssoCert(HttpServletRequest request, HttpServletResponse response) {
//
//        ModelAndView mv = new ModelAndView();
//        try {
//
//            SSOUser ssoUser = SSOAuthn.authn(request, response);
//            String userId = "";
//
//            if (!ObjectUtils.isEmpty(ssoUser)) {
//                userId = ssoUser.getUserID();
//            }
//
//            mv.setViewName("amore_story");
//            mv.addObject("uk", CommonUtil.shaEncrypt(userId));
//
//        } catch (Exception e) {
//            log.error("" + e);
//        }
//
//        return mv;
//    }



//    @ResponseBody
//    @PostMapping("/cert/story")
//    public ResponseEntity<HashMap<String, Object>> ssoStoryCert(HttpServletRequest request, HttpServletResponse response
////        , @RequestBody HashMap<String, String> at
//    ) {
//
//        HashMap<String, Object> rtn = new HashMap<>();
//
//        try {
//
////            String atCode = request.getHeader("Authorization");
//
//            SSOUser ssoUser = SSOAuthn.authn(request, response);
//
//            if (!ObjectUtils.isEmpty(ssoUser)) {
//                rtn.put("status", 200);
////                rtn.put("userId", ssoUser.getUserID());
//            }
//
//        } catch (Exception e) {
//            log.error("" + e);
//        }
//
//        return new ResponseEntity<>(rtn, new HttpHeaders(), HttpStatus.OK);
//    }


}
