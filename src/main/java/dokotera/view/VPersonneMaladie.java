package dokotera.view;

import dokotera.association.SymptomeMaladie;
import generic.annotation.C;
import generic.kodro.A;
import jdk.jfr.Label;

import java.sql.Connection;
import java.util.List;

@C(t = "v_maladie_patient_match")
public class VPersonneMaladie {
    @Label("Etat donné par le client")
    @C(c = "nombre")
    Integer nombre;
    @Label("Maladie mahazo azy")
    @C(c = "nb_symptome")
    Integer nombreSymptome;
    @C(c = "id_maladie")
    String idMaladie;
    @C(c = "id_patient")
    String idPatient;
    @C(c = "score")
    Double score;

    public List<VPersonneMaladie> obtenirMaladiesPersonne(Connection c, String idPatient) throws Exception {
        this.setIdPatient(idPatient);
        return A.select(c, this);
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public Double getScore() {
        return score;
    }

    public Double getPourcentageCorrespondance(){
        return 100 - score;
    }

    public Integer getNombre() {
        return nombre;
    }

    public void setNombre(Integer nombre) {
        this.nombre = nombre;
    }

    public Integer getNombreSymptome() {
        return nombreSymptome;
    }

    public void setNombreSymptome(Integer nombreSymptome) {
        this.nombreSymptome = nombreSymptome;
    }

    public String getIdPatient() {
        return idPatient;
    }

    public void setIdPatient(String idPatient) {
        this.idPatient = idPatient;
    }

    public VPersonneMaladie() {

    }

    public String getIdMaladie() {
        return idMaladie;
    }

    public void setIdMaladie(String idMaladie) {
        this.idMaladie = idMaladie;
    }

}
