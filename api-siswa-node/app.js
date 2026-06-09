const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'db_sekolah'
});

db.connect((err) => {
  if (err) {
    console.error('Database Tidak Terhubung!', err);
    return;
  }
  console.log('Terhubung ke Mysql!');
});

app.get('/siswa', (req, res) => {
  db.query('SELECT * FROM siswa', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

app.post('/siswa', (req, res) => {
  const { nama, kelas, nis } = req.body;
  const sql = 'INSERT INTO siswa (nama, kelas, nis) VALUES (?, ?, ?)';
  db.query(sql, [nama, kelas, nis], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Data masuk!', id: result.insertId });
  });
});

app.delete('/siswa/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM siswa WHERE id = ?', [id], (err) => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Data dihapus!' });
  });
});

app.put('/siswa/:id', (req, res) => {
  const { id } = req.params;
  const { nama, kelas, nis } = req.body;
  const sql = 'UPDATE siswa SET nama = ?, kelas = ?, nis = ? WHERE id = ?';
  db.query(sql, [nama, kelas, nis, id], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Data diupdate!' });
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server jalan di port ${PORT}`);
});