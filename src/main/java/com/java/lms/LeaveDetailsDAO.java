package com.java.lms;

import java.sql.SQLException;
import java.util.List;

public interface LeaveDetailsDAO {
	String applyLeave(LeaveDetails leaveDetails) throws ClassNotFoundException, SQLException;
	String approveOrDeny(int leveId,int managerId,String status,String managerComments) throws ClassNotFoundException, SQLException;
	LeaveDetails searchByEmpId(int empId) throws ClassNotFoundException, SQLException;
	LeaveDetails searchByLeaveId(int leaveId) throws ClassNotFoundException, SQLException;
	
	List<LeaveDetails> showLeaveDao(int empId) throws ClassNotFoundException, SQLException;
	List<LeaveDetails> showLeaveMgrIdDao(int empId) throws ClassNotFoundException, SQLException;
	List<LeaveDetails> showPendingLeaveDao(int empno) throws ClassNotFoundException, SQLException;
	
	

}
