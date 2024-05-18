use deadpool_postgres::{Config, ManagerConfig, Pool, RecyclingMethod};
use tokio_postgres::NoTls;

pub type DbPool = Pool;

pub async fn create_pool() -> Result<DbPool, Box<dyn std::error::Error>> {
    let mut cfg = Config::new();
    cfg.host = Some(dotenv::var("DB_HOST")?);
    cfg.dbname = Some(dotenv::var("DB_NAME")?);
    cfg.user = Some(dotenv::var("DB_USER")?);
    cfg.password = Some(dotenv::var("DB_PASSWORD")?);
    cfg.manager = Some(ManagerConfig { recycling_method: RecyclingMethod::Fast });

    let pool = cfg.create_pool(None, NoTls)?;
    Ok(pool)
}
