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

app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await prisma.user.findUnique({
      where: { email: email },
      include: {
        reviews: true,
        postedProjects: true
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
    const hash = bcrypt.hashSync(password, 8)
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

app.get("/employees", async (req, res) => {
  try {
    const employees = await prisma.user.findMany({
      include: {
        reviews: true,
      },
      where: {
        isEmployer: false
      }
    });
    res.send(employees)

  } catch (err) {
    //@ts-ignore
    res.send({ error: err.messaage })
  }
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

app.get('/categories', async (req, res) => {
  try {
    const categories = prisma.category.findMany();
    res.send(categories)
  } catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message })
  }
})


app.post('/projects', async (req, res) => {

  const { price, deadline, title, overview, description, status, employer_id, category_id } = req.body
  const token = req.headers.authorization || ''

  try {
    const user = await getUserFromToken(token)
    if (user.isEmployer) {
      const project = await prisma.project.create({
        data: { price, deadline, title, overview, description, status, employer_id: employer_id, category_id: category_id }
      })

      res.send(project)
    } else {
      res.status(401).send("You're not authorized to create a project")
    }
  }
  catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message })
  }
})

app.get('projects', async (req, res) => {
  try {
    const categoryId = req.body
    let projects = await prisma.project.findMany({ where: { employee_id: null } })
    if (categoryId) {
      projects = projects.filter(project => project.category_id === categoryId)
    }
    res.send(projects)

  } catch (err) {
    //@ts-ignore
    res.status(400).send({ error: err.message })
  }
})


app.listen(PORT, () => {
  console.log(`Server on http://localhost:${PORT}`);
});
