package io.github.teamb.btob.service.cart;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;

@Service
@Transactional
public class CartServiceImpl implements CartService {
	private final CartMapper cartMapper;
	private final LoginUserProvider loginUserProvider;
	
	public CartServiceImpl(CartMapper cartMapper, LoginUserProvider loginUserProvider) {
		this.cartMapper = cartMapper;
		this.loginUserProvider = loginUserProvider;
	}
	
	@Override
	public List<CartItemDTO> getCartItemList(String orderNo) {
	    String userId = loginUserProvider.getLoginUserId();
	    
	    // 1. 우선 현재 장바구니 리스트를 가져옵니다. (Mapper에서 status까지 Join해서 가져옴)
	    List<CartItemDTO> cartList = cartMapper.selectCartItemList(userId);

	    // 2. 비즈니스 로직 처리: 결제 완료(ORDERED)된 건이 있으면 장바구니를 정리(Soft Delete)
	    if (cartList != null && !cartList.isEmpty()) {
	        // 첫 번째 아이템의 상태를 기준으로 판단 (동일 주문번호 공유 가정)
	        CartItemDTO firstItem = cartList.get(0);
	        
	        // 만약 cart_status가 ORDERED이거나, 
	        // 마스터 테이블의 status가 결제 완료(예: pr003 등)라면 정리 실행
	        if ("ORDERED".equals(firstItem.getCartStatus()) && orderNo != null) {
	            cartMapper.clearCart(userId, orderNo);
	            // 정리 후엔 빈 리스트를 반환하여 화면에 "장바구니가 비었습니다"가 나오게 함
	            return new ArrayList<>();
	        }
	    }

	    return cartList;
	}

	@Override
	public void addToCart(CartItemInsertDTO dto) { 
		dto.setUserId(loginUserProvider.getLoginUserId());
		// 안전장치
	    if (dto.getTotalQty() < 1) {
	        throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
	    }
			
		// 1. 이미 담긴 상품인지 확인
        CartItemInsertDTO existItem = cartMapper.selectExistingCartItem(dto); // userId + fuelId + PENDING

        if (existItem == null) {
            // 신규 담기
        	dto.setTotalPrice(dto.getTotalQty() * dto.getBaseUnitPrc());
            dto.setCartStatus("PENDING");
            cartMapper.insertCartItem(dto);
        } else {
            // 수량 누적
            int newQty = existItem.getTotalQty() + dto.getTotalQty();
            existItem.setTotalQty(newQty);
            int newPrice = newQty * dto.getBaseUnitPrc();
            existItem.setTotalPrice(newPrice);
                    
            cartMapper.updateCartItem(existItem);
        }
		
	}

	@Override
	public void updateCartItemQty(CartItemInsertDTO dto) {
		dto.setTotalPrice(dto.getTotalQty() * dto.getBaseUnitPrc());
        cartMapper.updateCartItem(dto);	
	}
	
	@Override
	public void deleteCartItem(int cartId) {
		cartMapper.deleteCartItem(cartId, loginUserProvider.getLoginUserId());		
	}
	
	// ordered 카트 목록 비우기
	@Override
	public void clearCart(String userId, String orderNo) {
		cartMapper.clearCart(userId, orderNo);		
	}

	@Override
	public List<CartItemDTO> selectCartItemListByIds(List<String> idList) {
		return cartMapper.selectCartItemListByIds(idList);
	}
	
	
}
