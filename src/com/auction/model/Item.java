package com.auction.model;

public class Item {
    private int itemId;
    private String title;
    private String description;
    private String condition;
    private int subcategoryId;
    private String subcategoryName;
    private String categoryName;
    
    public Item() {}
    
    public Item(int itemId, String title, String description, String condition, int subcategoryId) {
        this.itemId = itemId;
        this.title = title;
        this.description = description;
        this.condition = condition;
        this.subcategoryId = subcategoryId;
    }
    
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getCondition() {
        return condition;
    }
    
    public void setCondition(String condition) {
        this.condition = condition;
    }
    
    public int getSubcategoryId() {
        return subcategoryId;
    }
    
    public void setSubcategoryId(int subcategoryId) {
        this.subcategoryId = subcategoryId;
    }
    
    public String getSubcategoryName() {
        return subcategoryName;
    }
    
    public void setSubcategoryName(String subcategoryName) {
        this.subcategoryName = subcategoryName;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
