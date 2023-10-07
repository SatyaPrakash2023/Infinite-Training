
<%@page import="com.java.lms.LeaveDAOImpl"%>
<%@page import="com.java.lms.LeaveDetailsDAO"%>
<%@page import="com.java.lms.LeaveType"%>
<%@page import="java.util.Date"%>
<%@page import="com.java.lms.LeaveDetails"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>


	<form method="get" action="TakeAction.jsp">
		<center>
			<h1>Apply Leave</h1>
			Employee Id: <input type="number" name="empId" /><br />
			<br /> Leave StartDate: <input type="date" name="stdate" /><br />
			<br /> Leave EndDate: <input type="date" name="enddate" /><br />
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
			<br /> Applied On: <input type="date" name="appliedon" /><br />
			<br /> <input type="submit" value="Apply Leave" />


		</center>
	</form>

	<%
	    if (request.getParameter("empId")!=null && request.getParameter("stdate")!=null){
	    
	    String leaveStartDate = request.getParameter("stdate");
	    String leaveEndDate = request.getParameter("enddate");
	    String leaveType = request.getParameter("leaveType");
	    String leaveReason = request.getParameter("leaveReason");
	    
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    LeaveDetails leavedetails = new LeaveDetails();
	    
	    Date startDate = sdf.parse(leaveStartDate);
	    java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
	    
	    java.util.Date endDate = sdf.parse(leaveEndDate);
	    java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
	    
	    leavedetails.setEmpId(Integer.parseInt(request.getParameter("empId")));
	    leavedetails.setLeaveStartDate(sqlStartDate);
	    leavedetails.setLeaveEndDate(sqlEndDate);
	    leavedetails.setLeaveType(LeaveType.valueOf(request.getParameter("Type")));
	    leavedetails.setLeaveReason(leaveReason);
	    
	    LeaveDetailsDAO dao = new LeaveDAOImpl();
	    out.println(dao.applyLeave(leavedetails));
    
	    %>
	    	<jsp:forward page="EmployeeShow.jsp" />
	    <%
    }
%>

</body>
</html>