package com.auction.model;

import java.sql.Timestamp;

public class Question {
    private int questionId;
    private int userId;
    private String userName;
    private String questionText;
    private String answerText;
    private Integer answeredBy;
    private String answeredByName;
    private Timestamp createdAt;
    private Timestamp answeredAt;
    private String status;
    
    public Question() {}
    
    public Question(int questionId, int userId, String questionText, Timestamp createdAt) {
        this.questionId = questionId;
        this.userId = userId;
        this.questionText = questionText;
        this.createdAt = createdAt;
        this.status = "pending";
    }
    
    public int getQuestionId() {
        return questionId;
    }
    
    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getQuestionText() {
        return questionText;
    }
    
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
    
    public String getAnswerText() {
        return answerText;
    }
    
    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }
    
    public Integer getAnsweredBy() {
        return answeredBy;
    }
    
    public void setAnsweredBy(Integer answeredBy) {
        this.answeredBy = answeredBy;
    }
    
    public String getAnsweredByName() {
        return answeredByName;
    }
    
    public void setAnsweredByName(String answeredByName) {
        this.answeredByName = answeredByName;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getAnsweredAt() {
        return answeredAt;
    }
    
    public void setAnsweredAt(Timestamp answeredAt) {
        this.answeredAt = answeredAt;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
}
