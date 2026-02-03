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
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {

	// properti path chk
    @Value("${file.upload-dir2}")
    private String uploadDir;

    private final CommonService commonService;
    private final AtchFileMapper fileMapper;

    /**
     * 
     * 다중 파일 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param files
     * @param systmeId
     * @param refId
     * @return 다중 파일 업로드 정보 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public List<AtchFileDto> uploadFiles(List<MultipartFile> files, 
    										String systmeId, 
    										Integer refId) throws Exception {
    	
        List<AtchFileDto> resultList = new ArrayList<>();
        
        if (files == null || files.isEmpty()) {
        	return resultList;
        }

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                resultList.add(this.uploadFile(file, systmeId, refId));
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
     * @param systmeId
     * @param refId
     * @return 파일 업로드 정보
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public AtchFileDto uploadFile(MultipartFile file, 
    								String systmeId, 
    								Integer refId) throws Exception {
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
        dto.setSystemId(systmeId);
        dto.setRefId(refId);

        fileMapper.insertFile(dto);
        return dto;
    }
    
    
    /**
     * 
     * 파일 다운로드
     * @author GD
     * @since 2026. 2. 3.
     * @param fileId
     * @param systemId
     * @param refId
     * @return fileDto
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 3.  GD       최초 생성
     */
    @Override
	public AtchFileDto getFileForDownload(Integer fileId, 
								Integer systemId, 
								Integer refId) throws Exception {
		
    	Map<String, Integer> params = new HashMap<>();
    	params.put("fileId", fileId);
    	params.put("systemId", systemId);
    	params.put("Integer", refId);
    	
    	if ( !(commonService.nullEmptyChkValidate(params)) ) {
    		throw new Exception("잘못된 파라미터 입니다.");
    	}
    	
    	// 1. DB에서 파일 정보 조회
        AtchFileDto fileDto = fileMapper.selectFileById(params);
        
        // 2. 파일 정보 검증
        if (fileDto == null || fileDto.getFilePath() == null) {
            throw new Exception("파일 정보가 없습니다.");
        }
    	
        // 3. 물리적 파일 존재 확인
        File file = new File(fileDto.getFilePath());
        if (!file.exists()) {
            throw new Exception("서버에 실제 파일이 존재하지 않습니다.");
        }
    	
		return fileDto;
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
    public void deleteFile(Integer fileId) throws Exception {
    	
        Integer result = fileMapper.deleteFileById(fileId);
        
        if (result < 1) {
        	
            throw new Exception("파일 삭제 처리 중 오류가 발생했습니다.");
        }
    }
}
