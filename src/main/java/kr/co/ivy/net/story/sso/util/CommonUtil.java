package kr.co.ivy.net.story.sso.util;

import lombok.extern.slf4j.Slf4j;

import javax.xml.bind.DatatypeConverter;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

@Slf4j
public class CommonUtil {


    public static String shaEncrypt(String planeText) {

        String encodingText = "";
        try {

            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(planeText.getBytes(StandardCharsets.UTF_8));

            String hex = String.format("%0128x", new BigInteger(1, md.digest()));
//            encodingText = DatatypeConverter.printBase64Binary(md.digest());

            encodingText = base64Encode(hex);

        } catch (Exception e) {
            log.error("" + e);
        }

        return encodingText;
    }



    private static String base64Encode(String planeText) {

        String encodingText = "";
        try {

            encodingText = Base64.getUrlEncoder().encodeToString(planeText.getBytes());

        } catch (Exception e) {
            log.error("" + e);
        }

        return encodingText;
    }


}
