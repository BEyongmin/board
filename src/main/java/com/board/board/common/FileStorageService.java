package com.board.board.common;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileStorageService {

    private static final List<String> ALLOWED_EXTENSIONS = List.of("jpg", "jpeg", "png", "webp");
    private static final int MAX_FILES_PER_POST = 5;

    @Value("${app.upload-dir}")
    private String uploadDir;

    public String store(MultipartFile file) {
        String originalName = file.getOriginalFilename();
        String extension = extractExtension(originalName);

        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            throw new IllegalArgumentException("허용되지 않는 파일 형식입니다. (jpg, jpeg, png, webp만 가능)");
        }

        String storedName = UUID.randomUUID() + "." + extension;

        try {
            Path targetDir = Path.of(uploadDir);
            Files.createDirectories(targetDir);
            file.transferTo(targetDir.resolve(storedName));
        } catch (IOException e) {
            throw new IllegalStateException("파일 저장에 실패했습니다.", e);
        }

        return storedName;
    }

    public void validateCount(int existingCount, int newCount) {
        if (existingCount + newCount > MAX_FILES_PER_POST) {
            throw new IllegalArgumentException("이미지는 게시글당 최대 " + MAX_FILES_PER_POST + "장까지 첨부할 수 있습니다.");
        }
    }

    private String extractExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            throw new IllegalArgumentException("파일 확장자를 확인할 수 없습니다.");
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
}