<%@page import="com.java.lms.Employee"%>
<%@page import="com.java.lms.LeaveDAOImpl"%>
<%@page import="com.java.lms.LeaveDetailsDAO"%>
<%@page import="com.java.lms.EmployeeDAOImpl"%>
<%@page import="com.java.lms.EmployeeDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.java.lms.LeaveDetails"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<style>
.button {
	padding: 10px 20px;
	background-color: #007bff; /* Button background color */
	color: #fff; /* Text color */
	text-decoration: none; /* Remove underlines from the link */
	border: 1px solid #007bff; /* Add a border */
	border-radius: 5px; /* Rounded corners */
	cursor: pointer; /* Show a pointer cursor on hover */
	transition: background-color 0.5s ease;
	/* Smooth background color transition */
}
.button1{
	padding:5px 10px;
	background-color:black;
	color:white;
	text-decoration:none;
	broder-radius-5px;
	cursor:pointer;
	
}
@keyframes changeColor {
  0%, 100% { background-color: #3498db; } /* Start and end color */
  25% { background-color: #e74c3c; } /* Color change at 4 seconds */
  50% { background-color: #2ecc71; } /* Color change at 8 seconds */
  75% { background-color: #f39c12; } /* Color change at 12 seconds */
}

/* Apply the animation to the button */
.button1 {
  animation: changeColor 20s linear infinite; /* 4 seconds per color, total animation duration is 16 seconds */
}

.button:hover {
	background-color: #0056b3; /* Change background color on hover */
	
}
</style>
<body>
	<%
	int empId1 = Integer.parseInt(request.getParameter("empId"));
	EmployeeDAO dao = new EmployeeDAOImpl();
	Employee employ = dao.searchEmployeeDao(empId1);
	int mgrId = employ.getManagerId();

	LeaveDetailsDAO dao1 = new LeaveDAOImpl();
	List<LeaveDetails> leaveList = dao1.showLeaveDao(empId1);
	//List<LeaveDetails> empList=dao1.showLeaveMgrIdDao(empId1);
	
	LeaveDetailsDAO dao2 = new LeaveDAOImpl();
	List<LeaveDetails> searchleavelist = dao2.showPendingLeaveDao(empId1);
	
	
	%>
	<table border="3" align="center">
		<tr>
			<td>Employ Id:<%=employ.getEmpId()%><br /> Employ Name:<%=employ.getEmpName()%><br />
				Employ Email:<%=employ.getEmpEmail()%><br />
			</td>
			<td>
				<%
				if (mgrId != 0) {
					Employee emp = dao.searchEmployeeDao(mgrId);
				%> Mgr Id:<%=emp.getEmpId()%><br /> Mgr Name:<%=emp.getEmpName()%><br />
				Mgr Email:<%=emp.getEmpEmail()%><br />
			</td>
			<%
			} else {
			out.println("Manager NotFound");
			}
			%>
		</tr>
	</table>
	<br>




	</br>
	<h2 class="table-title" align="center">Leave Details</h2>



	<table border="3" margin=10px padding=5px align="center">
		<tr>
			<th>LeaveId</th>
			<th>EmpId</th>
			<th>Leave StartDate</th>
			<th>Leave EndDate</th>
			<th>noOfDays</th>
			<th>Leave Type</th>
			<th>Leave Status</th>
			<th>Leave Reason</th>
			<th>Manager Comments</th>
			<th>Applied ON</th>
		</tr>

		<%
		for (LeaveDetails leave : leaveList) {
		%>
		<tr>
			<td><%=leave.getLeaveId()%></td>
			<td><%=leave.getEmpId()%></td>
			<td><%=leave.getLeaveStartDate()%></td>
			<td><%=leave.getLeaveEndDate()%></td>
			<td><%=leave.getNoOfDays()%></td>
			<td><%=leave.getLeaveType()%></td>
			<td><%=leave.getLeaveStatus()%></td>
			<td><%=leave.getLeaveReason()%></td>
			<td><%=leave.getManagerComments()%></td>
			<td><%=leave.getAppliedOn()%></td>

		</tr>
		<%
		}
		%>
	</table>

	<center>

		<br></br> <a href=TakeAction.jsp?empId=<%=employ.getEmpId()%>
			class="button">Apply Leave</a>

	</center>



	<br>




	</br>
	<h2 class="table-title" align="center">Leave Details MgrId</h2>




	<table border="3" margin=10px padding=5px align="center">
		<tr>
			<th>LeaveId</th>
			<th>EmpId</th>
			<th>Leave StartDate</th>
			<th>Leave EndDate</th>
			<th>noOfDays</th>
			<th>Leave Type</th>
			<th>Leave Status</th>
			<th>Leave Reason</th>
			<th>Manager Comments</th>
			<th>Applied ON</th>
			<th>Approve/Deny</th>
		</tr>

		<%
		if (searchleavelist.isEmpty()) {
	%>
		<tr>
			<td colspan="12"><h2>No leave found</h2></td>
		</tr>
		<%
		} else {
			for(LeaveDetails emp : searchleavelist) {
	%>
		<tr>
			<td><%=emp.getLeaveId()%></td>
			<td><%=emp.getEmpId()%></td>
			<td><%=emp.getLeaveStartDate()%></td>
			<td><%=emp.getLeaveEndDate()%></td>
			<td><%=emp.getNoOfDays()%></td>
			<td><%=emp.getLeaveType()%></td>
			<td><%=emp.getLeaveStatus()%></td>
			<td><%=emp.getLeaveReason()%></td>
			<td><%=emp.getManagerComments()%></td>
			<td><%=emp.getAppliedOn()%></td>
			<td>
			<a href="ApproveDeny.jsp?leaveId=<%=emp.getLeaveId() %> "class="button1">Approve/Deny</a>
			</td>



		</tr>
			<%
			}
			%>
		<%
		}
		%>
	</table>




</body>
</html>