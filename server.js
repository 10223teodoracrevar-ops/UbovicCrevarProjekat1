const express = require('express');
const mysql = require('mysql2');
const path = require('path');

const app = express();
const PORT = 3000;

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Set EJS view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // Promenite lozinku ako imate postavljenu na MySQL serveru
    database: 'dbd_prodaja_bundlova'
});

db.connect((err) => {
    if (err) {
        console.error('Greška pri povezivanju sa bazom podataka:', err);
        return;
    }
    console.log('Upešno povezivanje sa dbd_prodaja_bundlova bazom podataka!');
});

// ROUTE 1: Pocetna stranica (Prikaz tabele sa bundlovima i grafikona)
app.get('/', (req, res) => {
    // Query 1: Uzimamo sve bundlove i njihove kategorije za tabelu
    const queryTabela = `
        SELECT b.id, b.naziv_bundla, b.cena_eur, k.naziv_kategorije 
        FROM Bundlovi b
        LEFT JOIN Kategorije k ON b.kategorija_id = k.id
    `;
    
    // Query 2: Uzimamo broj prodatih bundlova po platformama za grafikon (Pie Chart)
    const queryGrafik = `
        SELECT k.platforma, COUNT(pb.id) as broj_prodatih 
        FROM Prodaja_bundlova pb
        JOIN Korisnici k ON pb.korisnik_id = k.id
        GROUP BY k.platforma
    `;

    db.query(queryTabela, (err, bundlovi) => {
        if (err) return res.status(500).send('Greška na serveru.');
        
        db.query(queryGrafik, (err, grafikPodaci) => {
            if (err) return res.status(500).send('Greška na serveru.');
            
            res.render('index', { 
                bundlovi: bundlovi, 
                grafikPodaci: grafikPodaci 
            });
        });
    });
});

// ROUTE 2: About stranica (O projektu i igrici)
app.get('/about', (req, res) => {
    res.render('about');
});

// ROUTE 3: Kontakt stranica (Prikaz forme za slanje poruke)
app.get('/kontakt', (req, res) => {
    res.render('kontakt', { poruka_status: null });
});

// ROUTE 4: POST metoda za upis kontakt poruke u bazu (Ocena 9/10)
app.post('/kontakt', (req, res) => {
    const { ime, email, poruka } = req.body;
    const queryInsert = 'INSERT INTO Kontakt (ime, email, poruka) VALUES (?, ?, ?)';
    
    db.query(queryInsert, [ime, email, poruka], (err, result) => {
        if (err) {
            console.error(err);
            return res.render('kontakt', { poruka_status: 'error' });
        }
        res.render('kontakt', { poruka_status: 'success' });
    });
});

// ROUTE 5: Admin stranica za pregled svih pristiglih poruka (Ocena 9/10)
app.get('/admin', (req, res) => {
    const queryKontakt = 'SELECT * FROM Kontakt ORDER BY datum DESC';
    db.query(queryKontakt, (err, poruke) => {
        if (err) return res.status(500).send('Greška na serveru.');
        res.render('admin', { poruke: poruke });
    });
});

app.listen(PORT, () => {
    console.log(`Server radi na http://localhost:${PORT}`);
});