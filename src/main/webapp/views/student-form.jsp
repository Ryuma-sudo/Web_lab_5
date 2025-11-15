<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <!-- Dynamic Title using c:choose -->
        <c:choose>
            <c:when test="${student != null}">Edit Student: ${student.fullName}</c:when>
            <c:otherwise>Add New Student</c:otherwise>
        </c:choose>
    </title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background-color: #f0f2f5; }
        .container { max-width: 600px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h2 { color: #1e3a8a; margin-bottom: 25px; border-bottom: 1px solid #e5e7eb; padding-bottom: 10px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: 600; color: #374151; }
        input[type="text"], input[type="email"] { width: 100%; padding: 10px; border: 1px solid #d1d5db; border-radius: 4px; box-sizing: border-box; }
        input[readonly] { background-color: #f3f4f6; cursor: not-allowed; }
        .btn-submit { background-color: #10b981; color: white; padding: 12px 25px; border: none; border-radius: 5px; cursor: pointer; margin-right: 10px; transition: background-color 0.2s; }
        .btn-cancel { background-color: #6b7280; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; display: inline-block; }
        .btn-submit:hover { background-color: #059669; }
        .error { color: #ef4444; font-size: 0.875rem; display: block; margin-top: 5px; }
    </style>
</head>
<body>
<div class="container">
    <!-- Dynamic Heading -->
    <h2>
        <c:choose>
            <c:when test="${student != null}">✏️ Edit Student</c:when>
            <c:otherwise>➕ Add New Student</c:otherwise>
        </c:choose>
    </h2>

    <form action="student" method="POST">

        <!-- Hidden field for action (insert or update) -->
        <input type="hidden" name="action"
               value="<c:out value="${student != null ? 'update' : 'insert'}"/>">

        <!-- Hidden field for ID (ONLY if editing) -->
        <c:if test="${student != null}">
            <input type="hidden" name="id" value="${student.id}">
        </c:if>

        <div class="form-group">
            <label for="studentCode">Student Code *</label>
            <input type="text" id="studentCode" name="studentCode"
                   value="${student.studentCode}"
                   <c:if test="${student != null}">readonly</c:if>
                   required>
            <c:if test="${student != null}"><small style="color: #666;">Student code cannot be changed.</small></c:if>
        </div>

        <div class="form-group">
            <label for="fullName">Full Name *</label>
            <input type="text" id="fullName" name="fullName"
                   value="${student.fullName}" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   value="${student.email}">
        </div>

        <div class="form-group">
            <label for="major">Major *</label>
            <input type="text" id="major" name="major"
                   value="${student.major}" required>
        </div>

        <!-- Submit button with dynamic text -->
        <button type="submit" class="btn-submit">
            <c:choose>
                <c:when test="${student != null}">💾 Update Student</c:when>
                <c:otherwise>💾 Save Student</c:otherwise>
            </c:choose>
        </button>
        <a href="student?action=list" class="btn-cancel">Cancel</a>
    </form>
</div>
</body>
</html>