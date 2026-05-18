import express from "express";
import { ProfessorControler } from "../controller/professor.controller";

export const professorRoutes = express.Router();

professorRoutes.get("/professores", ProfessorControler.getAll);
professorRoutes.get("/professores/:id", ProfessorControler.getById);    
professorRoutes.post("/professores", ProfessorControler.save);  
professorRoutes.put("/professores/:id", ProfessorControler.update); 
professorRoutes.delete("/professores/:id", ProfessorControler.delete); 