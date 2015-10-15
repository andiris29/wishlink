package com.wishlink.kelp.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.wishlink.kelp.bean.Metadata;
import com.wishlink.kelp.bean.ResponseJsonEntity;
import com.wishlink.kelp.tencent.common.Util;
import com.wishlink.kelp.tencent.common.bean.PayQueryReqBean;
import com.wishlink.kelp.tencent.common.bean.PayQueryResBean;
import com.wishlink.kelp.tencent.common.bean.UnifiedOrderReqBean;
import com.wishlink.kelp.tencent.common.bean.UnifiedOrderResBean;
import com.wishlink.kelp.tencent.service.CallbackReqBean;
import com.wishlink.kelp.tencent.service.CallbackResBean;
import com.wishlink.kelp.tencent.service.PayQueryService;
import com.wishlink.kelp.tencent.service.UnifiedOrderService;
import com.wishlink.kelp.util.ServerError;

/**
 * 微信支付Controller
 * 
 * @author qusheng
 */
@RestController
@RequestMapping("/wechat")
public class WeChatPaymentController {

    /**
     * Logger
     */
    private static final Logger log = Logger.getLogger(WeChatPaymentController.class);
    
    private static final String SUCCESS = "SUCCESS";
    private static final String FAIL = "FAIL";
    
    @Value("#{setting['weixin.notify_url']}")
    private String notifyUrl;
    
    @Value("#{setting['wishlink.appserver.wechat.callback']}")
    private String appServerCallbackUrl;

    /**
     * 生成预支付订单 <br>
     * url: /wechat/prepay <br>
     * method: get <br>
     * 
     * @param id 请求参数:商户订单号(使用trade的 _id)
     * @param totolPrice 请求参数:订单总金额
     * @param orderName 请求参数:订单商品名，（如果orders是复数个的话，逗号分隔）
     * @param request Http Servlet Request(Spring framework autowrite)
     * @param response Http Servlet Response(Spring framework autowrite)
     * @return
     */
    @RequestMapping(value = "/prepay", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Object handlePrePay(@RequestParam(value = "id", required = true) String id,
            @RequestParam(value = "totalFee", required = true) String totalFee,
            @RequestParam(value = "orderName", required = true) String orderName,
            @RequestParam(value= "clientIp", required = true) String clientIp,
            HttpServletRequest request,
            HttpServletResponse response) {

        log.info("==========================> wechat/prepay start");

        ResponseJsonEntity returnEntity = new ResponseJsonEntity();
        log.debug("request.body.id=" + id);
        log.debug("request.body.totalFee=" + totalFee);
        log.debug("request.body.orderName=" + orderName);
        log.debug("request.body.clientIp=" + clientIp);
        
        try {
            UnifiedOrderReqBean bean = new UnifiedOrderReqBean();
            bean.setOut_trade_no(id);
            bean.setBody(orderName);
            bean.setFee_type("CNY");
            double totalFeeOriginal = NumberUtils.toDouble(totalFee, 0);
            totalFeeOriginal *= 100;
            int totalFeeFeng = NumberUtils.createBigDecimal(String.valueOf(totalFeeOriginal)).intValue();
            bean.setTotal_fee(String.valueOf(totalFeeFeng));
            bean.setSpbill_create_ip(clientIp);
            bean.setNotify_url(this.notifyUrl);
            bean.setTrade_type("APP");
            bean.sign();
            
            UnifiedOrderService service = new UnifiedOrderService();
            UnifiedOrderResBean responseBody = service.request(bean);
            if (SUCCESS.compareTo(responseBody.getReturn_code()) != 0) {
                log.error("generate prepay_id failure. reason:" + responseBody.getReturn_msg());
                Metadata metadata = new Metadata();
                metadata.setError(ServerError.ERROR_GET_PREPAY_FAIL_CD);
                metadata.setDevInfo(responseBody.getReturn_msg());
                returnEntity.setMetadata(metadata);
            } else if (SUCCESS.compareTo(responseBody.getResult_code()) != 0) {
                log.error("generate prepay_id error. err_code:[" + responseBody.getErr_code() + "],err_msg:[" + responseBody.getErr_code_des() + "]");
                Metadata metadata = new Metadata();
                metadata.setError(ServerError.ERROR_GET_PREPAY_FAIL_CD);
                metadata.setDevInfo(responseBody.getErr_code() + "/" + responseBody.getErr_code_des());
                returnEntity.setMetadata(metadata);
            } else {
                returnEntity.setData(responseBody);
            }
        } catch (Exception ex) {
            log.error("generate prepay_id exception.", ex);
            Metadata metadata = new Metadata();
            metadata.setError(ServerError.ERROR_GET_PREPAY_FAIL_CD);
            metadata.setDevInfo(ServerError.ERROR_GET_PREPAY_FAIL_MSG);
            returnEntity.setMetadata(metadata);
        }
        log.info("<========================== wechat/prepay end");
        return returnEntity;
    }
    
    /**
     * 微信服务器的回调接口
     * @param postData xml data in request’s body
     * @param request http servlet request
     * @param response http servlet response
     * @return json object
     */
    @RequestMapping(value = "/callback", method = RequestMethod.POST)
    public String callback(@RequestBody String postData,
            HttpServletRequest request, HttpServletResponse response) {
        
        log.info("==========================> wechat/callback start");
        log.debug("weichat server's post data ======>");
        log.debug(postData);
        log.debug("======> weichat server's post data");
        CallbackReqBean reqBean = (CallbackReqBean) Util.getObjectFromXML(postData, CallbackReqBean.class);
        CallbackResBean resBean = new CallbackResBean();
        Map<String, Object> params = reqBean.toMap();
  
        // tell app-server this is wechat's callback
        params.put("type", "wechat");
        params.put("_id", reqBean.getOut_trade_no());
        RestTemplate restClient = new RestTemplate();
        ResponseJsonEntity appRes = restClient.postForObject(appServerCallbackUrl, params, ResponseJsonEntity.class);
        Gson gson = new Gson();
        log.debug("app-server's return:" + gson.toJson(appRes));
        if ((appRes.getData() == null) || ((appRes.getMetadata() !=null) && StringUtils.isNotEmpty(appRes.getMetadata().getError()))) {
            resBean.setReturn_code(FAIL);
            resBean.setReturn_msg(appRes.getMetadata().getError());
            log.debug("wechat/callback's return:" + resBean.toString());
            log.info("<========================== wechat/callback end");
            return resBean.toString();
        }
        resBean.setReturn_code(SUCCESS);
        resBean.setReturn_msg("OK");
        log.debug("wechat/callback's return:" + resBean.toString());
        log.info("<========================== wechat/callback end");
        return resBean.toString();
    }
    
    /**
     * 向微信服务器查询订单
     * 
     * @param id trade's id
     * @param request Http Servlet Request
     * @param response Http Servlet Response
     * @return json object
     */
    @RequestMapping(value = "/queryOrder", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Object queryOrder(@RequestParam(value = "id", required = true) String id) {

        log.info("==========================> wechat/querOrder start");

        PayQueryReqBean requestBean = new PayQueryReqBean(StringUtils.EMPTY, id);
        ResponseJsonEntity returnEntity = new ResponseJsonEntity();
        
        try {
            PayQueryService service = new PayQueryService();
            PayQueryResBean bean = service.request(requestBean);
            
            if (SUCCESS.compareTo(bean.getReturn_code()) != 0) {
                log.error("queru order fail. message:" + bean.getReturn_msg());
                Metadata metadata = new Metadata();
                metadata.setError(ServerError.ERROR_QUERY_ORDER_FAIL_CD);
                metadata.setDevInfo(bean.getReturn_msg());
                returnEntity.setMetadata(metadata);
            } else if (SUCCESS.compareTo(bean.getResult_code()) != 0) {
                log.error("generate order error. err_code:[" + bean.getErr_code() + "],err_msg:[" + bean.getErr_code_des() + "]");
                Metadata metadata = new Metadata();
                metadata.setError(ServerError.ERROR_GET_PREPAY_FAIL_CD);
                metadata.setDevInfo(bean.getErr_code() + "/" + bean.getErr_code_des());
                returnEntity.setMetadata(metadata);
            } else {
                returnEntity.setData(bean);
            }
        } catch (Exception e) {
            log.error("query order exception.", e);
            Metadata metadata = new Metadata();
            metadata.setError(ServerError.ERROR_QUERY_ORDER_FAIL_CD);
            metadata.setDevInfo(ServerError.ERROR_QUERY_ORDER_FAIL_MSG);
            returnEntity.setMetadata(metadata);
        }     
        
        log.info("<========================== wechat/querOrder end");
        return returnEntity;
    }
}
