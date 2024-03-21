use salvo::conn::rustls::{Keycert, RustlsConfig};
use salvo::prelude::*;
use std::fs;
use std::net::ToSocketAddrs;

#[handler]
async fn hello() -> &'static str {
    "Welcome to the Common Work Education Management Site"
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt().init();
    dotenv::dotenv().ok();

    let cert_path = dotenv::var("CERT_PATH").expect("CERT_PATH not found in .env file");
    let key_path = dotenv::var("KEY_PATH").expect("KEY_PATH not found in .env file");
    let address = dotenv::var("ADDRESS").expect("ADDRESS not found in .env file");
    let port: u16 = dotenv::var("PORT").expect("PORT not found in .env file")
                                   .parse().expect("PORT is not a valid u16");

    let cert = fs::read(cert_path).expect("Failed to read cert file");
    let key = fs::read(key_path).expect("Failed to read key file");

    let router = Router::new().get(hello);
    let config = RustlsConfig::new(Keycert::new().cert(cert.as_slice()).key(key.as_slice()));

    let socket_addr = format!("{}:{}", address, port)
        .to_socket_addrs().expect("Invalid address or port")
        .next().expect("Invalid address or port");

    let listener = TcpListener::new(socket_addr).rustls(config.clone());
    let acceptor = QuinnListener::new(config, socket_addr)
        .join(listener)
        .bind()
        .await;

    Server::new(acceptor).serve(router).await;
}
