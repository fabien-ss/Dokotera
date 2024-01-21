package dokotera.medicament;

import dokotera.Model;
import generic.annotation.C;
import generic.annotation.P;
import generic.base.Connexion;
import generic.kodro.A;

import java.sql.Connection;
import java.util.List;

@C(t = "medicament")
@P(l = 5, p = "MED", s = "seq_medicament")
public class Medicament extends Model {
    @C(c = "id_medicament", pk = true)
    String idMedicament;

    @C(c = "prix")
    Double prix;

    public Medicament(String nom) throws Exception {
        super(nom);
    }

    public Medicament() {
        
    }

    public static Double getPrix(Connection c, String idMedicament) throws Exception {
        String sql = "select * from v_medicament_prix where id_medicament ='"+idMedicament+"'";
        Medicament medicament = (Medicament) A.executeQuery(c, new Medicament(), sql).get(0);
        return medicament.prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }

    public String getIdMedicament() {
        return idMedicament;
    }

    public void setIdMedicament(String idMedicament) {
        this.idMedicament = idMedicament;
    }

    public static void main(String[] args) throws Exception {
        Connexion connexion = new Connexion();
        List<Medicament> medicaments = A.select(connexion.enterToBdd(), new Medicament());
    }
}