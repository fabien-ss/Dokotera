package dokotera;

import generic.annotation.C;

@C
public class Model {
    @C(c = "nom")
    String nom;

    public Model(String nom) throws Exception {
        this.setNom(nom);
    }

    public Model() {

    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) throws Exception {
        if(nom.equals("") | nom == null) throw new Exception("Nom est null");
        this.nom = nom;
    }
}
