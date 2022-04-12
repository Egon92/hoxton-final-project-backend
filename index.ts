import express, { application } from "express";
import cors from "cors";
import { PrismaClient } from "@prisma/client";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import "dotenv/config";

const app = express();
app.use(cors());
app.use(express.json());
const prisma = new PrismaClient();

const PORT = 4000;

app.get("/", (req, res) => {
  res.send("Hello!");
});

app.listen(PORT, () => {
  console.log(`Server on http://localhost:${PORT}`);
});
