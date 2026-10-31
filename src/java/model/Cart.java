/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.*;
import java.sql.Timestamp;
import java.io.Serializable;
import java.util.List;
import javax.xml.bind.annotation.XmlRootElement;



@Entity
@Table(name = "CART")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Cart.findAll", query = "SELECT c FROM Cart c"),
    @NamedQuery(name = "Cart.findByCartId", query = "SELECT c FROM Cart c WHERE c.cartId = :cartId")
})
public class Cart implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Basic(optional = false)
    @Column(name = "CART_ID", length = 6)
    private String cartId;

    @Column(name = "STATUS")
    private String status;

    @ManyToOne
    @JoinColumn(name = "USER_ID", referencedColumnName = "USER_ID")
    private Users user;
    
    @Column(name = "CREATED_AT")
    private Timestamp createdAt;

    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL)
    private List<Cartitem> items;

    public Cart() {
    }
    
    @PrePersist
    private void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = new Timestamp(System.currentTimeMillis());
        }
    }
    
    public Cart(String cartId, String status, Users user, Timestamp createdAt) {
        this.cartId = cartId;
        this.status = status;
        this.user = user;
        this.createdAt = createdAt;
    }

    // Other fields and methods...
    public String getCartId() {
        return cartId;
    }

    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public String getStatus() {
        return status;
    }

    public Users getUser() {
        return user;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public List<Cartitem> getItems() {
        return items;
    }

    public void setItems(List<Cartitem> items) {
        this.items = items;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}