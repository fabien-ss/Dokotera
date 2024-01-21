package dokotera.association;

import generic.annotation.C;
import generic.annotation.P;
import jdk.jfr.Label;

import java.util.List;

// ito classe ito mi gérer table roa
@P(l = 5, s = "seq_ps", p = "PS")
@C(t = "patient_symptome")
public class PatientSymptome {
    @C(c = "id", pk = true)
    String id;
    @C(c = "id_patient")
    String idPatient;
    @C(c = "id_symptome")
    String idSymptome;
    @C(c = "etat")
    Integer etat;
    @Label("Medicaments de ce symptome")

    List<SymptomeMedicament> symptomeMedicamentList;

    // cherche quel medicament est le moins chère, prix est déjà le combiné avec nombre avec quantité
    // virgule et prix unitaire
    public SymptomeMedicament getMedicamentPrixMinimum(){
        SymptomeMedicament s = new SymptomeMedicament();
        s.setPrix(Float.MAX_VALUE);
        for (SymptomeMedicament medoc : symptomeMedicamentList){
            if(medoc.getPrix() < s.getPrix()) s = medoc;
        }
        return s;
    }
    public void setSymptomeMedicamentList(List<SymptomeMedicament> symptomeMedicamentList) {
        this.symptomeMedicamentList = symptomeMedicamentList;
    }

    public List<SymptomeMedicament> getSymptomeMedicamentList() {
        return symptomeMedicamentList;
    }

    public PatientSymptome(String idPatient, String idSymptome, String etat) throws Exception {
        this.setIdPatient(idPatient);
        this.setIdSymptome(idSymptome);
        this.setEtat(etat);
    }

    public PatientSymptome() {

    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public String getIdSymptome() {
        return idSymptome;
    }

    public void setIdSymptome(String idSymptome) {
        this.idSymptome = idSymptome;
    }

    public Integer getEtat() {
        return etat;
    }

    public void setEtat(String etat) throws Exception {
        this.setEtat(Integer.valueOf(etat));
    }
    public void setEtat(Integer etat) throws Exception {
        if(etat > 10 | etat < 0) throw new Exception("Valeur negatif ou superieur à 10 " +etat);
        this.etat = etat;
    }

    public String getIdPatient() {
        return idPatient;
    }

    public void setIdPatient(String idPatient) {
        this.idPatient = idPatient;
    }
}
