# 📖 Reader App (iOS)

A simple **iOS Reader App** that fetches and displays news articles using a public API with **offline support**, **search**, and **bookmarks**.  
Built using **UIKit** with **MVVM / Clean Architecture** principles.  

---

## 🚀 Features

- **Fetch Articles**  
  - Fetch latest articles from a REST API (e.g. [NewsAPI.org](https://newsapi.org/) or JSONPlaceholder).  
  - Display **title, author, and thumbnail image**.  

- **Offline Caching**  
  - Store articles locally using **Core Data** (can also use Realm or file caching).  
  - Show cached articles when offline.  

- **Pull-to-Refresh**  
  - Refresh articles with `UIRefreshControl`.  

- **Search Articles**  
  - Filter articles by title with a search bar.  

- **Bookmarks (Bonus)**  
  - Bookmark favorite articles.  
  - Access them from a dedicated **Bookmarks tab**.  

---

## 🏗️ Architecture

- **Pattern:** MVVM + Clean Architecture  
- **Separation of concerns** between layers for better maintainability and testability.  

**Layers Overview:**
- **Networking** → Handles API requests (using `URLSession` or `Alamofire`).  
- **Repository** → Provides data from API or cache.  
- **ViewModel** → Business logic & state management.  
- **View (UIKit)** → Displays data using `UITableView` / `UICollectionView`.  

---

## 📱 UI & UX

- Built with **UIKit**  
- **Auto Layout** for adaptive design  
- **Light & Dark Mode** supported  
- Dynamic **TableView / CollectionView cells**  

---

## 📦 Dependencies (Optional)

### 🔹 [Alamofire](https://github.com/Alamofire/Alamofire)  
- Swift-based **HTTP networking library**.  
- Simplifies API calls compared to `URLSession`.  
- Handles JSON parsing, error handling, and background tasks.  
- **In this project:** Used for **fetching articles from the API**.  

### 🔹 [SDWebImage](https://github.com/SDWebImage/SDWebImage)  
- Library for **asynchronous image downloading & caching**.  
- Supports placeholders, progressive image loading, and GIFs.  
- **In this project:** Used to load **article thumbnails efficiently**.  

### 🔹 [Kingfisher](https://github.com/onevcat/Kingfisher)  
- Alternative to SDWebImage.  
- Provides **image downloading, caching, and memory management**.  
- Includes prefetching and processor-based editing.  
- **In this project:** Can be used instead of SDWebImage.  

👉 Use **either SDWebImage or Kingfisher** (not both).  
---

⚡ Getting Started
### Prerequisites

Xcode 15+
iOS 15+ (minimum deployment target)
Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/<your-username>/ReaderApp.git
```

2. Open project in Xcode:
```bash
open ReaderApp.xcodeproj
```

3. Install iOS dependencies :
```bash
cd ios
pod install
cd ..
```
Run on simulator or device.

