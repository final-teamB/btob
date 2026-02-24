package io.github.teamb.btob.controller.adminDelivery;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryStatus;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import io.github.teamb.btob.service.adminDelivery.DeliveryService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("admin/delivery")
@RequiredArgsConstructor
@PreAuthorize("hashRole('ADMIN')")
public class DeliveryController {
    
	private final DeliveryMapper deliveryMapper;
    private final DeliveryService deliveryService;

    // test
    @GetMapping("/test/{orderId}")
    public String testDelivery(@PathVariable int orderId) {
        // 억지로 pm002 상황을 만들어서 배송 로직만 테스트
        try {
            String loginUserId = "test_user"; // 테스트용 ID
            
            DeliveryDTO newDelivery = new DeliveryDTO();
            newDelivery.setOrderId(orderId);
            newDelivery.setDeliveryStatus(DeliveryStatus.dv001);
            newDelivery.setRegId(loginUserId);

            deliveryMapper.insertDelivery(newDelivery);
            return "배송 생성 성공! orderId: " + orderId;
        } catch (Exception e) {
            return "실패: " + e.getMessage();
        }
    }
    
    // 배송관리 목록 조회
    @GetMapping("/list")
    public String deliveryList(DeliveryDTO deliveryDTO, Model model) {
        
    	List<DeliveryDTO> list = deliveryService.getDeliveryList(deliveryDTO);
        model.addAttribute("deliveryList", list);
        model.addAttribute("search", deliveryDTO);
        model.addAttribute("statusList", DeliveryStatus.values());
        
        model.addAttribute("content", "adminsh/adminDelivery/deliveryList.jsp"); // 실제 파일 경로
        return "layout/layout";
    }
    
    // 수정
    @PostMapping({"/deliveryUpdate", "/updateDeliveryDetail"})
    @ResponseBody
    public Map<String, Object> updateDelivery(@RequestBody Map<String, Object> params,
    										  @AuthenticationPrincipal UserDetails userDetails) {
        
    	Map<String, Object> result = new HashMap<>();
        
        try {
            DeliveryDTO deliveryDTO = new DeliveryDTO();
            // 1. 기본 값 세팅 (JS에서 보낸 키값과 매칭)
            deliveryDTO.setDeliveryId(Integer.parseInt(params.get("deliveryId").toString()));
            deliveryDTO.setTrackingNo((String) params.get("trackingNo"));
            deliveryDTO.setCarrierName((String) params.get("carrierName"));
            deliveryDTO.setShipToAddr((String) params.get("shipToAddr"));
            
            // 2. Enum 처리 (문자열 dv001 -> Enum DeliveryStatus.dv001 변환)
            String statusStr = (String) params.get("deliveryStatus");
            if (statusStr != null && !statusStr.isEmpty()) {
                deliveryDTO.setDeliveryStatus(DeliveryStatus.valueOf(statusStr));
            }
            
            String adminId = userDetails.getUsername();
            deliveryDTO.setUpdId(adminId);

            DeliveryDTO updated = deliveryService.modifyDelivery(deliveryDTO);

            result.put("success", true);
            result.put("message", "정상적으로 수정되었습니다.");

            // 프론트로 최신 값 전달
            result.put("deliveryStatus", updated.getDeliveryStatus().name());
            result.put("deliveryStatusDesc", updated.getDeliveryStatus().getDescription());
            result.put("trackingNo", updated.getTrackingNo());
            result.put("carrierName", updated.getCarrierName());

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    @GetMapping("/detail/{deliveryId}")
    public String deliveryDetail(@PathVariable int deliveryId, Model model) {
    	
        model.addAttribute("deliveryDTO", deliveryService.getDeliveryDetail(deliveryId));
        model.addAttribute("statusList", DeliveryStatus.values());
        
        model.addAttribute("content", "adminsh/adminDelivery/deliveryDetail.jsp"); // 실제 파일 경로
        return "layout/layout";
    }

    @PostMapping("/deleteDelivery")
    @ResponseBody
    public Map<String, Object> deleteDelivery(@RequestParam int deliveryId, Principal principal) {
    	
        Map<String, Object> result = new HashMap<>();
        String updId = (principal != null) ? principal.getName() : "admin";
        boolean isSuccess = deliveryService.removeDelivery(deliveryId, updId);
        result.put("success", isSuccess);
        result.put("message", isSuccess ? "비활성화 처리되었습니다." : "처리 실패");
        
        return result; 
    }
}