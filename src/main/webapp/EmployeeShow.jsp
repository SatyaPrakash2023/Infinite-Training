<%@page import="java.util.List"%>
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
<%
	EmployeeDAO dao = new EmployeeDAOImpl();
	List<Employee> employList=dao.showEmployeeDao();
%>
<form method="get" action="EmployShowServlet">
		
			<table border="3" align="center">
				</center>
				<tr>
					<th>EMPID</th>
					<th>EMPName</th>
					<th>EMPEmail</th>
					<th>MobileNo</th>
					<th>DateOfJoin</th>
					<th>ManagerId</th>
					<th>LeaveAvail</th>
				</tr>
			<%
				for(Employee employ:employList){
			%>	
			<tr>
				<td><%=employ.getEmpId() %></td>
				<td><%=employ.getEmpName() %></td>
				<td><%=employ.getEmpEmail() %></td>
				<td><%=employ.getMobileNo() %></td>
				<td><%=employ.getDateOfJoin() %></td>
				<td><%=employ.getManagerId() %></td>
				<td><%=employ.getLeaveAvail() %></td>
				<td>
					<a href=ShowDetails.jsp?empId=<%=employ.getEmpId() %>>Show</a>
					
				</td>
			</tr>
			<%
				}
			%>
			</center>
			</table>
	</form>

</body>
</html>