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

impl ServerConfig {
    pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
        dotenv::dotenv().ok();
        let cert_path = PathBuf::from(dotenv::var("CERT_PATH")?);
        let key_path = PathBuf::from(dotenv::var("KEY_PATH")?);
        let address = dotenv::var("ADDRESS")?;
        let port: u16 = dotenv::var("PORT")?.parse()?;
        let cert = std::fs::read(&cert_path)?;
        let key = Secret::new(std::fs::read(&key_path)?);

        Ok(Self { cert, key, address, port })
    }
}
