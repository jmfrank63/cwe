use std::fmt::{Display, Debug};
use std::path::PathBuf;

const SECRET: &str = "[******]";

#[derive(Debug)]
pub struct Secret<T>(T);

impl<T> Secret<T> {
    pub fn new(secret: T) -> Self {
        Secret(secret)
    }
}

impl <T: Display> Display for Secret<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{SECRET}")
    }
}

impl<T: AsRef<[u8]>> Secret<T> {
    pub fn as_slice(&self) -> &[u8] {
        self.0.as_ref()
    }
}

pub struct ServerConfig {
    pub address: String,
    pub port: u16,
    pub cert: Vec<u8>,
    pub key: Secret<Vec<u8>>,
}

impl Default for ServerConfig {
    fn default() -> Self {
        dotenv::dotenv().ok();
        let cert_path = PathBuf::from(dotenv::var("CERT_PATH").expect("CERT_PATH not found in .env file"));
        let key_path = PathBuf::from(dotenv::var("KEY_PATH").expect("KEY_PATH not found in .env file"));
        let address = dotenv::var("ADDRESS").expect("ADDRESS not found in .env file");
        let port: u16 = dotenv::var("PORT").expect("PORT not found in .env file")
                                           .parse().expect("PORT is not a valid u16");
        let cert = std::fs::read(&cert_path).expect("Failed to read cert file");
        let key = Secret::new(std::fs::read(&key_path).expect("Failed to read key file"));
        Self { cert, key, address, port }
    }
}
