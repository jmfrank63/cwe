use sqlx::postgres::PgPool;
use crate::config::{DatabaseConfig, DbPool};
use common::model::Message;

pub async fn create_pool() -> Result<PgPool, sqlx::Error> {
    let database_config = DatabaseConfig::new().map_err(|e| sqlx::Error::Configuration(e.to_string().into()))?;    let database_url = format!(
        "postgres://{}:{}@{}/{}",
        database_config.user,
        database_config.password,
        database_config.host,
        database_config.name,
    );
    let pool = PgPool::connect(&database_url).await?;
    Ok(pool)
}

pub async fn get_messages(pool: &DbPool) -> Result<Vec<Message>, sqlx::Error> {
    let mut conn = pool.acquire().await?;
    let rows = sqlx::query!("SELECT sender, content FROM messages ORDER BY timestamp ASC")
        .fetch_all(&mut conn)
        .await?;

    let messages: Vec<Message> = rows.into_iter().map(|row| {
        Message {
            sender: row.sender,
            content: row.content,
        }
    }).collect();

    Ok(messages)
}

pub async fn post_message(pool: &DbPool, message: Message) -> Result<(), sqlx::Error> {
    let mut conn = pool.acquire().await?;
    sqlx::query!("INSERT INTO messages (sender, content) VALUES ($1, $2)", message.sender, message.content)
        .execute(&mut conn)
        .await?;

    Ok(())
}
