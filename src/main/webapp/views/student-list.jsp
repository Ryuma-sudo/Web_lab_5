<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List (MVC)</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background-color: #f0f2f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #1e3a8a; border-bottom: 2px solid #3b82f6; padding-bottom: 10px; }
        .message { padding: 10px; margin-bottom: 20px; border-radius: 5px; font-weight: bold; }
        .success { background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        .error { background-color: #f8d7da; color: #842029; border: 1px solid #f5c6cb; }
        .btn-add { display: inline-block; padding: 10px 20px; margin-bottom: 20px; background-color: #10b981; color: white; text-decoration: none; border-radius: 5px; transition: background-color 0.2s; }
        .btn-add:hover { background-color: #059669; }

        /* Search & Filter Styles */
        .controls { display: flex; justify-content: space-between; margin-bottom: 20px; background: #f8fafc; padding: 15px; border-radius: 6px; border: 1px solid #e2e8f0; }
        .search-box, .filter-box { display: flex; align-items: center; gap: 10px; }
        input[type="text"], select { padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; }
        button { padding: 8px 15px; background-color: #3b82f6; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #2563eb; }
        .clear-link { color: #64748b; text-decoration: underline; font-size: 0.9rem; margin-left: 5px; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background-color: #3b82f6; color: white; font-weight: 600; }

        /* Sortable Header Links */
        th a { color: white; text-decoration: none; display: flex; justify-content: space-between; align-items: center; }
        th a:hover { text-decoration: underline; }

        tr:hover { background-color: #f9fafb; }
        .action-link { color: #3b82f6; text-decoration: none; margin-right: 15px; font-weight: 500; }
        .delete-link { color: #ef4444; }
    </style>
</head>
<body>
<div class="container">
    <h1>📚 Student Management (MVC)</h1>

    <c:if test="${not empty param.message}">
        <div class="message success"><p>✅ ${param.message}</p></div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="message error"><p>❌ ${param.error}</p></div>
    </c:if>

    <a href="student?action=new" class="btn-add">➕ Add New Student</a>

    <div class="controls">
        <div class="search-box">
            <form action="student" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Name, code, or email..." value="${keyword}">
                <button type="submit">🔍 Search</button>
                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="clear-link">Clear</a>
                </c:if>
            </form>
        </div>

        <div class="filter-box">
            <form action="student" method="get">
                <input type="hidden" name="action" value="filter">
                <select name="major">
                    <option value="">-- Select Major --</option>
                    <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                    <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                    <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                </select>
                <button type="submit">Filter</button>
                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" class="clear-link">Clear</a>
                </c:if>
            </form>
        </div>
    </div>

    <c:if test="${not empty keyword}">
        <p style="margin-bottom: 10px;">Search results for: <strong>${keyword}</strong></p>
    </c:if>

    <table>
        <thead>
        <tr>
            <th>
                <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}">
                    ID <c:if test="${sortBy == 'id'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                </a>
            </th>
            <th>
                <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}">
                    Code <c:if test="${sortBy == 'student_code'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                </a>
            </th>
            <th>
                <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}">
                    Name <c:if test="${sortBy == 'full_name'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                </a>
            </th>
            <th>
                <a href="student?action=sort&sortBy=email&order=${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}">
                    Email <c:if test="${sortBy == 'email'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                </a>
            </th>
            <th>
                <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}">
                    Major <c:if test="${sortBy == 'major'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                </a>
            </th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
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
                    <a href="student?action=delete&id=${s.id}" class="action-link delete-link" onclick="return confirm('Are you sure you want to delete ${s.fullName}?')">🗑️ Delete</a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty students}">
            <tr>
                <td colspan="7" style="text-align: center; color: #6b7280; padding: 30px;">
                    No students found matching your criteria.
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>