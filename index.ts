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

function createToken(id: number) {
  const token = jwt.sign({ id: id }, process.env.MY_SECRET, {
    expiresIn: "3days",
  });
  return token;
}

async function getEmployeeFromToken(token: string) {
  const data = jwt.verify(token, process.env.MY_SECRET) as { id: number };
  const employee = await prisma.employee.findUnique({
    where: { id: data.id },
  });

  return employee;
}

async function getEmployerFromToken(token: string) {
  const data = jwt.verify(token, process.env.MY_SECRET) as { id: number };
  const employer = await prisma.employer.findUnique({
    where: { id: data.id },
  });

  return employer;
}
app.get("/validateEmployee", async (req, res) => {
  const token = req.headers.authorization || " ";

  try {
    // @ts-ignore
    const user = await getEmployeeFromToken(token);
    res.send(user);
  } catch (err) {
    // @ts-ignore
    res.status(400).send({ error: err.message });
  }
});

app.get("/validateEmployer", async (req, res) => {
  const token = req.headers.authorization || " ";

  try {
    // @ts-ignore
    const user = await getEmployerFromToken(token);
    res.send(user);
  } catch (err) {
    // @ts-ignore
    res.status(400).send({ error: err.message });
  }
});

app.get("/employees", async (req, res) => {
  const employees = await prisma.employee.findMany({
    include: {
      reviews: true,
    },
  });
});

app.get("/employees/:id", async (req, res) => {
  const id = Number(req.params.id);
  try {
    const employee = await prisma.employee.findFirst({
      where: { id },
      include: { reviews: true, bids: true },
    });
    if (employee) {
      res.send(employee);
    } else {
      res.status(404).send({ error: "Employee not found" });
    }
  } catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server on http://localhost:${PORT}`);
});
