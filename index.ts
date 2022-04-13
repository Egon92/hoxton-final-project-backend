import express from "express";
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

async function getUserFromToken(token: string) {
  const data = jwt.verify(token, process.env.MY_SECRET) as { id: number };
  const employee = await prisma.user.findUnique({
    where: { id: data.id },
  });

  return employee;
}



app.get("/validate", async (req, res) => {
  const token = req.headers.authorization || " ";

  try {
    // @ts-ignore
    const user = await getUserFromToken(token);
    res.send(user);
  } catch (err) {
    // @ts-ignore
    res.status(400).send({ error: err.message });
  }
});



app.get("/employees", async (req, res) => {
  const employees = await prisma.user.findMany({
    include: {
      reviews: true,
    },
    where: {
      isEmployer: false
    }
  });
});

app.get("/employees/:id", async (req, res) => {
  const id = Number(req.params.id);
  try {
    const employee = await prisma.user.findUnique({
      where: { id },
      include: { reviews: true },
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

app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await prisma.user.findUnique({
      where: { email: email },
      include: {
        reviews: true
      },
    });

    const checkPassword = bcrypt.compareSync(password, user.password);
    if (user && checkPassword) {
      res.send({ user, token: createToken(user.id) });
    } else {
      res.status(404).send({ error: "user or password incorrect" });
    }
  } catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message });
  }
});


app.post('/signup', async (req, res) => {
  const { username, full_name, email, password, avatar, phone, address, bio, isEmployer } = req.body

  try {
    const hash = bcrypt.hashScync(password, 8)
    const user = await prisma.user.create({
      data: { username, full_name, email, password: hash, avatar, phone, address, bio, isEmployer }
    })
    res.send({ user, token: createToken(user.id) })
  }

  catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message })
  }
})

app.listen(PORT, () => {
  console.log(`Server on http://localhost:${PORT}`);
});
