import express from 'express';
import { PostForumController } from '../controllers/post_forum.controller';
import asyncHandler from 'express-async-handler';

export const postForumRoutes = express.Router();

postForumRoutes.get('/forum', asyncHandler(PostForumController.getAll));
postForumRoutes.get('/forum/:id', asyncHandler(PostForumController.getById));
postForumRoutes.post('/forum', asyncHandler(PostForumController.save));
postForumRoutes.put('/forum/:id', asyncHandler(PostForumController.update));
postForumRoutes.delete('/forum/:id', asyncHandler(PostForumController.delete));