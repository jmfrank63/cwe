pub type DbPool = sqlx::Pool<sqlx::Postgres>;
pub struct DatabaseConfig {
    pub host: String,
    pub name: String,
    pub user: String,
    pub password: String,
}

impl DatabaseConfig {
    pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
        dotenv::dotenv().ok();
        let host = dotenv::var("DB_HOST")?;
        let name = dotenv::var("DB_NAME")?;
        let user = dotenv::var("DB_USER")?;
        let password = dotenv::var("DB_PASSWORD")?;

        Ok(Self { host, name, user, password })
    }
}
