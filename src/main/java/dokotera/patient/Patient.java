package dokotera.patient;

import dokotera.Model;
import dokotera.association.PatientSymptome;
import dokotera.association.SymptomeMedicament;
import dokotera.maladie.Maladie;
import dokotera.medicament.Medicament;
import dokotera.symptome.Symptome;
import dokotera.view.VPersonneMaladie;
import generic.annotation.C;
import generic.annotation.P;
import generic.base.Connexion;
import generic.kodro.A;
import jdk.jfr.Label;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@C(t = "patient")
@P(l = 5, s = "seq_patient", p = "PAT")
public class Patient extends Model {
    @C(c = "id_patient", pk = true)
    String idPatient;

    @Label("Maladie du patient")
    List<VPersonneMaladie> vPersonneMaladies; // les maladies du patient

    @Label("Symptomes du patient qui chacun contient ses medicaments")
    List<PatientSymptome> symptomesMedicament;

    public Patient() {

    }

    public List<VPersonneMaladie> getvPersonneMaladies() {
        return vPersonneMaladies;
    }

    public void setvPersonneMaladies(Connection c) throws Exception {
        this.vPersonneMaladies = new VPersonneMaladie().obtenirMaladiesPersonne(c, this.idPatient);
    }

    public Patient(String nom) throws Exception {
        super(nom);
    }

    public String getIdPatient() {
        return idPatient;
    }

    public void setIdPatient(String idPatient) {
        this.idPatient = idPatient;
    }

    public static void main(String[] args) throws Exception {
        Connexion connexion = new Connexion();
        Connection c = connexion.enterToBdd();
        List<Patient> patients = new ArrayList<>();
        patients = A.select(c, new Patient());

    }

    // fonction combiner les medocs
    public void combinerMedicament(Connection c) throws Exception {
        List<PatientSymptome> symptomeListHashMap = new ArrayList<>();
        List<PatientSymptome> patientSymptomes = getPatientSymptomes(c);
        // pour chaque symptome du patient
        SymptomeMedicament s = new SymptomeMedicament();
        for(PatientSymptome symptome : patientSymptomes){
            s.setIdSymptome(symptome.getIdSymptome());
            List<SymptomeMedicament> tempList = new ArrayList<>();
            // obtenir les medicament pouvant guérir ce symptome
            List<SymptomeMedicament> symptomeMedicamentList = A.select(c, s);
            // pour chaque medicament pouvant guérir ce symptome
            for (SymptomeMedicament symptomeMedicament : symptomeMedicamentList){
                // le nombre de medicament besoin pour ce symptome de guérir le malade
                float nombre = symptome.getEtat().floatValue() / symptomeMedicament.getEffet().floatValue();
              //  if (nombre < 1) nombre = 1;
                Double prixMedoc = Medicament.getPrix(c, symptomeMedicament.getIdTarget());
                symptomeMedicament.setNombre(nombre);
                symptomeMedicament.setPrix(nombre * prixMedoc.floatValue());
                tempList.add(symptomeMedicament);
            }
            symptome.setSymptomeMedicamentList(tempList);
            symptomeListHashMap.add(symptome);
        }
        this.symptomesMedicament = symptomeListHashMap;
    }


    public List<PatientSymptome> getPatientSymptomes(Connection c) throws Exception {
        PatientSymptome patientSymptome = new PatientSymptome();
        patientSymptome.setIdPatient(this.idPatient);
        String sql ="select * from patient_symptome where id_patient='"+this.idPatient+"'"+ " and date_consultation = (select max(date_consultation) from patient_symptome where id_patient ='"+this.idPatient+"')";
        return A.executeQuery(c, patientSymptome, sql);
    }

    public List<PatientSymptome> getSymptomesMedicament() {
        return symptomesMedicament;
    }

    public void setSymptomesMedicament(List<PatientSymptome> symptomesMedicament) {
        this.symptomesMedicament = symptomesMedicament;
    }
}
