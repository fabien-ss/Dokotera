package dokotera.symptome;


import dokotera.Model;
import dokotera.association.SymptomeMaladie;
import dokotera.medicament.Medicament;
import generic.annotation.C;
import generic.annotation.P;
import generic.kodro.A;

import java.sql.Connection;
import java.util.List;

@C(t = "symptome")
@P(s = "seq_symptome", l = 5, p = "SYMP")
public class Symptome extends Model {
    @C(c = "id_symptome", pk = true)
    String idSymptome;

    Integer value;

    List<SymptomeMaladie> medicamentPossible;

    public void getMedicamentsPossible(Connection c) throws Exception {
        SymptomeMaladie symptomeMaladie = new SymptomeMaladie();
        symptomeMaladie.setIdSymptome(this.idSymptome);
        medicamentPossible = A.select(c, symptomeMaladie);
    }

    public void setMedicamentPossible(List<SymptomeMaladie> medicamentPossible) {
        this.medicamentPossible = medicamentPossible;
    }

    public List<SymptomeMaladie> getMedicamentPossible() {
        return medicamentPossible;
    }

    public Symptome(String idSymptome, String value) throws Exception {
        super();
        this.setIdSymptome(idSymptome);
        this.setValue(value);
    }

    public Symptome(String nom) throws Exception {
        super(nom);
    }

    public Symptome() {

    }

    public String getIdSymptome() {
        return idSymptome;
    }

    public void setIdSymptome(String idSymptome) {
        this.idSymptome = idSymptome;
    }

    public void setValue(String value) throws Exception {
        try {
            this.setValue(Integer.valueOf(value));
        }
        catch (Exception e){
            throw new Exception("Value ="+value+" "+e.getMessage());
        }
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) throws Exception {
        if(value < 0 | value > 10) throw new Exception("Valeur invalide "+value);
        this.value = value;
    }

    public static void main(String[] args) {
    }
}