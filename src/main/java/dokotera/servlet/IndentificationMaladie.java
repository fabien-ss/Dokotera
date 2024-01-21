package dokotera.servlet;

import java.io.*;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import dokotera.association.PatientSymptome;
import dokotera.patient.Patient;
import generic.annotation.P;
import generic.base.Connexion;
import generic.kodro.A;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "identifier", value = "/identifier")
public class IndentificationMaladie extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("text/html");
        Connexion connexion = null;
        try{
            connexion = new Connexion();
            Connection c = connexion.enterToBdd();
            String idPatient = req.getParameter("idPatient");
            Patient patient = new Patient();
            patient.setIdPatient(idPatient);
            patient = (Patient) A.select(c, patient).get(0);
            patient.setvPersonneMaladies(c);
            patient.combinerMedicament(c);
            req.setAttribute("Patient", patient);
            c.close();
            RequestDispatcher dispatcher = req.getRequestDispatcher("page/resultat.jsp");
            dispatcher.forward(req, resp);
        }catch (Exception e){
            req.setAttribute("error", e.getMessage());
            RequestDispatcher dispatcher = req.getRequestDispatcher("page/error.jsp");
            dispatcher.forward(req, resp);
        }

    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
       // try {
        Connexion connexion = null;
        try {
            connexion = new Connexion();
            Connection c = connexion.enterToBdd();
            String idPatient = req.getParameter("idPatient");
            String[] symptomesId = req.getParameterValues("symtomesId[]");
            String[] symptomesValues = req.getParameterValues("values[]");
            List<Object> patientSymptomes = new ArrayList<>();
            for (int i = 0; i < symptomesValues.length; i++){
                patientSymptomes.add(new PatientSymptome(idPatient, symptomesId[i], symptomesValues[i]));
            }
            A.insertList(c, patientSymptomes);
            c.commit();
            Patient patient = new Patient();
            patient.setIdPatient(idPatient);
            patient = (Patient) A.select(c, patient).get(0);
            patient.setvPersonneMaladies(c);
            patient.combinerMedicament(c);
            req.setAttribute("Patient", patient);
            c.close();
            RequestDispatcher dispatcher = req.getRequestDispatcher("page/resultat.jsp");
            dispatcher.forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            RequestDispatcher dispatcher = req.getRequestDispatcher("page/error.jsp");
            dispatcher.forward(req, resp);
        }
    }

    public void destroy() {
    }
}