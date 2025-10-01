const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// 1️⃣ MongoDB Bağlantısı
mongoose.connect("mongodb://127.0.0.1:27017/mycruddb", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// 2️⃣ Schema & Model
const Post = mongoose.model("Post", {
  title: String,
  body: String,
  userId: Number,
});

// 3️⃣ Routes (CRUD)

// GET: tüm postları getir
app.get("/posts", async (req, res) => {
  const posts = await Post.find();
  res.json(posts);
});

// GET: tek post getir
app.get("/posts/:id", async (req, res) => {
  const post = await Post.findById(req.params.id);
  res.json(post);
});

// POST: yeni post ekle
app.post("/posts", async (req, res) => {
  const post = new Post(req.body);
  await post.save();
  res.status(201).json(post);
});

// PUT: post güncelle
app.put("/posts/:id", async (req, res) => {
  const post = await Post.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(post);
});

// DELETE: post sil
app.delete("/posts/:id", async (req, res) => {
  await Post.findByIdAndDelete(req.params.id);
  res.status(204).end();
});

// 4️⃣ Server
app.listen(3000, () => console.log("✅ API çalışıyor: http://localhost:3000"));
