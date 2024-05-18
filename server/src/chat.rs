use salvo::prelude::*;
use serde::{Deserialize, Serialize};
use crate::db::DbPool;

#[derive(Serialize, Deserialize)]
pub struct Message {
    sender: String,
    content: String,
}

#[handler]
pub async fn get_messages(_: &mut Request, depot: &mut Depot, res: &mut Response) {
    let pool = depot.obtain::<DbPool>().unwrap();
    let client = pool.get().await.unwrap();
    let rows = client.query("SELECT sender, content FROM messages ORDER BY timestamp ASC", &[]).await.unwrap();

    let messages: Vec<Message> = rows.iter().map(|row| {
        Message {
            sender: row.get(0),
            content: row.get(1),
        }
    }).collect();

    res.render(Json(messages));
}

#[handler]
pub async fn post_message(req: &mut Request, depot: &mut Depot, res: &mut Response) {
    let message: Message = req.parse_json().await.unwrap();
    let pool = depot.obtain::<DbPool>().unwrap();
    let client = pool.get().await.unwrap();
    client.execute("INSERT INTO messages (sender, content) VALUES ($1, $2)", &[&message.sender, &message.content]).await.unwrap();

    res.status_code(StatusCode::OK);
}
