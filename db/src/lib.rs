pub mod db;
pub mod config;

pub use db::create_pool;
pub use config::DatabaseConfig;
pub use db::{fetch_messages, insert_message, insert_session, insert_user};
