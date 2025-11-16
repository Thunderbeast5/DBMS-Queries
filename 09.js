// Start MongoDB Shell
mongosh

// Switch to Database
use TY_B_72

// 1. Create a collection named books
db.createCollection("books")

// 2. Insert 5 records with fields TITLE, DESCRIPTION, BY, URL, TAGS AND LIKES
db.books.insertMany([
  {
    TITLE: "MongoDB Basics",
    DESCRIPTION: "A beginner's guide to MongoDB",
    BY: "Raj",
    URL: "/mongodb-basics",
    TAGS: ["mongodb", "database", "nosql"],
    LIKES: 50
  },
  {
    TITLE: "Advanced SQL",
    DESCRIPTION: "Deep dive into SQL",
    BY: "Priya",
    URL: "/advanced-sql",
    TAGS: ["sql", "database", "rdbms"],
    LIKES: 150
  },
  {
    TITLE: "Node.js Guide",
    DESCRIPTION: "Comprehensive guide for Node.js",
    BY: "Raj",
    URL: "/nodejs-guide",
    TAGS: ["nodejs", "javascript"],
    LIKES: 120
  },
  {
    TITLE: "mongodb",
    DESCRIPTION: "Advanced concepts in MongoDB",
    BY: "Ajay",
    URL: "/mongodb-deep-dive",
    TAGS: ["mongodb", "nosql"],
    LIKES: 9
  },
  {
    TITLE: "nosql overview",
    DESCRIPTION: "Overview of NoSQL databases",
    BY: "Sonia",
    URL: "/nosql-overview",
    TAGS: ["nosql", "database"],
    LIKES: 75
  }
])

// 3. Insert 1 more document in collection with additional field of user name and comments
db.books.insertOne({
  TITLE: "React for Beginners",
  DESCRIPTION: "Learn React from scratch",
  BY: "Ajay",
  URL: "/react-beginners",
  TAGS: ["react", "javascript", "frontend"],
  LIKES: 200,
  user_name: "testuser",
  comments: [
    { user: "Alice", text: "Great tutorial!" },
    { user: "Bob", text: "Very helpful." }
  ]
})

// 4. Display all the documents whose title is 'mongodb'
db.books.find({ TITLE: "mongodb" }).pretty()

// Alternative with case-insensitive search
db.books.find({ TITLE: { $regex: /^mongodb$/i } }).pretty()

// 5. Display all the documents written by 'Ajay' or whose title is 'mongodb'
db.books.find({
  $or: [
    { BY: "Ajay" },
    { TITLE: "mongodb" }
  ]
}).pretty()

// Alternative with case-insensitive title
db.books.find({
  $or: [
    { BY: "Ajay" },
    { TITLE: { $regex: /^mongodb$/i } }
  ]
}).pretty()

// 6. Display all the documents whose title is 'mongodb' and written by 'Ajay'
db.books.find({
  TITLE: "mongodb",
  BY: "Ajay"
}).pretty()

// Alternative with case-insensitive
db.books.find({
  TITLE: { $regex: /^mongodb$/i },
  BY: "Ajay"
}).pretty()

// 7. Display all the documents whose like is greater than 10
db.books.find({ LIKES: { $gt: 10 } }).pretty()

// 8. Display all the documents whose like is greater than 100 and whose title is either 'mongodb' or written by 'Ajay'
db.books.find({
  LIKES: { $gt: 100 },
  $or: [
    { TITLE: "mongodb" },
    { BY: "Ajay" }
  ]
}).pretty()

// Alternative with case-insensitive
db.books.find({
  LIKES: { $gt: 100 },
  $or: [
    { TITLE: { $regex: /^mongodb$/i } },
    { BY: "Ajay" }
  ]
}).pretty()

// 9. Update the title of 'mongodb' document to 'mongodb overview'
db.books.updateOne(
  { TITLE: "mongodb" },
  { $set: { TITLE: "mongodb overview" } }
)

// Alternative with case-insensitive
db.books.updateOne(
  { TITLE: { $regex: /^mongodb$/i } },
  { $set: { TITLE: "mongodb overview" } }
)

// 10. Delete the document titled 'nosql overview'
db.books.deleteOne({ TITLE: "nosql overview" })

// Alternative with case-insensitive
db.books.deleteOne({ TITLE: { $regex: /^nosql overview$/i } })

// 11. Display exactly two documents written by 'Ajay'
db.books.find({ BY: "Ajay" }).limit(2).pretty()

// 12. Display the second document published by 'Ajay'
db.books.find({ BY: "Ajay" }).skip(1).limit(1).pretty()

// 13. Display all the books in the sorted fashion
db.books.find().sort({ TITLE: 1 }).pretty()

// Sort by TITLE in descending order
db.books.find().sort({ TITLE: -1 }).pretty()

// Sort by LIKES in descending order
db.books.find().sort({ LIKES: -1 }).pretty()

// Sort by BY (author) alphabetically
db.books.find().sort({ BY: 1 }).pretty()

// Insert a document using save method
db.books.save({
  TITLE: "Python Crash Course",
  DESCRIPTION: "Complete Python guide",
  BY: "Priya",
  URL: "/python-crash-course",
  TAGS: ["python", "programming"],
  LIKES: 300
})

// Alternative: save with _id (updates if exists, inserts if not)
db.books.save({
  _id: ObjectId("68f5e22ac8f06d29f8544cd7"),
  TITLE: "Python Crash Course Updated",
  DESCRIPTION: "Complete Python guide - Updated",
  BY: "Priya",
  URL: "/python-crash-course",
  TAGS: ["python", "programming"],
  LIKES: 350
})

// Additional Useful Queries

// Count total documents
db.books.countDocuments()

// Count documents by specific author
db.books.countDocuments({ BY: "Ajay" })

// Find documents with LIKES between 50 and 150
db.books.find({
  LIKES: { $gte: 50, $lte: 150 }
}).pretty()

// Find documents with specific tag
db.books.find({ TAGS: "mongodb" }).pretty()

// Update multiple documents - increase LIKES by 10 for all Raj's books
db.books.updateMany(
  { BY: "Raj" },
  { $inc: { LIKES: 10 } }
)

// Add a new field to all documents
db.books.updateMany(
  {},
  { $set: { published: true } }
)

// Remove a field from all documents
db.books.updateMany(
  {},
  { $unset: { published: "" } }
)

// Delete multiple documents
db.books.deleteMany({ LIKES: { $lt: 50 } })

// Find and sort with projection (show only specific fields)
db.books.find(
  { BY: "Ajay" },
  { TITLE: 1, LIKES: 1, _id: 0 }
).sort({ LIKES: -1 }).pretty()

// Aggregate query - group by author and count
db.books.aggregate([
  {
    $group: {
      _id: "$BY",
      totalBooks: { $sum: 1 },
      totalLikes: { $sum: "$LIKES" }
    }
  }
])

// Find documents where TAGS array contains multiple elements
db.books.find({
  TAGS: { $all: ["mongodb", "nosql"] }
}).pretty()

// Find documents with array size
db.books.find({
  TAGS: { $size: 3 }
}).pretty()

// Add element to array
db.books.updateOne(
  { TITLE: "React for Beginners" },
  { $push: { comments: { user: "Charlie", text: "Awesome!" } } }
)

// Remove element from array
db.books.updateOne(
  { TITLE: "React for Beginners" },
  { $pull: { TAGS: "frontend" } }
)

// Check if field exists
db.books.find({ user_name: { $exists: true } }).pretty()

// Text search (requires text index)
db.books.createIndex({ TITLE: "text", DESCRIPTION: "text" })
db.books.find({ $text: { $search: "MongoDB" } }).pretty()

// Drop collection
db.books.drop()

// Drop database
db.dropDatabase()