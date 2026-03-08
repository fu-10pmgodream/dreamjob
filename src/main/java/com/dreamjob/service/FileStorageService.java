package com.dreamjob.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileStorageService {

    @Value("${upload.dir:uploads}")
    private String uploadDir;

    /**
     * Lưu file lên thư mục local
     *
     * @param file   File từ request
     * @param folder Thư mục con (vd: 'logos', 'cvs')
     * @return Đường dẫn URL tương đối để truy cập file, hoặc null nếu lỗi
     */
    public String uploadFile(MultipartFile file, String folder) {
        if (file == null || file.isEmpty())
            return null;

        try {
            // Tạo thư mục nếu chưa tồn tại
            Path dirPath = Paths.get(uploadDir, folder);
            Files.createDirectories(dirPath);

            // Tạo tên file duy nhất để tránh trùng lặp
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + extension;

            // Lưu file
            Path filePath = dirPath.resolve(uniqueFileName);
            Files.copy(file.getInputStream(), filePath);

            // Trả về URL tương đối để sử dụng trong img src
            return "/uploads/" + folder + "/" + uniqueFileName;

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Xóa file khỏi thư mục local
     *
     * @param relativePath Đường dẫn tương đối của file (vd: /uploads/logos/xxx.jpg)
     */
    public void deleteFile(String relativePath) {
        if (relativePath == null || relativePath.isBlank())
            return;
        try {
            // Chuyển từ URL path sang file path thực
            String filePath = relativePath.replaceFirst("^/uploads/", "");
            Path path = Paths.get(uploadDir, filePath);
            Files.deleteIfExists(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
