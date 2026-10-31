package model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Promotion")
public class Promotion implements Serializable {

    @Id
    @Column(name = "promo_id")
    private String promoId;

    @Column(name = "image_name")
    private String imageName;

    @Column(name = "promo_text")
    private String promoText;

    public Promotion() {
    }

    public Promotion(String promoId, String imageName, String promoText) {
        this.promoId = promoId;
        this.imageName = imageName;
        this.promoText = promoText;
    }

    public String getPromoId() {
        return promoId;
    }

    public void setPromoId(String promoId) {
        this.promoId = promoId;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public String getPromoText() {
        return promoText;
    }

    public void setPromoText(String promoText) {
        this.promoText = promoText;
    }
}
