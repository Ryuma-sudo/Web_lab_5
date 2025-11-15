<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List (MVC)</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background-color: #f0f2f5; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #1e3a8a; border-bottom: 2px solid #3b82f6; padding-bottom: 10px; }
        .message { padding: 10px; margin-bottom: 20px; border-radius: 5px; font-weight: bold; }
        .success { background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        .error { background-color: #f8d7da; color: #842029; border: 1px solid #f5c6cb; }
        .btn-add { display: inline-block; padding: 10px 20px; margin-bottom: 20px; background-color: #10b981; color: white; text-decoration: none; border-radius: 5px; transition: background-color 0.2s; }
        .btn-add:hover { background-color: #059669; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background-color: #3b82f6; color: white; font-weight: 600; }
        tr:hover { background-color: #f9fafb; }
        .action-link { color: #3b82f6; text-decoration: none; margin-right: 15px; font-weight: 500; }
        .delete-link { color: #ef4444; }
    </style>
</head>
<body>
<div class="container">
    <h1>📚 Student Management (MVC)</h1>

    <!-- Display success message if param.message exists (JSTL <c:if>) -->
    <c:if test="${not empty param.message}">
        <div class="message success">
            <p>✅ ${param.message}</p>
        </div>
    </c:if>

    <!-- Display error message if param.error exists -->
    <c:if test="${not empty param.error}">
        <div class="message error">
            <p>❌ ${param.error}</p>
        </div>
    </c:if>

    <a href="student?action=new" class="btn-add">➕ Add New Student</a>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Code</th>
            <th>Name</th>
            <th>Email</th>
            <th>Major</th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <!-- Use c:forEach to loop through students -->
        <c:forEach var="s" items="${students}">
            <tr>
                <td>${s.id}</td>
                <td>${s.studentCode}</td>
                <td>${s.fullName}</td>
                <td>${s.email}</td>
                <td>${s.major}</td>
                <td>${s.createdAt}</td>
                <td>
                    <a href="student?action=edit&id=${s.id}" class="action-link">✏️ Edit</a>
                    <a href="student?action=delete&id=${s.id}"
                       class="action-link delete-link"
                       onclick="return confirm('Are you sure you want to delete ${s.fullName}?')">🗑️ Delete</a>
                </td>
            </tr>
        </c:forEach>

        <!-- Handle empty list with c:if -->
        <c:if test="${empty students}">
            <tr>
                <td colspan="7" style="text-align: center; color: #6b7280; padding: 30px;">
                    No students found. Please add a new student.
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>