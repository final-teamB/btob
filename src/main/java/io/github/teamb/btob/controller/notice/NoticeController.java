package io.github.teamb.btob.controller.notice;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import io.github.teamb.btob.entity.Notice;
import io.github.teamb.btob.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeService noticeService;
    private final String uploadPath = "C:/uploads/"; // 파일 저장 경로

    // 일반 사용자가 보는 목록 
    @GetMapping("/user/list") 
    public String userList(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Notice> list = noticeService.getNoticeList(keyword);
        model.addAttribute("noticeList", list); 
        model.addAttribute("content", "testKSH/noticeUserList.jsp"); // 사용자용 리스트 JSP
        return "layout/layout";
    }

    // 일반 사용자가 보는 상세 
    @GetMapping("/user/detail/{id}")
    public String userDetail(@PathVariable("id") Integer id, Model model) {
        Notice notice = noticeService.getNoticeDetail(id);
        model.addAttribute("notice", notice);
        model.addAttribute("content", "testKSH/noticeDetail.jsp"); // 사용자용 상세 JSP
        return "layout/layout";
    }
    
    // 목록 조회 (검색 포함)
    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Notice> list = noticeService.getNoticeList(keyword);
        model.addAttribute("noticeList", list); 
        model.addAttribute("content", "testKSH/noticeList.jsp");
        return "layout/layout";
    }

    // 공지사항 등록 처리 (관리자용)
    @PostMapping("/write")
    public String write(Notice notice, 
                        @RequestParam("files") List<MultipartFile> files,
                        @AuthenticationPrincipal UserDetails userDetails) throws IOException {
        
        notice.setRegId(userDetails.getUsername());
        notice.setUpdId(userDetails.getUsername());
        
        // 글 저장 실행
        noticeService.saveNotice(notice);

        // 첨부파일 저장 로직
        if (files != null && !files.isEmpty()) {
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    file.transferTo(new File(uploadPath + savedFileName));
                    
                    // DB에 파일 정보 저장 로직 필요 (예: noticeService.saveFileInfo(notice.getNoticeId(), originalFileName, savedFileName))
                }
            }
        }
        
        return "redirect:/notice";
    }

    // 파일 다운로드 실행
    @GetMapping("/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) throws IOException {
        UrlResource resource = new UrlResource("file:" + uploadPath + fileName);
        String encodedFileName = UriUtils.encode(fileName.substring(fileName.indexOf("_") + 1), StandardCharsets.UTF_8);
        String contentDisposition = "attachment; filename=\"" + encodedFileName + "\"";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
                .body(resource);
    }
    
    // 수정 페이지 이동
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Integer id, Model model) {
    	Notice notice;
        
        if (id == null || id == 0) {
            notice = new Notice(); 
        } else {
            notice = noticeService.getNoticeDetail(id);
        }

        model.addAttribute("notice", notice);
        
        if (model.getAttribute("files") == null) {
            model.addAttribute("files", new ArrayList<>());
        }

        model.addAttribute("content", "testKSH/noticeEdit.jsp");
        return "layout/layout";
    }

    // 수정 실행
    @PostMapping("/update")
    public String update(Notice notice, @AuthenticationPrincipal UserDetails userDetails) {
        notice.setUpdId(userDetails.getUsername());
        noticeService.updateNotice(notice);
        return "redirect:/notice/edit/" + notice.getNoticeId();
    }

    // 삭제 실행
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        noticeService.deleteNotice(id);
        return "redirect:/notice";
    }
}