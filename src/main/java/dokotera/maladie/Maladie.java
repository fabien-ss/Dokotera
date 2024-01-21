package dokotera.maladie;

import dokotera.Model;
import dokotera.association.SymptomeMaladie;
import dokotera.patient.Patient;
import dokotera.symptome.Symptome;
import dokotera.view.VPersonneMaladie;
import generic.annotation.C;
import generic.annotation.P;
import generic.base.Connexion;
import generic.kodro.A;

import java.sql.Connection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@C(t = "maladie")
@P(l = 5, p = "MAD", s = "seq_maladie")
public class Maladie extends Model {
    @C(c = "id_maladie", pk = true)
    String idMaladie;

    public Maladie() {

    }

    public Maladie(String nom) throws Exception {
        super(nom);
    }

    public String getIdMaladie() {
        return idMaladie;
    }

    public void setIdMaladie(String idMaladie) {
        this.idMaladie = idMaladie;
    }

    public static Maladie getMaladiById(String idMaladie, Connection c) throws Exception {
        Maladie maladie = new Maladie();
        maladie.setIdMaladie(idMaladie);
        return (Maladie) A.select(c, maladie).get(0);
    }

    public static void main(String[] args) throws Exception {
        Connexion connexion = new Connexion();
        java.sql.Connection connection = connexion.enterToBdd();
        Maladie maladie = new Maladie("TA");
        A.insert(connection, maladie);
        connection.commit();
    }
}