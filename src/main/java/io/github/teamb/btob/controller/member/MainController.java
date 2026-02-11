package io.github.teamb.btob.controller.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.service.member.MemberService;
import io.github.teamb.btob.service.notice.NoticeService;
import io.github.teamb.btob.service.adminSupport.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final MemberService memberService;
    private final NoticeService noticeService;
    private final FaqService faqService;
    
    @GetMapping("/")
    public String root() {
        return "redirect:/login"; // 루트 접속 시 로그인 페이지로 리다이렉트
    }
    
    @GetMapping("/main")
    public String mainPage(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails != null) {
            MemberDto member = memberService.getMyInfo(userDetails.getUsername());
            model.addAttribute("member", member);
        }
        model.addAttribute("noticeList", noticeService.getNoticeList(""));
        model.addAttribute("faqList", faqService.getFaqList(null));
        model.addAttribute("content", "testKSH/main.jsp");
        return "layout/layout"; 
    }

    @GetMapping("/api/external/exchange-rate")
    @ResponseBody
    public List<Map<String, String>> getExchangeRate() {
        // 환율정보 API KEY값
        String authKey = "H2Nlu0Co7Qdrz90qLO3mj2oBkT1HC8UN"; 
        List<Map<String, String>> result = new ArrayList<>();
        RestTemplate restTemplate = new RestTemplate();
        
        // 11시 이전이거나 주말일 경우
        for (int i = 0; i < 3; i++) {
            String targetDate = LocalDate.now().minusDays(i).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String url = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=" + authKey + "&searchdate=" + targetDate + "&data=AP01";

            try {
                Map<String, Object>[] response = restTemplate.getForObject(url, Map[].class);
                
                if (response != null && response.length > 0) {
                    for (Map<String, Object> data : response) {
                        String curUnit = (String) data.get("cur_unit");
                        if (curUnit.equals("USD") || curUnit.equals("JPY(100)") || curUnit.equals("EUR")) {
                            result.add(Map.of(
                                "currency", curUnit,
                                "rate", (String) data.get("deal_bas_r"),
                                "name", (String) data.get("cur_nm")
                            ));
                        }
                    }
                    if (!result.isEmpty()) break; // 데이터를 찾았으면 루프 종료
                }
            } catch (Exception e) {
                continue; // 에러 나면 다음 날짜 시도
            }
        }

        // 만약 모든 시도가 실패했다면 최종 방어 코드
        if (result.isEmpty()) {
            result.add(Map.of("currency", "USD", "rate", "1,350.00", "name", "미국 달러(서버점검)"));
        }
        
        return result;
    }

    @GetMapping("/api/external/oil-news")
    @ResponseBody
    public List<Map<String, Object>> getOilNews() {
        String clientId = "5jGzV1YRSsV7VRZwH6de"; 
        String clientSecret = "PLhXABD0aq"; 
        // 쿼리 고도화
        String searchQuery = "국제유가 | 휘발유가격 | 경유값 | 유류시장 | 유가정보 | 휘발유 | 경유";
        String url = "https://openapi.naver.com/v1/search/news.json?query=" + searchQuery + "&display=4&sort=sim";

        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.set("X-Naver-Client-Id", clientId);
            headers.set("X-Naver-Client-Secret", clientSecret);
            HttpEntity<String> entity = new HttpEntity<>(headers);
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
            return (List<Map<String, Object>>) response.getBody().get("items");
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }
}