package io.github.teamb.btob.service.attachfile.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.mapper.attachfile.AtchFileMapper;
import io.github.teamb.btob.service.attachfile.FileService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {

	// properti path chk
    @Value("${file.upload-dir2}")
    private String uploadDir;

    private final AtchFileMapper fileMapper;

    /**
     * 
     * 다중 파일 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param files
     * @param refTypeCd
     * @param refId
     * @return 다중 파일 업로드 정보 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public List<AtchFileDto> uploadFiles(List<MultipartFile> files, 
    										String refTypeCd, 
    										int refId) throws Exception {
    	
        List<AtchFileDto> resultList = new ArrayList<>();
        
        if (files == null || files.isEmpty()) {
        	return resultList;
        }

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                resultList.add(this.uploadFile(file, refTypeCd, refId));
            }
        }
        
        return resultList;
    }

    
    /**
     * 
     * 단일 파일 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param file
     * @param refTypeCd
     * @param refId
     * @return 파일 업로드 정보
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public AtchFileDto uploadFile(MultipartFile file, 
    								String refTypeCd, 
    								int refId) throws Exception {
    	// 원본파일명
        String orgFileNm = file.getOriginalFilename();
        // 확장자
        String ext = orgFileNm.substring(orgFileNm.lastIndexOf(".") + 1);
        // 변경파일명
        String strFileNm = UUID.randomUUID().toString() + "." + ext;
        
        // 디렉토리가 없다면 디렉토리 생성
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        // 디렉토리에 파일 저장 처리
        File target = new File(uploadDir, strFileNm);
        file.transferTo(target);

        AtchFileDto dto = new AtchFileDto();
        dto.setOrgFileNm(orgFileNm);
        dto.setStrFileNm(strFileNm);
        dto.setFilePath(new File(uploadDir, strFileNm).getAbsolutePath());
        dto.setFileExt(ext);
        dto.setFileSize(file.getSize());
        dto.setRefTypeCd(refTypeCd);
        dto.setRefId(refId);

        fileMapper.insertFile(dto);
        return dto;
    }

    /**
     * 
     * 참조 대상별 파일 목록 조회
     * @author GD
     * @since 2026. 1. 26.
     * @param refTypeCd
     * @param refId
     * @return 참조 대상별 파일 목록 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public List<AtchFileDto> getFilesByRef(String refTypeCd, int refId) throws Exception {
    	
        Map<String, Object> param = new HashMap<>();
        param.put("refTypeCd", refTypeCd);
        param.put("refId", refId);
        
        return fileMapper.selectFileListByRef(param);
    }

    /**
     * 
     * 파일 단건 상세조회 ( 다운로드용 )
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public AtchFileDto getFile(int fileId) throws Exception {
    	
        return fileMapper.selectFileById(fileId);
    }
    
    /**
     * 
     * 파일 정보 삭제 ( 미사용으로 미표출 처리 )
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public void deleteFile(int fileId) throws Exception {
    	
        int result = fileMapper.deleteFileById(fileId);
        
        if (result < 1) {
        	
            throw new Exception("파일 삭제 처리 중 오류가 발생했습니다.");
        }
    }
}
