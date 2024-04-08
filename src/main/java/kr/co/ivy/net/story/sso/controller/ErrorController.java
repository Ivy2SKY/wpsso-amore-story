//package kr.co.ivy.net.story.sso.controller;
//
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//import java.util.HashMap;
//
//@Slf4j
//@Controller
//public class ErrorController implements org.springframework.boot.web.servlet.error.ErrorController {
//
//
//    @RequestMapping(value = "/error")
//    public ResponseEntity<HashMap<String, Object>> errorRes() {
//
//        HashMap<String, Object> rtn = new HashMap<>();
//
//        try {
//
//            rtn.put("status", 500);
//
//        } catch (Exception e) {
//            log.error("" + e);
//        }
//
//        return new ResponseEntity<>(rtn, new HttpHeaders(), HttpStatus.OK);
//    }
//
//}
