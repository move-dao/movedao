 mod index;
 pub use index::index;
 use sea_orm::DatabaseConnection;

use crate::{state::AppState,AppError};
// use crate::{state::AppState, AppError, Result};

 fn get_conn<'a>(state: &'a AppState) -> &'a DatabaseConnection {
    &state.conn
}
/// 记录错误
fn log_error(handler_name: &str) -> Box<dyn Fn(AppError) -> AppError> {
    let handler_name = handler_name.to_string();
    Box::new(move |err| {
        tracing::error!("{}: {:?}", handler_name, err);
        err
    })
}