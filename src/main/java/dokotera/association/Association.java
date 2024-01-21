package dokotera.association;

import generic.annotation.C;

@C
public class Association {
    @C(c = "id_symptome")
    String idSymptome;
    @C(c = "id_target")
    String idTarget; // soit id_maladie soit id_medicament

    public Association(){}

    public Association(String idSymptome, String idTarget) {
        this.idSymptome = idSymptome;
        this.idTarget = idTarget;
    }

    public String getIdSymptome() {
        return idSymptome;
    }

    public void setIdSymptome(String idSymptome) {
        this.idSymptome = idSymptome;
    }

    public String getIdTarget() {
        return idTarget;
    }

    public void setIdTarget(String idTarget) {
        this.idTarget = idTarget;
    }
}