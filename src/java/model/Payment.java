/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.*;
import jakarta.persistence.Transient;
import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;
import java.sql.Timestamp;

/**
 *
 * @author User
 */
@Entity
@Table(name = "PAYMENT")
@XmlRootElement
public class Payment implements Serializable {

    private static final long serialVersionUID = 1L;
   @Id
    @Basic(optional = false)
    @Column(name = "PAYMENT_ID", length = 6)
    private String paymentId;

    @Column(name = "PAYMENT_METHOD")
    private String paymentMethod;

    @Column(name = "DELIVERY_FEES")
    private double deliveryFees;

    @Column(name = "PAYMENT_AMOUNT")
    private double paymentAmount;

    @Column(name = "PAYMENT_DATE")
    private Timestamp paymentDate;

    @Column(name = "SHIPPING_ADDRESS")
    private String shippingAddress;

    @Column(name = "TOTAL_AMOUNT")
    private double totalAmount;
    
     @Column(name = "SALES_TAX")
    private double salesTax;

    // For card payments
    @Column(name = "CARD_NUMBER")
    private String cardNumber;

    @Column(name = "CARD_TYPE")
    private String cardType;

    @Column(name = "CARD_NAME")
    private String cardName;

    @Transient
    private String expiry;

    @Transient
    private String cvv;

    // For eWallet payments
    @Column(name = "EWALLET_TYPE")
    private String ewalletType;

    @Column(name = "EWALLET_PHONE")
    private String phoneNumber;

    @OneToOne
    @JoinColumn(name = "ORDER_ID", referencedColumnName = "ORDER_ID")
    private Orders order;

    private String status;

    // Constructors
    public Payment() {
    }

    @PrePersist
    private void prePersist() {
        if (this.paymentDate == null) {
            this.paymentDate = new Timestamp(System.currentTimeMillis());
        }
    }

    public Payment(String paymentId, String paymentMethod, double deliveryFees, double paymentAmount, Timestamp paymentDate, String shippingAddress, double totalAmount, double salesTax, String cardNumber, String cardType, String cardName, String expiry, String cvv, String ewalletType, String phoneNumber, Orders order, String status) {
        this.paymentId = paymentId;
        this.paymentMethod = paymentMethod;
        this.deliveryFees = deliveryFees;
        this.paymentAmount = paymentAmount;
        this.paymentDate = paymentDate;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.salesTax = salesTax;
        this.cardNumber = cardNumber;
        this.cardType = cardType;
        this.cardName = cardName;
        this.expiry = expiry;
        this.cvv = cvv;
        this.ewalletType = ewalletType;
        this.phoneNumber = phoneNumber;
        this.order = order;
        this.status = status;
    }

    public double getSalesTax() {
        return salesTax;
    }

    public void setSalesTax(double salesTax) {
        this.salesTax = salesTax;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getPaymentAmount() {
        return paymentAmount;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getEwalletType() {
        return ewalletType;
    }

    public double getDeliveryFees() {
        return deliveryFees;
    }

    public String getCardType() {
        return cardType;
    }

    public String getCardName() {
        return cardName;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public String getExpiry() {
        return expiry;
    }

    public String getCvv() {
        return cvv;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setDeliveryFees(double deliveryFees) {
        this.deliveryFees = deliveryFees;
    }

    public void setPaymentAmount(double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public void setCardName(String cardName) {
        this.cardName = cardName;
    }

    public void setExpiry(String expiry) {
        this.expiry = expiry;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public void setEwalletType(String ewalletType) {
        this.ewalletType = ewalletType;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

}