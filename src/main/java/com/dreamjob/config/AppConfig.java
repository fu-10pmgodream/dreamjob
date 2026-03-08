package com.dreamjob.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class AppConfig implements WebMvcConfigurer {

    @Value("${upload.dir:uploads}")
    private String uploadDir;

    // ===================== BCrypt Bean =====================
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // ===================== Static Resources =====================
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");

        // Serve file upload local qua URL /uploads/**
        String uploadPath = uploadDir.startsWith("/") || uploadDir.matches("[A-Za-z]:.*")
                ? uploadDir // đường dẫn tuyệt đối
                : System.getProperty("user.dir") + "/" + uploadDir; // tương đối → tuyệt đối
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath + "/");
    }

    // ===================== Auth Interceptor =====================
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor())
                .addPathPatterns("/admin/**", "/recruiter/**", "/jobseeker/**")
                .excludePathPatterns("/auth/**", "/home/**", "/jobs/**", "/static/**");
    }
}