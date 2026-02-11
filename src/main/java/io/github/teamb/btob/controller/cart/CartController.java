package io.github.teamb.btob.controller.cart;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;
import io.github.teamb.btob.service.cart.CartService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {
	private final CartService cartService;
	private final LoginUserProvider loginUserProvider;
	
	@GetMapping("/cart")
	public String cart(Model model,
	                  @RequestParam(required = false) String orderNo) { // 로그인 유저 정보
		
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
	  
	    List<CartItemDTO> cartList = cartService.getCartItemList(orderNo);

	    model.addAttribute("cartList", cartList);
	    model.addAttribute("pageTitle", "거래 바구니");
	    model.addAttribute("userType", userType);
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
		

	@PostMapping("/estimateReq") 
	public String previewPage(@RequestParam String cartIds, Model model) {
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
	    List<String> idList = Arrays.asList(cartIds.split(","));
	    List<CartItemDTO> itemList = cartService.selectCartItemListByIds(idList);
	    
	    if (!itemList.isEmpty()) {
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("cartIds", cartIds);
	        model.addAttribute("userType", userType);
	        model.addAttribute("info", itemList.get(0));
	    }
	    
	    return "document/previewEst";
	}

	@PostMapping("/orderReq")
	public String previewOrder(@RequestParam String cartIds, Model model) {
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
	    List<String> idList = Arrays.asList(cartIds.split(","));
	    List<CartItemDTO> itemList = cartService.selectCartItemListByIds(idList);
	    
	    if (!itemList.isEmpty()) {
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("cartIds", cartIds);
	        model.addAttribute("userType", userType);
	        model.addAttribute("info", itemList.get(0));
	    }
	    
	    return "document/previewOrder"; 
	}
			
}
