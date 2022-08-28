use std::sync::Arc;

use axum::{
    extract::{Form, Query},
    Extension,
    response::Html,
};

use sea_orm::{
 
    ActiveValue::{NotSet, Set},
    ColumnTrait, Condition, EntityTrait, PaginatorTrait, QueryFilter, QueryOrder, QuerySelect,
};
use super::{get_conn,log_error};
use crate::{ 
    state::AppState, 
    entity::{project},
    AppError,
    Result
};

pub async fn index( Extension(state): Extension<Arc<AppState>>,) -> Result<String> {
    let handler_name ="index";
    let conn = get_conn(&state);
    let condition = Condition::all().add(project::Column::Id.gte(1));
    let selc = project::Entity::find().filter(condition);
    let record_total = selc
        .clone()
        .count(conn)
        .await
        .map_err(AppError::from)
        .map_err(log_error(handler_name))
        .unwrap();
    Ok(record_total.to_string())
}