package com.java.lms;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;

public class LeaveDAOImpl implements LeaveDetailsDAO {

	Connection connection;
	PreparedStatement pst;
	
	public int dateDiff(Date startDate, Date endDate) {
		long ms = endDate.getTime() - startDate.getTime();
		int diff = (int)(ms/(1000 * 60 * 60 * 24));
		diff++;
		return diff;
	}
	
		
		
	
	
	@Override
	public String applyLeave(LeaveDetails leaveDetails) throws ClassNotFoundException, SQLException {
		
		connection = LmsConnectionHelper.getConnection();
		int diff = dateDiff(leaveDetails.getLeaveStartDate(), leaveDetails.getLeaveEndDate());
		leaveDetails.setNoOfDays(diff);
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String cmd = "Insert into LeaveDetails(EmpId,LeaveStartDate,LeaveEndDate,"
				+ "noOfDays,leaveType,leaveReason) values(?,?,?,?,?,?)";
		pst = connection.prepareStatement(cmd);
		pst.setInt(1, leaveDetails.getEmpId());
		Date date1=new Date();
		Date startDate = leaveDetails.getLeaveStartDate();
		Date endDate = leaveDetails.getLeaveEndDate();
		
		
		
		if(startDate.before(date1)) {
			System.err.println("satrtDate cannot be yester day");
				
			}
		else if(endDate.before(date1)){
			System.err.println("enddate canot be yesterday...");
			
		}
		else if(startDate.after(endDate)) {
			System.err.println("Start date cannot be greater than enddate");
		}
		
		
		
		
		
	else {
		Employee emp = new EmployeeDAOImpl().searchEmployeeDao(leaveDetails.getEmpId());
		int leaveAvailable = emp.getLeaveAvail();
		if(diff>leaveAvailable) {
			System.out.println("Leave Cannot more than leave availabe days..");
		}
		pst.setInt(1, leaveDetails.getEmpId());
		
		pst.setDate(2, leaveDetails.getLeaveStartDate());
		pst.setDate(3, leaveDetails.getLeaveEndDate());
		pst.setInt(4, leaveDetails.getNoOfDays());
		pst.setString(5, leaveDetails.getLeaveType().toString());
		pst.setString(6, leaveDetails.getLeaveReason());
		pst.executeUpdate();
		cmd = "Update Employee set LeaveAvail = LeaveAvail - ? Where EmpId=?";
		pst = connection.prepareStatement(cmd);
		pst.setInt(1, diff);
		pst.setInt(2, leaveDetails.getEmpId());
		pst.executeUpdate();
		return "Leave Applied...";
		
	}
	return " ";	
	
			
		
		
		
		
	}
	
	public LeaveDetails searchByLeaveId(int leaveId) throws ClassNotFoundException, SQLException {
		connection = LmsConnectionHelper.getConnection();
		String cmd = "select * from LeaveDetails where LeaveId=?";
		pst = connection.prepareStatement(cmd);
		pst.setInt(1, leaveId);
		ResultSet rs = pst.executeQuery();
		LeaveDetails leaveDetails = null;
		if (rs.next()) {
			leaveDetails = new LeaveDetails();
			leaveDetails.setLeaveId(leaveId);
			leaveDetails.setEmpId(rs.getInt("EmpId"));
			leaveDetails.setLeaveStartDate(rs.getDate("leaveStartDate"));
			leaveDetails.setLeaveEndDate(rs.getDate("leaveEndDate"));
			leaveDetails.setNoOfDays(rs.getInt("noOfDays"));
			leaveDetails.setLeaveType(LeaveType.valueOf(rs.getString("leaveType")));
			leaveDetails.setLeaveStatus(LeaveStatus.valueOf(rs.getString("leaveStatus")));
			leaveDetails.setLeaveReason(rs.getString("leaveReason"));
		}

 

		return leaveDetails;
	}
	
	
	public LeaveDetails searchByEmpId(int empId) throws ClassNotFoundException, SQLException {
		connection = LmsConnectionHelper.getConnection();
		String cmd = "select * from LeaveDetails where empId=?";
		pst = connection.prepareStatement(cmd);
		pst.setInt(1, empId);
		ResultSet rs = pst.executeQuery();
		LeaveDetails leaveDetails = null;
		if (rs.next()) {
			leaveDetails = new LeaveDetails();
			leaveDetails.setLeaveId(rs.getInt("leaveId"));
			leaveDetails.setEmpId(empId);
			leaveDetails.setLeaveStartDate(rs.getDate("leaveStartDate"));
			leaveDetails.setLeaveEndDate(rs.getDate("leaveEndDate"));
			leaveDetails.setNoOfDays(rs.getInt("noOfDays"));
			leaveDetails.setLeaveType(LeaveType.valueOf(rs.getString("leaveType")));
			leaveDetails.setLeaveStatus(LeaveStatus.valueOf(rs.getString("leaveStatus")));
			leaveDetails.setLeaveReason(rs.getString("leaveReason"));
		}

 

		return leaveDetails;
	}


 

	
	public String approveOrDeny(int leaveId, int managerId, String status, String managerComments) throws ClassNotFoundException, SQLException {
		LeaveDetails leaveFound = searchByLeaveId(leaveId);
		int empId = leaveFound.getEmpId();
		EmployeeDAO dao = new EmployeeDAOImpl();
		Employee employee = dao.searchEmployeeDao(empId);
		int mgrId = employee.getManagerId();
		int diff = dateDiff(leaveFound.getLeaveStartDate(), leaveFound.getLeaveEndDate());
		LeaveDetails newleave = new LeaveDetails();
		if (managerId==mgrId) {
			if("YES".equals(status)) {
				leaveFound.setLeaveStatus(LeaveStatus.valueOf("ACCEPTED"));
				leaveFound.setNoOfDays(diff);
			}else if("NO".equals(status)) {
				leaveFound.setLeaveStatus(LeaveStatus.valueOf("REJECTED"));
				leaveFound.setNoOfDays(diff);
			}
			System.out.println("NoofLeave is : "+leaveFound.getNoOfDays());
			connection=LmsConnectionHelper.getConnection();
			String cmd = "Update LeaveDetails set leavestatus=?,managerComments=? where leaveId=?";
			pst = connection.prepareStatement(cmd);
	        pst.setString(1, leaveFound.getLeaveStatus().toString());
	        pst.setString(2, managerComments);
	        
	        pst.setInt(3, leaveId);
	        pst.executeUpdate();
	        
	        if(status.equals("NO")) {
				connection=LmsConnectionHelper.getConnection();
				cmd = "Update Employee set LeaveAvail = LeaveAvail + ? Where EmpId=?";
				pst = connection.prepareStatement(cmd);
				pst.setInt(1, diff);
				pst.setInt(2, leaveFound.getEmpId());
				pst.executeUpdate();
			}else {
				connection=LmsConnectionHelper.getConnection();
				cmd = "Update Employee set LeaveAvail = LeaveAvail - ? Where EmpId=?";
				pst = connection.prepareStatement(cmd);
				pst.setInt(1, diff);
				pst.setInt(2, leaveFound.getEmpId());
				pst.executeUpdate();
			}
	        return"Leave Details updated... ";
		} else {
			return "You are un-authoried...";
		}
	}





	@Override
	public List<LeaveDetails> showLeaveDao(int empId) throws ClassNotFoundException, SQLException {
		connection=LmsConnectionHelper.getConnection();
		String cmd ="Select * from leavedetails where empId=?";
		pst=connection.prepareStatement(cmd);
		pst.setInt(1, empId);
		ResultSet rs = pst.executeQuery();
		LeaveDetails leavedetails=null;
		List<LeaveDetails> leaveList = new ArrayList<LeaveDetails>();
		while(rs.next()) {
			leavedetails = new LeaveDetails();
			leavedetails.setLeaveId(rs.getInt("leaveId"));
			leavedetails.setEmpId(rs.getInt("EmpId"));
			leavedetails.setLeaveStartDate(rs.getDate("leaveStartDate"));
			leavedetails.setLeaveEndDate(rs.getDate("leaveEndDate"));
			leavedetails.setNoOfDays(rs.getInt("noOfDays"));
			leavedetails.setLeaveType(LeaveType.valueOf(rs.getString("leaveType")));
			leavedetails.setLeaveStatus(LeaveStatus.valueOf(rs.getString("leaveStatus")));
			leavedetails.setLeaveReason(rs.getString("leaveReason"));
			leavedetails.setAppliedOn(rs.getDate("appliedOn"));
			leaveList.add(leavedetails);
		}
		return leaveList;
	}





	@Override
	public List<LeaveDetails> showLeaveMgrIdDao(int empId) throws ClassNotFoundException, SQLException {
//		connection=LmsConnectionHelper.getConnection();
//		String cmd ="Select * from Employee where mgrId=?";
//		pst=connection.prepareStatement(cmd);
//		pst.setInt(1, empId);
//		ResultSet rs = pst.executeQuery();
		LeaveDetailsDAO dao1=new LeaveDAOImpl();
//		List<LeaveDetails> leaveList = new ArrayList<LeaveDetails>();
		List<LeaveDetails> leaveList1 = new ArrayList<LeaveDetails>();
		EmployeeDAO dao= new EmployeeDAOImpl();
		List<Employee> leaveList = dao.showLeaveMgridDao(empId);
		for (Employee leaveDetails : leaveList) {
			int empid=leaveDetails.getEmpId();
			leaveList1=dao1.showLeaveDao(empid);
			
		}
		return leaveList1;
		
	}
	
	
	
	
	@Override
	public List<LeaveDetails> showPendingLeaveDao(int empno) throws ClassNotFoundException, SQLException {
		connection = LmsConnectionHelper.getConnection();
		String cmd = "select * from LeaveDetails where empid in(select EmpId from employee where ManagerId =?) and  leaveStatus='PENDING';";
		pst = connection.prepareStatement(cmd);
		pst.setInt(1, empno);
		ResultSet rs = pst.executeQuery();
		Employee employ = new Employee();
		List<LeaveDetails> leaveList = new ArrayList<LeaveDetails>();
		LeaveDetails leave = null;
		while(rs.next()) {
			leave = new LeaveDetails();
			leave.setLeaveId(rs.getInt("LeaveId"));
			leave.setEmpId(rs.getInt("empid"));
			leave.setLeaveStartDate(rs.getDate("LeaveStartDate"));
			leave.setLeaveEndDate(rs.getDate("LeaveEndDate"));
			leave.setNoOfDays(rs.getInt("noOfDays"));
			leave.setLeaveType(LeaveType.valueOf(rs.getString("leaveType")));
			leave.setLeaveStatus(LeaveStatus.valueOf(rs.getString("leaveStatus")));
			leave.setLeaveReason(rs.getString("leaveReason"));
			leave.setManagerComments(rs.getString("ManagerComments"));
			leave.setAppliedOn(rs.getDate("appliedOn"));
			leaveList.add(leave);
		}
		
		return leaveList;
	}
	
	
	
	
}
	
