const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
require('dotenv').config(); 

const app = express();
app.use(bodyParser.json());

// Yhdistä tietokantaan
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD, 
    database: process.env.DB_NAME 
});

db.connect((err) => {
    if (err) {
        console.error('Tietokantayhteys epäonnistui:', err);
        process.exit(1); 
    }
    console.log('Yhdistetty tietokantaan.');
});

// Hae kirja ID:n perusteella
app.get('/books/:id', (req, res) => {
    const query = 'SELECT * FROM Books WHERE id = ?';
    db.query(query, [req.params.id], (err, results) => {
        if (err) {
            res.status(500).send(err);
        } else if (results.length === 0) { 
            res.status(404).send('Book not found');
        } else {
            res.json(results[0]);
        }
    });
});

// Lisää uusi kirja
app.post('/books', (req, res) => {
    const { title, author, year, genre } = req.body;
    const query = 'INSERT INTO Books (title, author, year, genre) VALUES (?, ?, ?, ?)';

    db.query(query, [title, author, year, genre], (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(201).send('Kirja lisätty onnistuneesti.');
        }
    });
});

// Käynnistä palvelin
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Palvelin käynnissä portissa ${PORT}`); 
});