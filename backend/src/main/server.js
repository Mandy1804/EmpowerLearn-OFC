const express = require ('express');
require ('dotenv').config (); 

const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'EmpowerLearn API rodando'});
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});