package com.wishlink.kelp.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.wishlink.kelp.bean.AlipayCallbackEntity;
import com.wishlink.kelp.bean.ResponseJsonEntity;


@RestController
@RequestMapping("/sample")
public class SampleRest {
    private final static Logger logger = Logger.getLogger(SampleRest.class);
    @Value("#{setting['weixin.app_id']}")
    private String appid;
    
    @Resource(name="setting")
    private Properties myProperties;

 
    @Value("${jdbc.url}")
    private String jdbcUrl;
    

    @Value("#{setting['qingshow.appserver.alipay.callback']}")
    private String appServerCallbackUrl;
    
    
    @RequestMapping(value = "/hello", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> hello(@RequestParam(value="name", defaultValue="World") String name, HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("message", "Hello," + name);
        logger.info(appid);
        logger.info(jdbcUrl);
        logger.info(myProperties.get("weixin.app_id"));
        logger.info(request.getRemoteAddr());
        logger.info(response.getCharacterEncoding());
        
        return new ResponseEntity<>(returnMap, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    @RequestMapping(value = "/test", method = RequestMethod.POST)
    public Object postData(@RequestParam(value="name", defaultValue="World") String name, 
            @RequestBody String xmlData, HttpServletRequest request, HttpServletResponse response) {
        logger.info(name);
        Map m = request.getParameterMap();
        Iterator it = m.keySet().iterator();
        while (it.hasNext()) {
            String k = (String) it.next();
            String v = ((String[]) m.get(k))[0];
            logger.info("Request[" + k + "]=" + v);
        }
        logger.info(xmlData);
        RestTemplate restClient = new RestTemplate();
        HashMap<String, String> map = new HashMap<String, String>();
        map.put("id", "admin");
//        map.put("password", "admin");
        
        ResponseJsonEntity returnJson = restClient.postForObject("http://localhost:30001/services/user/login", map, ResponseJsonEntity.class);
        return returnJson;
    }
    
    
    @RequestMapping(value = "/test2", method = RequestMethod.POST)
    public String postData2(@RequestParam(value="name", defaultValue="World") String name, @ModelAttribute AlipayCallbackEntity entity, HttpServletRequest request) {
        logger.info(entity.getBody());
        Map m = request.getParameterMap();
        Iterator it = m.keySet().iterator();
        while (it.hasNext()) {
            String k = (String) it.next();
            String v = ((String[]) m.get(k))[0];
            logger.info("Request[" + k + "]=" + v);
        }
        return "OK";
    }
}
