import express, {Request, Response} from "express";

const app = express();

app.get("/", (req, res) => {
    res.send("Comeco da empower");
});

app.get("/users", (req: Request, res: Response) => {
  let usuarios =[{
    nome: "Victor Cellos",
    idade: 19
  },{
    nome: "Eduardo Suzuki",
    idade: 25
  }];

  res.send(usuarios);
});

app.listen(3000, () => {
    console.log("servidor rodando");
});