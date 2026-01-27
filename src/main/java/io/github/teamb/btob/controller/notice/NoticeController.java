package io.github.teamb.btob.controller.notice;

import io.github.teamb.btob.entity.Notice;
import io.github.teamb.btob.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeService noticeService;

    // 목록 조회 (검색 포함)
    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Notice> list = noticeService.getNoticeList(keyword);
        model.addAttribute("notices", list);
        return "testKSH/noticeList";
    }

    // 상세 조회
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Integer id, Model model) {
        Notice notice = noticeService.getNoticeDetail(id);
        model.addAttribute("notice", notice);
        return "testKSH/noticeDetail";
    }

    // 공지사항 등록 처리 (관리자용)
    @PostMapping("/write")
    public String write(Notice notice, 
                        @RequestParam("files") List<MultipartFile> files,
                        @AuthenticationPrincipal UserDetails userDetails) {
        
        // 작성자 정보 세팅 (Spring Security 세션에서 가져옴)
        notice.setRegId(userDetails.getUsername());
        notice.setUpdId(userDetails.getUsername());
        
        // TODO: 첨부파일 저장 로직 추가 필요
        
        noticeService.saveNotice(notice);
        return "redirect:/notice";
    }
}