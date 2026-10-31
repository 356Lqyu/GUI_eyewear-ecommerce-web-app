/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;
import java.sql.Timestamp;


@Entity
@Table(name = "ORDERS")
@XmlRootElement
public class Orders implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "ORDER_ID", length = 6)
    private String orderId;

    @ManyToOne
    @JoinColumn(name = "CART_ID", referencedColumnName = "CART_ID")
    private Cart cart;

    @ManyToOne
    @JoinColumn(name = "USER_ID", referencedColumnName = "USER_ID")
    private Users user;

    @Column(name = "shipping_address")
    private String shippingAddress;

    @Column(name = "order_status")
    private String status;

    @Column(name = "total_amount")
    private double totalAmount;

    @Column(name = "order_date")
    private Timestamp orderDate;

    // Constructors
    public Orders() {
    }

    @PrePersist
    private void prePersist() {
        if (this.orderDate == null) {
            this.orderDate = new Timestamp(System.currentTimeMillis());
        }
    }

    public Orders(String orderId, Cart cart, Users user, String shippingAddress, String status, double totalAmount, Timestamp orderDate) {
        this.orderId = orderId;
        this.cart = cart;
        this.user = user;
        this.shippingAddress = shippingAddress;
        this.status = status;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    // Getters and setters
    public String getOrderId() {
        return orderId;
    }

    public Cart getCart() {
        return cart;
    }

    public Users getUser() {
        return user;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public String getStatus() {
        return status;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    

}