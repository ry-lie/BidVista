package com.auction.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.auction.model.Question;
import com.auction.util.DatabaseConnection;

public class QuestionDAO {
    
    public boolean createQuestion(int userId, String questionText) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "INSERT INTO Question (user_id, question_text, status, created_at) VALUES (?, ?, 'pending', NOW())";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            pstmt.setString(2, questionText);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean answerQuestion(int questionId, int repId, String answerText) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "UPDATE Question SET answer_text = ?, answered_by = ?, answered_at = NOW(), status = 'answered' WHERE question_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, answerText);
            pstmt.setInt(2, repId);
            pstmt.setInt(3, questionId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Question> getAllQuestions() {
        List<Question> questions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT q.question_id, q.user_id, q.question_text, q.answer_text, " +
                          "q.answered_by, q.created_at, q.answered_at, q.status, " +
                          "u.name as user_name, rep.name as rep_name " +
                          "FROM Question q " +
                          "JOIN User u ON q.user_id = u.user_id " +
                          "LEFT JOIN User rep ON q.answered_by = rep.user_id " +
                          "ORDER BY q.created_at DESC";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setQuestionId(rs.getInt("question_id"));
                question.setUserId(rs.getInt("user_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setAnswerText(rs.getString("answer_text"));
                if (rs.getObject("answered_by") != null) {
                    question.setAnsweredBy(rs.getInt("answered_by"));
                }
                question.setCreatedAt(rs.getTimestamp("created_at"));
                question.setAnsweredAt(rs.getTimestamp("answered_at"));
                question.setStatus(rs.getString("status"));
                question.setUserName(rs.getString("user_name"));
                question.setAnsweredByName(rs.getString("rep_name"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return questions;
    }
    
    public List<Question> searchQuestions(String keyword) {
        List<Question> questions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT q.question_id, q.user_id, q.question_text, q.answer_text, " +
                          "q.answered_by, q.created_at, q.answered_at, q.status, " +
                          "u.name as user_name, rep.name as rep_name " +
                          "FROM Question q " +
                          "JOIN User u ON q.user_id = u.user_id " +
                          "LEFT JOIN User rep ON q.answered_by = rep.user_id " +
                          "WHERE q.question_text LIKE ? OR q.answer_text LIKE ? " +
                          "ORDER BY q.created_at DESC";
            
            pstmt = conn.prepareStatement(query);
            String searchParam = "%" + keyword + "%";
            pstmt.setString(1, searchParam);
            pstmt.setString(2, searchParam);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setQuestionId(rs.getInt("question_id"));
                question.setUserId(rs.getInt("user_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setAnswerText(rs.getString("answer_text"));
                if (rs.getObject("answered_by") != null) {
                    question.setAnsweredBy(rs.getInt("answered_by"));
                }
                question.setCreatedAt(rs.getTimestamp("created_at"));
                question.setAnsweredAt(rs.getTimestamp("answered_at"));
                question.setStatus(rs.getString("status"));
                question.setUserName(rs.getString("user_name"));
                question.setAnsweredByName(rs.getString("rep_name"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return questions;
    }
    
    public List<Question> getPendingQuestions() {
        List<Question> questions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT q.question_id, q.user_id, q.question_text, q.created_at, " +
                          "u.name as user_name " +
                          "FROM Question q " +
                          "JOIN User u ON q.user_id = u.user_id " +
                          "WHERE q.status = 'pending' " +
                          "ORDER BY q.created_at ASC";
            
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setQuestionId(rs.getInt("question_id"));
                question.setUserId(rs.getInt("user_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setCreatedAt(rs.getTimestamp("created_at"));
                question.setUserName(rs.getString("user_name"));
                question.setStatus("pending");
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return questions;
    }
}
