## Lab 5: Code Flow Report (Exercises 1-4)

This report traces the end-to-end execution flow for each of the four core CRUD operations. The flow demonstrates the MVC (Model-View-Controller) pattern, showing how each layer interacts to fulfill a user request.

**Core Components:**
* **Model:** `Student.java` (Data Structure), `StudentDAO.java` (Data Access)
* **View:** `student-list.jsp`, `student-form.jsp`
* **Controller:** `StudentController.java`

---

### 1. 📚 READ Operation: List All Students

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

### 2. ➕ CREATE Operation: Add New Student

This is a two-phase operation: showing the form (GET) and processing the submission (POST).

#### Phase A: Show New Form (GET)

1.  **Request:** User clicks the "Add New Student" link, sending a `GET` request to `.../student?action=new`.
2.  **Controller (Routing):** `doGet` reads `action="new"` and calls the `showNewForm` method.
3.  **Controller (View Dispatch):** `showNewForm` simply forwards the request to the form page: `request.getRequestDispatcher("/views/student-form.jsp").forward(...)`.
4.  **View (Rendering):** `student-form.jsp` renders. Since the `${student}` object is `null`, JSTL `<c:choose>` displays "Add New Student" as the title, and the hidden action field is set to `value="insert"`.

#### Phase B: Process Form (POST)

1.  **Request:** User submits the form, sending a `POST` request to `.../student`. The form body includes `action=insert` and the new student's data.
2.  **Controller (Routing):** `doPost` is called. It reads `action="insert"` and routes to the `insertStudent` method.
3.  **Controller (Logic):** `insertStudent` reads the form data (`request.getParameter(...)`) and creates a new `Student` object using its constructor.
4.  **DAO (Data Access):** The controller calls `studentDAO.addStudent(newStudent)`. The DAO executes the `INSERT INTO students (...) VALUES (?, ?, ?, ?)` PreparedStatement.
5.  **Controller (Redirect):** On success, `insertStudent` performs a **Post-Redirect-Get (PRG)** by calling `response.sendRedirect("student?action=list&message=Student added successfully")`.
6.  **Response:** The browser receives a 302 Redirect and makes a *new GET* request, triggering the full **READ Operation** flow again, now displaying the updated list and a success message.

---

### 3. ✏️ UPDATE Operation: Edit Student

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
3.  **Controller (Logic):** `updateStudent` reads all parameters, including the hidden `id`, and creates a `Student` object with the updated information.
4.  **DAO (Data Access):** The controller calls `studentDAO.updateStudent(student)`. The DAO executes the `UPDATE students SET ... WHERE id = ?` PreparedStatement.
5.  **Controller (Redirect):** On success, `updateStudent` calls `response.sendRedirect("student?action=list&message=Student updated successfully")` (PRG).
6.  **Response:** The browser makes a new GET request, triggering the **READ Operation** flow again.

---

### 4. 🗑️ DELETE Operation: Remove Student

This is a single-step `GET` request operation.

1.  **Request:** User clicks a "Delete" link (after a JavaScript `confirm()` dialog), sending a `GET` request to `.../student?action=delete&id=5`.
2.  **Controller (Routing):** `doGet` reads `action="delete"` and calls the `deleteStudent` method.
3.  **Controller (Logic):** `deleteStudent` reads the `id` parameter from the request.
4.  **DAO (Data Access):** The controller calls `studentDAO.deleteStudent(id)`. The DAO executes the `DELETE FROM students WHERE id = ?` PreparedStatement.
5.  **Controller (Redirect):** On success, `deleteStudent` calls `response.sendRedirect("student?action=list&message=Student deleted successfully")`.
6.  **Response:** The browser makes a new GET request, triggering the **READ Operation** flow again, showing the list without the deleted student.
