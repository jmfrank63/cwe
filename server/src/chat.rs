use common::chat_model::Message;
use db::config::DbPool;
use salvo::prelude::*;
use serde_json::json;

#[handler]
pub async fn get_messages(_: &mut Request, depot: &mut Depot, res: &mut Response) {
    let pool = depot.obtain::<DbPool>().unwrap();
    match db::fetch_messages(&pool).await {
        Ok(messages) => res.render(Json(messages)),
        Err(e) => {
            res.status_code(StatusCode::INTERNAL_SERVER_ERROR);
            res.render(format!("Error: {}", e))
        }
    }
}

#[handler]
pub async fn post_message(req: &mut Request, depot: &mut Depot, res: &mut Response) {
    let message: Message = req.parse_json().await.unwrap();
    let pool = depot.obtain::<DbPool>().unwrap();
    match db::insert_message(&pool, message.user_id, &message.content).await {
        Ok(id) => {
            res.status_code(StatusCode::CREATED);
            res.render(Json(json!({ "id": id })));
        }
        Err(e) => {
            res.status_code(StatusCode::INTERNAL_SERVER_ERROR);
            res.render(format!("Error: {}", e))
        }
    }
}
