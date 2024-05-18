use db::config::DbPool;
use salvo::prelude::*;


#[handler]
pub async fn get_messages(_: &mut Request, depot: &mut Depot, res: &mut Response) {
    let pool = depot.obtain::<DbPool>().unwrap();
    let messages = db::get_messages(&pool).await.unwrap();
    res.render(Json(messages));
}

#[handler]
pub async fn post_message(req: &mut Request, depot: &mut Depot, res: &mut Response) {
    let message: Message = req.parse_json().await.unwrap();
    let pool = depot.obtain::<DbPool>().unwrap();
    db::post_message(&pool, message).await.unwrap();
}
