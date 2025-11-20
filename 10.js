// Start MongoDB Shell
mongosh

// Switch to Database
use TY_B_72

// Create Collection
db.createCollection("books")

// Insert Sample Data
db.books.insertMany([
  {
    TITLE: "MongoDB Basics",
    DESCRIPTION: "A beginner's guide to MongoDB",
    BY: "Ajay",
    URL: "/mongodb-basics",
    TAGS: ["mongodb", "database", "nosql"],
    LIKES: 50,
    published_date: new Date("2023-01-15")
  },
  {
    TITLE: "Advanced SQL",
    DESCRIPTION: "Deep dive into SQL",
    BY: "Priya",
    URL: "/advanced-sql",
    TAGS: ["sql", "database", "rdbms"],
    LIKES: 150,
    published_date: new Date("2023-02-20")
  },
  {
    TITLE: "Node.js Guide",
    DESCRIPTION: "Comprehensive guide for Node.js",
    BY: "Ajay",
    URL: "/nodejs-guide",
    TAGS: ["nodejs", "javascript"],
    LIKES: 120,
    published_date: new Date("2023-03-10")
  },
  {
    TITLE: "MongoDB Deep Dive",
    DESCRIPTION: "Advanced concepts in MongoDB",
    BY: "Ajay",
    URL: "/mongodb-deep-dive",
    TAGS: ["mongodb", "nosql"],
    LIKES: 90,
    published_date: new Date("2023-05-25")
  },
  {
    TITLE: "NoSQL Overview",
    DESCRIPTION: "Overview of NoSQL databases",
    BY: "Sonia",
    URL: "/nosql-overview",
    TAGS: ["nosql", "database"],
    LIKES: 75,
    published_date: new Date("2023-04-18")
  },
  {
    TITLE: "React for Beginners",
    DESCRIPTION: "Learn React from scratch",
    BY: "Ajay",
    URL: "/react-beginners",
    TAGS: ["react", "javascript", "frontend"],
    LIKES: 200,
    published_date: new Date("2023-06-30")
  },
  {
    TITLE: "Python Programming",
    DESCRIPTION: "Complete Python guide",
    BY: "Ajay",
    URL: "/python-programming",
    TAGS: ["python", "programming"],
    LIKES: 30,
    published_date: new Date("2023-07-15")
  },
  {
    TITLE: "Data Structures",
    DESCRIPTION: "Understanding data structures",
    BY: "Raj",
    URL: "/data-structures",
    TAGS: ["algorithms", "programming"],
    LIKES: 180,
    published_date: new Date("2023-08-05")
  }
])

// ============================================
// AGGREGATION QUERIES
// ============================================

// 1. Find the number of books published by "Ajay"
db.books.aggregate([
  {$match: { BY: "Ajay" }},
  { $count: "total_books_by_ajay"}
])

// Alternative method using countDocuments
db.books.countDocuments({ BY: "Ajay" })

// Alternative using group
db.books.aggregate([
  
  {
    $group: {
      _id: "$BY",
      total_books: { $sum: 1 }
    }
  }
])

// 2. Find books which have minimum likes and maximum likes published by "Ajay"
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $group: {
      _id: "$BY",
      min_likes: { $min: "$LIKES" },
      max_likes: { $max: "$LIKES" }
    }
  }
])

// Find the book with minimum likes by Ajay
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $sort: { LIKES: 1 }
  },
  {
    $limit: 1
  }
])

// Find the book with maximum likes by Ajay
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $sort: { LIKES: -1 }
  },
  {
    $limit: 1
  }
])

// Find both minimum and maximum liked books with details
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $facet: {
      min_liked_book: [
        { $sort: { LIKES: 1 } },
        { $limit: 1 }
      ],
      max_liked_book: [
        { $sort: { LIKES: -1 } },
        { $limit: 1 }
      ]
    }
  }
])

// 3. Find the average number of likes of the books published by Ajay
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $group: {
      _id: "$BY",
      average_likes: { $avg: "$LIKES" }
    }
  }
])

// With more statistics
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $group: {
      _id: "$BY",
      average_likes: { $avg: "$LIKES" },
      total_books: { $sum: 1 },
      total_likes: { $sum: "$LIKES" },
      min_likes: { $min: "$LIKES" },
      max_likes: { $max: "$LIKES" }
    }
  }
])

// 4. Find the first and last book published by "Ajay"
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $sort: { published_date: 1 }
  },
  {
    $group: {
      _id: "$BY",
      first_book: { $first: "$TITLE" },
      last_book: { $last: "$TITLE" }
    }
  }
])

// Find first book only
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $sort: { published_date: 1 }
  },
  {
    $limit: 1
  }
])

// Find last book only
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $sort: { published_date: -1 }
  },
  {
    $limit: 1
  }
])

// Using facet to get both
db.books.aggregate([
  {
    $match: { BY: "Ajay" }
  },
  {
    $facet: {
      first_book: [
        { $sort: { published_date: 1 } },
        { $limit: 1 }
      ],
      last_book: [
        { $sort: { published_date: -1 } },
        { $limit: 1 }
      ]
    }
  }
])

// ============================================
// INDEXING QUERIES
// ============================================

// 5. Create an index on the author name (BY field)
db.books.createIndex({ BY: 1 })

// Create index with name
db.books.createIndex({ BY: 1 }, { name: "author_index" })

// Create compound index
db.books.createIndex({ BY: 1, LIKES: -1 })

// Create text index for search
db.books.createIndex({ TITLE: "text", DESCRIPTION: "text" })

// Display the books published by "Ajay" and check if it uses the index
db.books.find({ BY: "Ajay" })

// Check if index is used - Use EXPLAIN
db.books.find({ BY: "Ajay" }).explain("executionStats")

// Detailed explanation
db.books.find({ BY: "Ajay" }).explain("allPlansExecution")

// Check query execution plan
db.books.find({ BY: "Ajay" }).explain()

// ============================================
// INDEX MANAGEMENT QUERIES
// ============================================

// List all indexes on the collection
db.books.getIndexes()

// Show index stats
db.books.stats()

// Drop specific index
db.books.dropIndex("author_index")

// Drop index by specification
db.books.dropIndex({ BY: 1 })

// Drop all indexes except _id
db.books.dropIndexes()

// Create unique index
db.books.createIndex({ TITLE: 1 }, { unique: true })

// Create sparse index (only indexes documents with the field)
db.books.createIndex({ user_name: 1 }, { sparse: true })

// Create TTL index (auto-delete documents after time)
db.books.createIndex({ published_date: 1 }, { expireAfterSeconds: 31536000 })

// ============================================
// ADDITIONAL AGGREGATION QUERIES
// ============================================

// Group by author and count books
db.books.aggregate([
  {
    $group: {
      _id: "$BY",
      total_books: { $sum: 1 },
      total_likes: { $sum: "$LIKES" },
      avg_likes: { $avg: "$LIKES" }
    }
  },
  {
    $sort: { total_books: -1 }
  }
])

// Find top 3 most liked books
db.books.aggregate([
  {
    $sort: { LIKES: -1 }
  },
  {
    $limit: 3
  },
  {
    $project: {
      _id: 0,
      TITLE: 1,
      BY: 1,
      LIKES: 1
    }
  }
])

// Count books by tags
db.books.aggregate([
  {
    $unwind: "$TAGS"
  },
  {
    $group: {
      _id: "$TAGS",
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  }
])

// Books with likes greater than average
db.books.aggregate([
  {
    $group: {
      _id: null,
      avgLikes: { $avg: "$LIKES" }
    }
  },
  {
    $lookup: {
      from: "books",
      let: { avg: "$avgLikes" },
      pipeline: [
        {
          $match: {
            $expr: { $gt: ["$LIKES", "$$avg"] }
          }
        }
      ],
      as: "above_average_books"
    }
  },
  {
    $unwind: "$above_average_books"
  },
  {
    $replaceRoot: { newRoot: "$above_average_books" }
  }
])

// Author-wise statistics with sorting
db.books.aggregate([
  {
    $group: {
      _id: "$BY",
      book_count: { $sum: 1 },
      total_likes: { $sum: "$LIKES" },
      avg_likes: { $avg: "$LIKES" },
      books: { $push: "$TITLE" }
    }
  },
  {
    $sort: { total_likes: -1 }
  },
  {
    $project: {
      author: "$_id",
      book_count: 1,
      total_likes: 1,
      avg_likes: { $round: ["$avg_likes", 2] },
      books: 1,
      _id: 0
    }
  }
])

// Books published per month
db.books.aggregate([
  {
    $group: {
      _id: {
        year: { $year: "$published_date" },
        month: { $month: "$published_date" }
      },
      count: { $sum: 1 }
    }
  },
  {
    $sort: { "_id.year": 1, "_id.month": 1 }
  }
])

// Bucket books by like ranges
db.books.aggregate([
  {
    $bucket: {
      groupBy: "$LIKES",
      boundaries: [0, 50, 100, 150, 200, 250],
      default: "250+",
      output: {
        count: { $sum: 1 },
        books: { $push: "$TITLE" }
      }
    }
  }
])

// Match, Project, and Sort
db.books.aggregate([
  {
    $match: { LIKES: { $gte: 50 } }
  },
  {
    $project: {
      TITLE: 1,
      BY: 1,
      LIKES: 1,
      popularity: {
        $cond: {
          if: { $gte: ["$LIKES", 150] },
          then: "High",
          else: "Medium"
        }
      }
    }
  },
  {
    $sort: { LIKES: -1 }
  }
])

// Lookup (Join) - if you have another collection
// Example: Join with authors collection
db.books.aggregate([
  {
    $lookup: {
      from: "authors",
      localField: "BY",
      foreignField: "name",
      as: "author_details"
    }
  }
])

// Add computed fields
db.books.aggregate([
  {
    $addFields: {
      like_category: {
        $switch: {
          branches: [
            { case: { $lt: ["$LIKES", 50] }, then: "Low" },
            { case: { $lt: ["$LIKES", 100] }, then: "Medium" },
            { case: { $lt: ["$LIKES", 200] }, then: "High" }
          ],
          default: "Very High"
        }
      }
    }
  }
])

// ============================================
// PERFORMANCE ANALYSIS
// ============================================

// Analyze query performance without index
db.books.find({ BY: "Ajay" }).explain("executionStats")

// Create index
db.books.createIndex({ BY: 1 })

// Analyze query performance with index
db.books.find({ BY: "Ajay" }).explain("executionStats")

// Compare execution time and documents examined
// Without index: executionTimeMillis will be higher, totalDocsExamined = all docs
// With index: executionTimeMillis will be lower, totalDocsExamined = matching docs only

// Rebuild indexes
db.books.reIndex()

// Get collection statistics
db.books.stats()

// Validate collection
db.books.validate()

// ============================================
// CLEANUP
// ============================================

// Drop collection
db.books.drop()

// Drop database
db.dropDatabase()