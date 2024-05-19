pub type DbPool = sqlx::Pool<sqlx::Postgres>;
pub struct DatabaseConfig {
    pub host: String,
    pub name: String,
    pub user: String,
    pub password: String,
    pub pool_size: u32,
}

impl DatabaseConfig {
    pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
        dotenv::dotenv().ok();
        tracing::info!("Dotenv loaded");
        let host = dotenv::var("DB_HOST")?;
        tracing::info!("DB_HOST: {}", host);
        let name = dotenv::var("DB_NAME")?;
        tracing::info!("DB_NAME: {}", name);
        let user = dotenv::var("DB_USER")?;
        tracing::info!("DB_USER: {}", user);
        let password = dotenv::var("DB_PASSWORD")?;
        tracing::info!("DB_PASSWORD: [******]");
        let pool_size = dotenv::var("DB_POOL_SIZE")?.parse()?;
        tracing::info!("DB_POOL_SIZE: {}", pool_size);

        Ok(Self { host, name, user, password, pool_size })
    }
}
