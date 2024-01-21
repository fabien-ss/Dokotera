<%@ page import="java.util.ArrayList" %>
<%@ page import="dokotera.patient.Patient" %>
<%@ page import="dokotera.symptome.Symptome" %>
<%@ page import="java.util.List" %>
<%@ page import="generic.base.Connexion" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="generic.kodro.A" %><%--
  Created by IntelliJ IDEA.
  User: fabien
  Date: 1/21/24
  Time: 6:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idPersonne = request.getParameter("idPersonne");
    String error = "";
    List<Symptome> symptomes = new ArrayList<>();
    try{
        Connexion connexion = new Connexion();
        Connection c = connexion.enterToBdd();
        symptomes = A.select(c, new Symptome());
        c.close();
    }catch (Exception e){
        error = e.getMessage();
    }
%>
<div>
    <form action="../identifier" method="post">
        <table>
            <tr>
                <th>Symptome</th>
                <th>Identifiant</th>
            </tr>
            <%for (Symptome s: symptomes) {%>
            <tr>
                <td><%=s.getNom()%></td>
                <td><%=s.getIdSymptome()%></td>
                <input type="hidden" name="symtomesId[]" value="<%=s.getIdSymptome()%>">
                <td><input type="number" name="values[]" value=0></td>
            </tr>
            <%}%>
        </table>
        <input type="hidden" name="idPatient" value="<%=idPersonne%>">
        <input type="submit" value="Valider">
    </form>
    <h1><%=error%></h1>
</div>