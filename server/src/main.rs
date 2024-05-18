mod config;
mod db;
mod chat;

use config::ServerConfig;
use db::{create_pool, DbPool};
use chat::{get_messages, post_message};
use rust_embed::RustEmbed;
use salvo::conn::rustls::{Keycert, RustlsConfig};
use salvo::prelude::*;
use salvo::serve_static::static_embed;
use std::sync::Arc;

#[derive(RustEmbed)]
#[folder = "static"]
struct Assets;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    tracing_subscriber::fmt().init();

    let server_config = ServerConfig::new()?;
    let db_pool = Arc::new(create_pool().await?);

    let router = Router::with_path("<*path>")
        .get(static_embed::<Assets>().fallback("index.html"))
        .push(
            Router::new()
                .path("api/messages")
                .get(get_messages)
                .post(post_message)
                .hoop(DepotProvider::new(db_pool.clone()))
        );

    let config = RustlsConfig::new(
        Keycert::new()
            .cert(server_config.cert.as_slice())
            .key(server_config.key.as_slice()),
    );
    let socket_addr = (server_config.address, server_config.port);

    let listener = TcpListener::new(socket_addr.clone()).rustls(config.clone());
    let acceptor = QuinnListener::new(config, socket_addr)
        .join(listener)
        .bind()
        .await;

    Server::new(acceptor).serve(router).await;
    Ok(())
}

struct DepotProvider {
    db_pool: Arc<DbPool>,
}

impl DepotProvider {
    fn new(db_pool: Arc<DbPool>) -> Self {
        Self { db_pool }
    }
}

#[async_trait]
impl Handler for DepotProvider {
    async fn handle(&self, req: &mut Request, depot: &mut Depot, res: &mut Response, ctrl: &mut FlowCtrl) {
        depot.insert("db_pool", self.db_pool.clone());
        ctrl.call_next(req, depot, res).await;
    }
}
