<%@ page import="java.util.List" %>
<%@ page import="dokotera.patient.Patient" %>
<%@ page import="generic.kodro.A" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="generic.base.Connexion" %>
<%@ page import="java.sql.Connection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String error = "";
  List<Patient> patients = new ArrayList<>();
  try{
    Connexion connexion = new Connexion();
    Connection c = connexion.enterToBdd();
    patients = A.select(c, new Patient());
    c.close();
  }catch (Exception e){
    error = e.getMessage();
  }

%>
<!DOCTYPE html>
<html>
<head>
  <title>Patients page</title>
</head>
<body>
<h1><%=error%></h1>
<h1>Liste des patients</h1>
<br/>
  <div>
    <table>
      <th>
        Nom
      </th>
      <th>
        Identifiant
      </th>
      <%for (Patient p : patients) { %>
        <tr>
          <td><%=p.getNom()%></td>
          <td><%=p.getIdPatient()%></td>
          <td><a href="page/entreSymptome.jsp?idPersonne=<%=p.getIdPatient()%>">Consulter</a></td>
          <td><a href="identifier?idPatient=<%=p.getIdPatient()%>">Dernier resultat</a></td>
        </tr>
      <% } %>
    </table>
  </div>
</body>
</html>