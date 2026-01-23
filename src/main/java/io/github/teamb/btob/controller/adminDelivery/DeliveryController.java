package io.github.teamb.btob.controller.adminDelivery;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.service.adminDelivery.DeliveryService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("admin/delivery")
@RequiredArgsConstructor
public class DeliveryController {
	
	private final DeliveryService deliveryService;

	// 배송관리 목록 화면 이동 및 조회
	@GetMapping("/list")
	public String deliveryList(Model model) {
		
		List<DeliveryDTO> list = deliveryService.getDeliveryList();
		model.addAttribute("deliveryList", list);
		
		return "adminDelivery/deliveryList";
	}
	
	// 배송 정보 수정
	@PostMapping("/deliveryUpdate")
	@ResponseBody
	public String updateDelivery(@RequestBody DeliveryDTO deliveryDTO) {
		
		boolean isSuccess = deliveryService.modifyDelivery(deliveryDTO);
		return isSuccess ? "성공" : "실패";
	}
}
