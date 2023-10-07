<%@page import="com.java.lms.LeaveStatus"%>
<%@page import="com.java.lms.LeaveType"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.java.lms.LeaveDAOImpl"%>
<%@page import="com.java.lms.LeaveDetailsDAO"%>
<%@page import="com.java.lms.LeaveDetails"%>
<%@page import="com.java.lms.Employee"%>
<%@page import="com.java.lms.EmployeeDAOImpl"%>
<%@page import="com.java.lms.EmployeeDAO"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<form method="get" action="ApplyLeave.jsp">
		<center>
			<h1>Apply Leave</h1>
			Employee Id: <input type="number" value="empId" /><br />
			<br /> Leave StartDate: <input type="date" value="stdate" /><br />
			<br /> Leave EndDate: <input type="date" value="stdate" /><br />
			<br /> Leave Type: <select name="Type">
				<option>EL</option>
				<option>PL</option>
				<option>ML</option>
			</select><br />
			<br /> Leave Status: <input type="text" name="Status" value="PENDING"
				readonly="readonly" /><br />
			<br /> Leave Reason: <select name="reason">
				<option>Sick</option>
				<option>Emergency</option>
				<option>Wedding</option>
				<option>Health</option>
				<option>Tourism</option>
			</select><br />
			<br /> Manager Comments: <input type="text" name="cmt" value="Null"
				readonly="readonly" /><br />
			<br /> Applied On: <input type="date" value="appliedon" /><br />
			<br /> <input type="submit" value="Submit" />


		</center>
	</form>
	<%
	if (request.getParameter("empId") != null && request.getParameter("stdate") != null&&request.getParameter("leaveId")!=null) {
		LeaveDetails leave = new LeaveDetails();
		LeaveDetailsDAO dao = new LeaveDAOImpl();
		leave.setEmpId(Integer.parseInt(request.getParameter("empId")));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = sdf.parse("stdate");
		java.sql.Date stdate1 = new java.sql.Date(date.getTime());
		leave.setLeaveStartDate(stdate1);
		Date date1 = sdf.parse("enddate");
		java.sql.Date stdate2 = new java.sql.Date(date1.getTime());
		leave.setLeaveStartDate(stdate2);
		Date date2 = sdf.parse("appliedon");
		java.sql.Date stdate3 = new java.sql.Date(date2.getTime());
		leave.setLeaveStartDate(stdate3);

		leave.setLeaveType(LeaveType.valueOf(request.getParameter("Type")));
		leave.setLeaveStatus(LeaveStatus.valueOf(request.getParameter("leaveStatus")));
		leave.setLeaveReason(request.getParameter("reason"));
		leave.setManagerComments(request.getParameter("cmt"));

		dao.applyLeave(leave);
	%>
	<jsp:forward page="EmployeeShow.jsp" />
	<%
	}
	%>


</body>
</html>