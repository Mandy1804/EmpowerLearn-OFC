import express from "express";
import { ProfessorControler } from "../controllers/professor.controller";
import asyncHandler from "express-async-handler";

export const professorRoutes = express.Router();

professorRoutes.get("/professores", asyncHandler(ProfessorControler.getAll));
professorRoutes.get("/professores/:id", asyncHandler(ProfessorControler.getById));    
professorRoutes.post("/professores", asyncHandler(ProfessorControler.save));  
professorRoutes.put("/professores/:id", asyncHandler(ProfessorControler.update)); 
professorRoutes.delete("/professores/:id", asyncHandler(ProfessorControler.delete)); 