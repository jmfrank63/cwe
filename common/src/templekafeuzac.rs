use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[derive(sqlx::FromRow, Debug)]
struct Message {
    id: i64,
    content: String,
    timestamp: chrono::NaiveDateTime,
}
