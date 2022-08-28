pub mod config;
pub mod router;
pub mod state;
pub mod handler;
pub mod entity;
pub mod err;
pub use err::{AppError, AppErrorType};
pub type Result<T> = std::result::Result<T, crate::AppError>;