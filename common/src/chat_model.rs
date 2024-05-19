use chrono::NaiveDateTime;
use sqlx::FromRow;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, FromRow, Debug)]
pub struct User {
    pub id: i64,
    pub username: String,
    pub email: String,
    pub password: String,
}

#[derive(Serialize, Deserialize, FromRow, Debug)]
pub struct Message {
    pub id: i64,
    pub user_id: i64,
    pub content: String,
    pub timestamp: NaiveDateTime,
}

#[derive(Serialize, Deserialize, FromRow, Debug)]
pub struct Session {
    pub id: i64,
    pub session_id: String,
    pub user_id: i64,
    pub created_at: NaiveDateTime,
}
