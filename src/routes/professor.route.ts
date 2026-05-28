import express from "express";
import { ProfessorControler } from "../controller/professor.controller";
import asyncHandler from "express-async-handler";
import { celebrate, Segments } from "celebrate";
import { professorSchema } from "../models/professor.model";
export const professorRoutes = express.Router();

professorRoutes.get("/professores", asyncHandler(ProfessorControler.getAll));
professorRoutes.get("/professores/:id", asyncHandler(ProfessorControler.getById));    
professorRoutes.post("/professores", celebrate ({[Segments.BODY]: professorSchema}), asyncHandler(ProfessorControler.save));  
professorRoutes.put("/professores/:id", celebrate ({[Segments.BODY]: professorSchema}), asyncHandler(ProfessorControler.update)); 
professorRoutes.delete("/professores/:id", asyncHandler(ProfessorControler.delete)); 