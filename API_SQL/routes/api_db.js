//Final project visual programming
//Isabella Herrera
//April 30th, 2025
//API THAT WILL CONNECT TO THE DATABASE (DB.JS)
//API THAT WILL CONNECT TO THE DATABASE (DB.JS)
//API THAT WILL CONNECT TO THE DATABASE (DB.JS)
const express = require('express');
const router = express.Router();
const db = require('../db');

// GET usuarios
router.get('/', async (req, res) => {
    try {
      res.json("host live....");
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

// GET students
router.get('/students', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM students');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET majors
router.get('/majors', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT major_name FROM majors');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET schedule
// The \ makes the code appear as a one line 
router.get('/schedule', async (req, res) => {
  try {
    const [rows] = await db.query("SELECT \
    students.id_student, \
    students.name, \
    students.last_name, \
    classes.course_number, \
    classes.id_class, \
    classes.class_name, \
    CONCAT(classes.start_time, ' - ', classes.end_time) AS schedules, \
    classes.days, \
    classes.year, \
    professor.id_professor, \
    professor.professor_name, \
    professor.professor_last_name, \
    professor.professor_email, \
    schedules.id_schedule,\
    schedules.id_student \
FROM \
    schedules \
    INNER JOIN students ON schedules.id_student = students.id_student \
    INNER JOIN classes ON schedules.id_class = classes.id_class \
    INNER JOIN professor ON classes.id_professor = professor.id_professor");
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message + "Test"});
  }
});

//GET CLASSES
// GET majors
router.get('/classes', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT class_name FROM classes ORDER BY class_name ASC;');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// G majorclasses
router.post('/majorclasses', async (req, res) => {
  const { major } = req.body;
  try {
    console.log(major);
    const [rows] = await db.query(
      `SELECT majorclasses.*, classes.* FROM
      majorclasses
      INNER JOIN classes ON majorclasses.id_class = classes.id_class
      INNER JOIN majors ON majorclasses.id_major = majors.id_major
      WHERE majors.major_name = ?`, [major]
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// POST crear student
router.post('/student', async (req, res) => {
    const { nombre, email } = req.body;
    try {
      const [result] = await db.query('INSERT INTO students (nombre, email) VALUES (?, ?)', [nombre, email]);
      res.status(201).json({ id: result.insertId, nombre, email });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });



module.exports = router;