package com.auction.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role;
    private boolean admin;
    private boolean endUser;
    
    public User() {}
    
    public User(int userId, String name, String email, String role, boolean admin, boolean endUser) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.role = role;
        this.admin = admin;
        this.endUser = endUser;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public boolean isAdmin() {
        return admin;
    }
    
    public void setAdmin(boolean admin) {
        this.admin = admin;
    }
    
    public boolean isEndUser() {
        return endUser;
    }
    
    public void setEndUser(boolean endUser) {
        this.endUser = endUser;
    }
}
