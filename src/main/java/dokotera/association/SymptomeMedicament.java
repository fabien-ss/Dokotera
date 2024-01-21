package dokotera.association;

import generic.annotation.C;
import generic.annotation.P;
import generic.base.Connexion;
import generic.kodro.A;
import jdk.jfr.Label;

import java.sql.Connection;
import java.util.List;

@Label("Ito classe ito mampifandray v_medicament_prix ")
@C(t = "association_symptome_medicament")
@P(l = 5, s = "seq_association_symptome_medicament", p = "ASSOC")
public class SymptomeMedicament extends Association {
    @C(c = "id_association_medicament_symptome", pk = true)
    String idSymptomeMedicament;
    @C(c = "effet")
    Integer effet;

    Float prix;
    Float nombre;
    public Integer getUpperFormatNombre(){
        return (int) Math.ceil(this.nombre);
    }

    public Float getPrixUnitaire(){
        return this.prix / this.nombre;
    }
    public String getIdSymptome() {
        return super.getIdSymptome();
    }

    public void setIdSymptome(String idSymptome) {
        super.setIdSymptome(idSymptome);
    }

    public Float getPrix() {
        return prix;
    }

    public void setPrix(Float prix) {
        this.prix = prix;
    }

    public Float getNombre() {
        return nombre;
    }

    public void setNombre(Float nombre) {
        this.nombre = nombre;
    }

    public SymptomeMedicament(){
        super();
    }
    public SymptomeMedicament(String idSymptome, String idTarget, Integer effet) {
        super(idSymptome, idTarget);
        this.effet = effet;
    }

    public SymptomeMedicament(String idSymptome, String idTarget) {
        super(idSymptome, idTarget);
    }

    public String getIdSymptomeMedicament() {
        return idSymptomeMedicament;
    }

    public void setIdSymptomeMedicament(String idSymptomeMedicament) {
        this.idSymptomeMedicament = idSymptomeMedicament;
    }

    public Integer getEffet() {
        return effet;
    }

    public void setEffet(Integer effet) {
        this.effet = effet;
    }

    public static void main(String[] args) throws Exception {
        Connexion connexion = new Connexion();
        Connection connection = connexion.enterToBdd();

        SymptomeMedicament s = new SymptomeMedicament();
        s.setEffet(3);

        List<SymptomeMedicament> symptomeMedicaments = A.select(connection, s);
        for (SymptomeMedicament ss :  symptomeMedicaments){
            System.out.println(ss.getEffet() + " " + ss.getIdSymptome() + " " + ss.getIdTarget());
        }
    }
}
