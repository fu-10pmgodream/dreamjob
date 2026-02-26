package com.dreamjob.util;

import com.dreamjob.model.User;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class để làm việc với Session
 */
public class SessionUtil {

    public static final String SESSION_USER_KEY = "currentUser";

    public static void setCurrentUser(HttpSession session, User user) {
        session.setAttribute(SESSION_USER_KEY, user);
    }

    public static User getCurrentUser(HttpSession session) {
        if (session == null)
            return null;
        return (User) session.getAttribute(SESSION_USER_KEY);
    }

    public static boolean isLoggedIn(HttpSession session) {
        return getCurrentUser(session) != null;
    }

    public static boolean isAdmin(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null && user.isAdmin();
    }

    public static boolean isRecruiter(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null && user.isRecruiter();
    }

    public static boolean isJobSeeker(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null && user.isJobSeeker();
    }

    public static void logout(HttpSession session) {
        session.invalidate();
    }

    public static Integer getCurrentUserId(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null ? user.getUserId() : null;
    }
}