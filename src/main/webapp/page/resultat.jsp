<%@ page import="dokotera.patient.Patient" %>
<%@ page import="dokotera.association.PatientSymptome" %>
<%@ page import="dokotera.view.VPersonneMaladie" %>
<%@ page import="generic.base.Connexion" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="dokotera.maladie.Maladie" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dokotera.association.SymptomeMedicament" %><%--
  Created by IntelliJ IDEA.
  User: fabien
  Date: 1/21/24
  Time: 5:49 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<PatientSymptome> symptomeList= new ArrayList<>();
    String error = "";
    Patient patient = (Patient) request.getAttribute("Patient");

        Connexion c = new Connexion();
        Connection cc = c.enterToBdd();
    try{
        symptomeList = patient.getPatientSymptomes(cc);
    }catch (Exception e){
        error = e.getMessage();
    }

%>
<html>
<head>
    <title>Resultat analyse <%=patient.getNom()%></title>
</head>
<body>

<style>
    li{
        display: inline;
    }
    table, td, th{
        border: 1px solid #04414d;
    }
    td, th{
        min-width: 50px;
    }
</style>

<div style="width: 1000px;">

    <div style="width: 100%; ">
        Patient identifiant: <%=patient.getIdPatient()%>
        Nom: <%=patient.getNom()%>
    </div>
    <div style="width: 50%">
        <h2>Derniere consultation</h2>
        <table>
            <tr>
                <th>Identifiant symptome</th>
                <th>Valeur</th>
            </tr>
            <%for (PatientSymptome ps : symptomeList) {%>
                <tr>
                    <td><%=ps.getIdSymptome()%></td>
                    <td><%=ps.getEtat()%></td>
                </tr>
            <%}%>
        </table>
    </div>
    <div style="width: 50%;">
        <h2><%=patient.getNom()%>, maladie possible</h2>
        <table>
            <tr>
                <th>Identifiant maladie</th>
                <th>Maladie</th>
                <th>Resultat</th>
                <th>Distance</th>
            </tr>
            <% for (VPersonneMaladie ps : patient.getvPersonneMaladies()){ %>
                <tr>
                    <td><%=ps.getIdMaladie()%></td>
                    <td><%=Maladie.getMaladiById(ps.getIdMaladie(), cc).getNom()%></td>
                    <td><%=ps.getNombre()%>/<%=ps.getNombreSymptome()%></td>
                    <td><%=ps.getPourcentageCorrespondance()%>%</td>
                </tr>
            <% } %>
        </table>
    </div>

    <div style="">
        <h2>Medicaments prescrits</h2>
        <ul>
            <% int i = 0; for (PatientSymptome ps : patient.getSymptomesMedicament()) {%>
                <li><%=ps.getIdSymptome()%> <%=ps.getEtat()%></li>
                <h4>
                    <em>Moin chère:</em>
                    <!-- Id target le medicament -->
                    Guérit au bout de <%=ps.getMedicamentPrixMinimum().getIdTarget()%> * <%=ps.getMedicamentPrixMinimum().getNombre()%>
                    <br>
                    Total <%=ps.getMedicamentPrixMinimum().getUpperFormatNombre()%> * <%=ps.getMedicamentPrixMinimum().getPrixUnitaire()%>
                </h4>

                <button onclick="showHiddenDiv(<%=i%>)">Autre alternative</button>
                <div id="div<%=i%>" style="display: none;">
                    <table>
                        <tr>
                            <th>Medoc</th>
                            <th>Nombre ilaina</th>
                            <th>Prix unitaire</th>
                        </tr>

                        <%for(SymptomeMedicament sm : ps.getSymptomeMedicamentList()) {%>
                            <tr>
                                <td><%=sm.getIdTarget()%></td>
                                <td><%=sm.getNombre()%></td>
                                <td><%=sm.getPrix()%></td>
                            </tr>
                        <%}%>
                    </table>
                </div>
            <br>
            <% i+= 1; }%>
        </ul>
    </div>
<%=error%>
</div>
</body>
</html>
<script>
    function showHiddenDiv(number){
        var div = document.getElementById("div"+number);
        if(div.style.display != "none"){
            div.style.display = "none";
        }
        else{
            div.style.display = "flex";
        }
    }
</script>
