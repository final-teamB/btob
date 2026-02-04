package io.github.teamb.btob.controller.cart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;
import io.github.teamb.btob.service.cart.CartService;

@Controller
@RequestMapping("/cart")
public class CartController {
	private final CartService cartService;

	public CartController(CartService cartService) {
		this.cartService = cartService;
	}
	
	@GetMapping("/cart")
	public String cart(Model model
	                  ) { // 로그인 유저 정보
		 // @AuthenticationPrincipal CustomUserDetails user
	    String userId = ""; 
		/* user.getUserId(); // CustomUserDetails에 정의된 ID 가져오기 */
	    String cartStatus = cartService.getCartStatusByUser(userId);

	    // REJECTED,ORDERED이면 장바구니 비우기
	    if("REJECTED".equals(cartStatus) || "ORDERED".equals(cartStatus)) {
	        cartService.clearCart(userId);
	    }

	    List<CartItemDTO> cartList = cartService.getCartItemList();

	    model.addAttribute("cartList", cartList);
	    model.addAttribute("cartStatus", cartStatus);
	    model.addAttribute("pageTitle", "거래 바구니");
	    model.addAttribute("content", "/cart/cart.jsp");

	    return "layout/layout";
	}
	
	@PostMapping("/add")
	@ResponseBody
	public Map<String, Object> addToCart(
	        CartItemInsertDTO dto
	        // @AuthenticationPrincipal CustomUserDetails user
	) {
		// dto.setUserId(user.getUserId());
	    cartService.addToCart(dto);

	    Map<String, Object> res = new HashMap<>();
	    res.put("result", "success");
	    return res;
	}
	
	// 수량 변경
	@PostMapping("/update")
	@ResponseBody
	public Map<String, Object> updateCartQty(
			CartItemInsertDTO dto
	) {
	    cartService.updateCartItemQty(dto);

	    Map<String, Object> res = new HashMap<>();
	    res.put("result", "success");
	    return res;
	}

	// 삭제
	@PostMapping("/delete")
	@ResponseBody
	public Map<String, Object> deleteCartItemAjax(@RequestParam int cartId) {
	    cartService.deleteCartItem(cartId);

	    Map<String, Object> res = new HashMap<>();
	    res.put("result", "success");
	    return res;
	}
		

	@PostMapping("/order")
	public String order() {
				
		return "redirect:/cart/cart";
	}
	
	@PostMapping("/estimate")
	public String estimate() {
		
		return "redirect:/cart/cart";
	}
	
}
