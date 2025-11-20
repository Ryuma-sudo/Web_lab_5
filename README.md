## Lab 5: Code Flow Report (Exercises 1-7)

This report traces the end-to-end execution flow for the core CRUD operations as well as the advanced Search, Validation, and Sorting/Filtering features. The flow demonstrates the MVC (Model-View-Controller) pattern, showing how each layer interacts to fulfill a user request.

**Core Components:**
* **Model:** `Student.java` (Data Structure), `StudentDAO.java` (Data Access)
* **View:** `student-list.jsp`, `student-form.jsp`
* **Controller:** `StudentController.java`

---

### 1. READ Operation: List All Students

This flow is the default action for the application, displaying all students in the database.

1.  **Request:** The user navigates to `.../student`. Tomcat receives a `GET` request.
2.  **Controller (Routing):** The `StudentController`, mapped to `/student`, catches the request. Its `doGet` method is called. The `action` parameter is `null`, so it defaults to `"list"`.
3.  **Controller (Logic):** The `switch` statement calls the private `listStudents` method.
4.  **DAO (Data Access):** `listStudents` calls `studentDAO.getAllStudents()`. The DAO connects to the database and executes the SQL query `SELECT * FROM students ORDER BY id DESC`.
5.  **Model (Data Mapping):** The DAO iterates through the `ResultSet`, creates a `Student` object for each row, and returns a `List<Student>`.
6.  **Controller (View Dispatch):** `listStudents` receives the list and attaches it to the request: `request.setAttribute("students", students)`.
7.  **Controller (View Dispatch):** It then forwards the request (along with the data) to the JSP view: `request.getRequestDispatcher("/views/student-list.jsp").forward(...)`.
8.  **View (Rendering):** `student-list.jsp` uses JSTL `<c:forEach var="student" items="${students}">` to loop through the list and EL (`${student.fullName}`) to display each student's data in the HTML table.
9.  **Response:** The server sends the fully rendered HTML page to the browser.

---

### 2. CREATE Operation: Add New Student

This is a two-phase operation: showing the form (GET) and processing the submission (POST).

#### Phase A: Show New Form (GET)

1.  **Request:** User clicks the "Add New Student" link, sending a `GET` request to `.../student?action=new`.
2.  **Controller (Routing):** `doGet` reads `action="new"` and calls the `showNewForm` method.
3.  **Controller (View Dispatch):** `showNewForm` simply forwards the request to the form page: `request.getRequestDispatcher("/views/student-form.jsp").forward(...)`.
4.  **View (Rendering):** `student-form.jsp` renders. Since the `${student}` object is `null`, JSTL `<c:choose>` displays "Add New Student" as the title, and the hidden action field is set to `value="insert"`.

#### Phase B: Process Form (POST)

1.  **Request:** User submits the form, sending a `POST` request to `.../student`. The form body includes `action=insert` and the new student's data.
2.  **Controller (Routing):** `doPost` is called. It reads `action="insert"` and routes to the `insertStudent` method.
3.  **Controller (Logic):** `insertStudent` reads the form data (`request.getParameter(...)`) and creates a new `Student` object.
4.  **Validation Check:** *(See Section 6 below)*. If validation passes...
5.  **DAO (Data Access):** The controller calls `studentDAO.addStudent(newStudent)`. The DAO executes the `INSERT INTO students (...) VALUES (?, ?, ?, ?)` PreparedStatement.
6.  **Controller (Redirect):** On success, `insertStudent` performs a **Post-Redirect-Get (PRG)** by calling `response.sendRedirect("student?action=list&message=Student added successfully")`.
7.  **Response:** The browser receives a 302 Redirect and makes a *new GET* request, triggering the full **READ Operation** flow again, now displaying the updated list and a success message.

---

### 3. UPDATE Operation: Edit Student

This is also a two-phase operation, similar to CREATE.

#### Phase A: Show Edit Form (GET)

1.  **Request:** User clicks an "Edit" link, sending a `GET` request to `.../student?action=edit&id=5`.
2.  **Controller (Routing):** `doGet` reads `action="edit"` and calls the `showEditForm` method.
3.  **DAO (Data Access):** `showEditForm` reads the `id` parameter and calls `studentDAO.getStudentById(id)`. The DAO executes `SELECT * FROM students WHERE id = ?`.
4.  **Model (Data Mapping):** The DAO returns a single `Student` object populated with data for ID 5.
5.  **Controller (View Dispatch):** `showEditForm` attaches this object to the request: `request.setAttribute("student", existingStudent)`.
6.  **Controller (View Dispatch):** It forwards to `/views/student-form.jsp`.
7.  **View (Rendering):** `student-form.jsp` renders. Since `${student}` is *not null*, JSTL (`<c:choose>`, `<c:if>`) displays "Edit Student", pre-populates fields (e.g., `value="${student.fullName}"`), includes the hidden `id` field, and sets the hidden action to `value="update"`.

#### Phase B: Process Update (POST)

1.  **Request:** User submits the modified form. A `POST` request is sent to `.../student` with `action=update`, the `id`, and all form data.
2.  **Controller (Routing):** `doPost` reads `action="update"` and calls the `updateStudent` method.
3.  **Controller (Logic):** `updateStudent` creates a `Student` object with the updated information.
4.  **Validation Check:** *(See Section 6 below)*. If validation passes...
5.  **DAO (Data Access):** The controller calls `studentDAO.updateStudent(student)`. The DAO executes the `UPDATE students SET ... WHERE id = ?` PreparedStatement.
6.  **Controller (Redirect):** On success, `updateStudent` calls `response.sendRedirect("student?action=list&message=Student updated successfully")` (PRG).
7.  **Response:** The browser makes a new GET request, triggering the **READ Operation** flow again.

---

### 4. DELETE Operation: Remove Student

This is a single-step `GET` request operation.

1.  **Request:** User clicks a "Delete" link (after a JavaScript `confirm()` dialog), sending a `GET` request to `.../student?action=delete&id=5`.
2.  **Controller (Routing):** `doGet` reads `action="delete"` and calls the `deleteStudent` method.
3.  **Controller (Logic):** `deleteStudent` reads the `id` parameter from the request.
4.  **DAO (Data Access):** The controller calls `studentDAO.deleteStudent(id)`. The DAO executes the `DELETE FROM students WHERE id = ?` PreparedStatement.
5.  **Controller (Redirect):** On success, `deleteStudent` calls `response.sendRedirect("student?action=list&message=Student deleted successfully")`.
6.  **Response:** The browser makes a new GET request, triggering the **READ Operation** flow again, showing the list without the deleted student.

---

### 5. SEARCH Operation: Find Students

This flow allows users to find students by code, name, or email.

1.  **Request:** User types a keyword (e.g., "John") and submits the search form. A `GET` request is sent to `.../student?action=search&keyword=John`.
2.  **Controller (Routing):** `doGet` reads `action="search"` and calls the `searchStudents` method.
3.  **Controller (Logic):** `searchStudents` retrieves the `keyword` parameter. It checks if the keyword is null or empty (if so, it defaults to listing all students).
4.  **DAO (Data Access):** The controller calls `studentDAO.searchStudents(keyword)`.
5.  **DAO (SQL):** The DAO executes a `SELECT` query with `LIKE` operators: `... WHERE student_code LIKE ? OR full_name LIKE ? OR email LIKE ?`. The keyword is wrapped in wildcards (`%John%`).
6.  **Controller (View Dispatch):** The controller sets two attributes:
    * `students`: The list of matching results.
    * `keyword`: The search term (to preserve it in the input box).
7.  **View (Rendering):** `student-list.jsp` renders. The `<input>` field displays `value="${keyword}"`, and the table displays only the matching students. A "Clear" link is conditionally displayed via `<c:if test="${not empty keyword}">`.

---

### 6. VALIDATION Logic: Data Integrity

This logic intercepts the **CREATE** and **UPDATE** flows to ensure valid data entry.

1.  **Context:** The user submits the form (POST request to `insert` or `update`).
2.  **Controller (Logic):** Inside `insertStudent` or `updateStudent`, the code calls `validateStudent(student, request)`.
3.  **Validation Method:** This private method checks specific rules:
    * **Code:** Must match regex `[A-Z]{2}[0-9]{3,}` (e.g., SV001).
    * **Name:** Length >= 2 characters.
    * **Email:** Must match regex `^[A-Za-z0-9+_.-]+@(.+)$`.
    * **Major:** Cannot be empty.
4.  **Failure Flow (Invalid Data):**
    * If any check fails, the method sets specific error attributes (e.g., `request.setAttribute("errorCode", "Invalid format...")`) and returns `false`.
    * **Controller:** The `insertStudent` method detects the failure. It sets `request.setAttribute("student", student)` to preserve the user's input.
    * **Forward:** It **forwards** back to `/views/student-form.jsp` (instead of redirecting).
    * **View:** The JSP uses `<c:if test="${not empty errorCode}">` to display error messages in red directly below the relevant input fields.
5.  **Success Flow:** If `validateStudent` returns `true`, the controller proceeds to call the DAO and redirect (as described in sections 2 and 3).

---

### 7. SORTING & FILTERING Operation: Organize Data

These operations allow users to organize the student list view.

#### A. Filtering by Major
1.  **Request:** User selects a major from the dropdown and clicks "Filter". Request: `.../student?action=filter&major=CS`.
2.  **Controller (Routing):** `doGet` calls `filterStudents`.
3.  **DAO (Data Access):** Calls `studentDAO.getStudentsByMajor(major)`. Executes SQL: `SELECT * FROM students WHERE major = ?`.
4.  **Controller (View Dispatch):** Sets `students` (filtered list) and `selectedMajor` (to keep the dropdown selected) as attributes, then forwards to the list view.

#### B. Sorting by Column
1.  **Request:** User clicks a column header (e.g., "Name"). Request: `.../student?action=sort&sortBy=full_name&order=asc`.
2.  **Controller (Routing):** `doGet` calls `sortStudents`.
3.  **DAO (Data Access):** Calls `studentDAO.getStudentsSorted(sortBy, order)`. To prevent SQL injection, the DAO validates that `sortBy` matches an allowed column name before executing `SELECT * FROM students ORDER BY [sortBy] [ASC|DESC]`.
4.  **Controller (View Dispatch):** Sets `students`, `sortBy`, and `order` as attributes.
5.  **View (Rendering):** The JSP renders the table. It uses logic to toggle the link for the *next* click (e.g., if current order is 'asc', the link generated for that column will be 'desc') and displays an arrow indicator (▲ or ▼).