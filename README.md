
# Database Schema for Online Music Player

This is my first ever database schema design using MySQL for an online music player.

## 1. User Interactions

- **User Follows User**
  - **Participation**: Partial - Partial
  - **Cardinality**: Many-to-Many (M:N)
  
- **User Follows Artist**
  - **Participation**: Partial - Partial
  - **Cardinality**: Many-to-Many (M:N)
  
- **User Likes Songs**
  - **Participation**: Partial - Partial
  - **Cardinality**: Many-to-Many (M:N)
  
- **User Likes Albums**
  - **Participation**: Partial - Partial
  - **Cardinality**: Many-to-Many (M:N)
  
- **User Likes Other Playlists**
  - **Participation**: Partial - Partial
  - **Cardinality**: Many-to-Many (M:N)
  
- **User Creates Playlist of Songs**
  - **Participation**: Partial - Full
  - **Cardinality**: Many-to-One (N:1)

## 2. Artist Relationships

- **Artist Has Songs**
  - **Participation**: Full - Full
  - **Cardinality**: One-to-Many (1:N)
  - Note: Songs can be singles or part of albums
  
- **Artist Has Albums**
  - **Participation**: Partial - Full
  - **Cardinality**: One-to-Many (1:N)
  
## 3. Album Relationships

- **Album Has Songs**
  - **Participation**: Full - Partial
  - **Cardinality**: One-to-Many (1:N)

## ER Diagram

![ER Diagram](https://github.com/user-attachments/assets/fd6c345e-149f-4d6f-9b5f-ebdb3c502069)

