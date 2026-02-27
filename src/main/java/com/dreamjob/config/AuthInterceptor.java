package com.dreamjob.config;

import com.dreamjob.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Session-based Authentication & Authorization Interceptor
 * Bảo vệ các routes: /admin/**, /recruiter/**, /jobseeker/**
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        // Chưa đăng nhập
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirected=true");
            return false;
        }

        User user = (User) session.getAttribute("currentUser");
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // Kiểm tra quyền theo route
//        if (requestURI.startsWith(contextPath + "/admin/") && !user.isAdmin()) {
//            response.sendRedirect(contextPath + "/home?error=forbidden");
//            return false;
//        }
//
//        if (requestURI.startsWith(contextPath + "/recruiter/") && !user.isRecruiter()) {
//            response.sendRedirect(contextPath + "/home?error=forbidden");
//            return false;
//        }
//
//        if (requestURI.startsWith(contextPath + "/jobseeker/") && !user.isJobSeeker()) {
//            response.sendRedirect(contextPath + "/home?error=forbidden");
//            return false;
//        }

        return true;
    }
}