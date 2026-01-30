package io.github.teamb.btob.controller.adminDelivery;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import io.github.teamb.btob.service.adminDelivery.DeliveryService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("admin/delivery")
@RequiredArgsConstructor
public class DeliveryController {
    
    private final DeliveryService deliveryService;

    // 배송관리 목록 조회
    @GetMapping("/list")
    public String deliveryList(DeliveryDTO deliveryDTO, Model model) {
        List<DeliveryDTO> list = deliveryService.getDeliveryList(deliveryDTO);
        model.addAttribute("deliveryList", list);
        model.addAttribute("search", deliveryDTO);
        model.addAttribute("statusList", DeliveryStatus.values());
        return "test/adminDelivery/deliveryList";
    }
    
    // ⭐ 하나로 통일된 통합 수정 API (목록 & 상세 공통)
    @PostMapping({"/deliveryUpdate", "/updateDeliveryDetail"})
    @ResponseBody
    public Map<String, Object> updateDelivery(@RequestBody DeliveryDTO deliveryDTO, Principal principal) {
        Map<String, Object> result = new HashMap<>();
        String adminId = (principal != null) ? principal.getName() : "system";
        deliveryDTO.setUpdId(adminId);
        
        try {
            // 1. 통합 서비스 호출 (배송수정 + 주문동기화 + 이력등록)
            deliveryService.modifyDelivery(deliveryDTO);
            
            // 2. 수정된 데이터를 다시 조회 (statusName 등 계산된 필드를 포함하기 위함)
            DeliveryDTO updatedData = deliveryService.getDeliveryDetail(deliveryDTO.getDeliveryId());
            
            result.put("success", true);
            result.put("message", "정상적으로 수정되었습니다.");
            result.put("data", updatedData); // JS에서 updatedItem.data.statusName으로 접근
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "수정 중 오류 발생: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/detail/{deliveryId}")
    public String deliveryDetail(@PathVariable int deliveryId, Model model) {
        model.addAttribute("deliveryDTO", deliveryService.getDeliveryDetail(deliveryId));
        return "test/adminDelivery/deliveryDetail";
    }

    @PostMapping("/deleteDelivery")
    @ResponseBody
    public Map<String, Object> deleteDelivery(@RequestParam int deliveryId, Principal principal) {
        Map<String, Object> result = new HashMap<>();
        String updId = (principal != null) ? principal.getName() : "system";
        boolean isSuccess = deliveryService.removeDelivery(deliveryId, updId);
        result.put("success", isSuccess);
        result.put("message", isSuccess ? "비활성화 처리되었습니다." : "처리 실패");
        return result;
    }
}