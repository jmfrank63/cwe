use sqlx::postgres::{PgPool, PgPoolOptions};
use crate::config::DatabaseConfig;
use common::chat_model::Message;

pub async fn create_pool() -> Result<PgPool, sqlx::Error> {
    let database_config = DatabaseConfig::new().map_err(|e| sqlx::Error::Configuration(e.to_string().into()))?;    let database_url = format!(
        "postgres://{}:{}@{}/{}",
        database_config.user,
        database_config.password,
        database_config.host,
        database_config.name,
    );
    let pool = PgPoolOptions::new()
        .max_connections(database_config.pool_size)
        .connect(&database_url)
        .await?;

    sqlx::migrate!("../postgres/migrations").run(&pool).await?;

    Ok(pool)
}


pub async fn fetch_messages(pool: &sqlx::PgPool) -> Result<Vec<Message>, sqlx::Error> {
    let messages = sqlx::query_as::<_, Message>("SELECT id, user_id, content, timestamp FROM messages")
        .fetch_all(pool)
        .await?;
    Ok(messages)
}

pub async fn insert_user(pool: &sqlx::PgPool, username: &str, email: &str, password: &str) -> Result<i64, sqlx::Error> {
    let row: (i64,) = sqlx::query_as("INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING id")
        .bind(username)
        .bind(email)
        .bind(password)
        .fetch_one(pool)
        .await?;
    Ok(row.0)
}

pub async fn insert_message(pool: &sqlx::PgPool, user_id: i64, content: &str) -> Result<i64, sqlx::Error> {
    let row: (i64,) = sqlx::query_as("INSERT INTO messages (user_id, content) VALUES ($1, $2) RETURNING id")
        .bind(user_id)
        .bind(content)
        .fetch_one(pool)
        .await?;
    Ok(row.0)
}

pub async fn insert_session(pool: &sqlx::PgPool, session_id: &str, user_id: i64) -> Result<i64, sqlx::Error> {
    let row: (i64,) = sqlx::query_as("INSERT INTO sessions (session_id, user_id) VALUES ($1, $2) RETURNING id")
        .bind(session_id)
        .bind(user_id)
        .fetch_one(pool)
        .await?;
    Ok(row.0)
}
