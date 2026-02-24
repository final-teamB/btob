package io.github.teamb.btob.service.cart;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductCurrVolDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {
	private final CartMapper cartMapper;
	private final LoginUserProvider loginUserProvider;
	private final ProductManagementService productManagementService;
	
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
		String userId = loginUserProvider.getLoginUserId();
	    dto.setUserId(userId);
	    
	    int reqCount = cartMapper.checkAnyRequestStatus(userId, "REQ");
	    if (reqCount > 0) {
	        throw new RuntimeException("이미 처리 중인 주문/견적 요청이 있습니다. 완료 후 이용해주세요.");
	    }

	    // [추가 로직 2] 바로 주문/견적('Y') 시 장바구니에 이미 상품(use_yn='Y')이 있는지 체크
	    if ("Y".equals(dto.getIsDirect())) {
	        int activeCartCount = cartMapper.checkActiveCartCount(userId);
	        if (activeCartCount > 0) {
	            throw new RuntimeException("거래바구니에 상품이 있습니다. 거래바구니를 비우고 다시 진행해주세요.");
	        }
	    }
	    
	   /* if (dto.getTotalQty() < 1) {
	        throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
	    }

	    // [추가] 재고 차감 시도
	    UpdateProductCurrVolDTO volDTO = new UpdateProductCurrVolDTO();
	    volDTO.setFuelId(dto.getFuelId());
	    volDTO.setOrderQty(dto.getTotalQty());
	    volDTO.setRequestType("DOWN");
	    try {
	        productManagementService.modifyProductCurrVol(volDTO);
	    } catch (Exception e) {
	        throw new RuntimeException("재고 수정 실패: " + e.getMessage());
	    }
	    */

	    // 1. 이미 담긴 상품인지 확인
	    CartItemInsertDTO existItem = cartMapper.selectExistingCartItem(dto);

	    if (existItem == null) {
	    	dto.setTotalPrice(dto.getTotalQty() * dto.getBaseUnitPrc());
	        dto.setCartStatus("PENDING");
	        cartMapper.insertCartItem(dto);
	    } else {
	        // 수량 누적 처리
	        int newQty = existItem.getTotalQty() + dto.getTotalQty();
	        existItem.setTotalQty(newQty);
	        existItem.setTotalPrice(newQty * dto.getBaseUnitPrc());
	        cartMapper.updateCartItem(existItem);
	    }
	}

	@Override
	public void updateCartItemQty(CartItemInsertDTO dto) {
	    dto.setUserId(loginUserProvider.getLoginUserId());
	    
	    // 1. 기존 장바구니 정보를 조회하여 이전 수량 확인 (Mapper에 해당 메서드 필요)
	    // 예: selectCartItemOne(cartId)
	    /*
	    CartItemDTO currentItem = cartMapper.selectCartItemById(dto.getCartId()); 
	    int diffQty = dto.getTotalQty() - currentItem.getTotalQty();

	    if (diffQty != 0) {
	        UpdateProductCurrVolDTO volDTO = new UpdateProductCurrVolDTO();
	        volDTO.setFuelId(dto.getFuelId());
	        volDTO.setOrderQty(Math.abs(diffQty)); // 차이값의 절대값만큼 조정
	        
	        // 늘어났으면 DOWN(차감), 줄어들었으면 UP(복구)
	        if (diffQty > 0) {
	            volDTO.setRequestType("DOWN");
	        } else {
	            volDTO.setRequestType("UP");
	            volDTO.setOrderStatus("pr999"); // [중요] DB에 실존하는 코드로 검증 통과
	        }

	        try {
	            productManagementService.modifyProductCurrVol(volDTO);
	        } catch (Exception e) {
	            throw new RuntimeException("재고 수정 중 오류 발생: " + e.getMessage());
	        }
	    }
        */
	    cartMapper.updateCartItem(dto);    
	}

	@Override
	public void deleteCartItem(int cartId) {
	    // 1. 삭제 전 수량을 알아야 재고를 복구하므로 먼저 조회
		/*
	    CartItemDTO item = cartMapper.selectCartItemById(cartId);
	    
	    if (item != null) {
	        UpdateProductCurrVolDTO volDTO = new UpdateProductCurrVolDTO();
	        volDTO.setFuelId(item.getFuelId());
	        volDTO.setOrderQty(item.getTotalQty());
	        volDTO.setRequestType("UP"); // 장바구니 삭제이므로 재고 다시 증가
	        volDTO.setOrderStatus("pr999");

	        try {
	            productManagementService.modifyProductCurrVol(volDTO);
	        } catch (Exception e) {
	        	throw new RuntimeException("재고 복구 실패: " + e.getMessage());
	        }
	    }
	    */

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

	@Override
	public int getCartCount(String userId) {
		return cartMapper.getCartCount(userId);
	}
	
	
}
