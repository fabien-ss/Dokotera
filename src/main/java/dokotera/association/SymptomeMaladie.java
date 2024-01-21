package dokotera.association;

import generic.annotation.C;

@C(t = "association_symptome_maladie")
public class SymptomeMaladie extends Association{
    @C(c = "intervalle_min")
    Integer intervalleMin;
    @C(c = "intervalle_max")
    Integer intervalleMax;
    public SymptomeMaladie(String idSymptome, String idTarget) {
        super(idSymptome, idTarget);
    }

    public SymptomeMaladie() {

    }

    public Integer getIntervalleMin() {
        return intervalleMin;
    }

    public void setIntervalleMin(Integer intervalleMin) {
        this.intervalleMin = intervalleMin;
    }

    public Integer getIntervalleMax() {
        return intervalleMax;
    }

    public void setIntervalleMax(Integer intervalleMax) {
        this.intervalleMax = intervalleMax;
    }
}
