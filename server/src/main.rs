mod config;

use config::ServerConfig;

use rust_embed::RustEmbed;
use salvo::conn::rustls::{Keycert, RustlsConfig};
use salvo::prelude::*;
use salvo::serve_static::static_embed;

#[derive(RustEmbed)]
#[folder = "static"]
struct Assets;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    tracing_subscriber::fmt().init();

    let server_config = ServerConfig::new()?;

    let router = Router::with_path("<*path>").get(static_embed::<Assets>().fallback("index.html"));
    
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
