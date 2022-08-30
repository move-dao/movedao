//! Run with
//!
//! ```not_rust
//! cd examples && cargo run -p example-hello-world
//! ```

use axum::{response::Html, routing::get, Router};
use std::net::SocketAddr;
use std::sync::Arc;

use axum::Extension;
use movedao::{config,state,router};
use dotenv::dotenv;
use sea_orm::Database;

#[tokio::main]
async fn main() {
    dotenv().ok();
    let cfg = config::Config::from_env().unwrap();
    let conn = Database::connect(&cfg.db.dsn).await.unwrap();

    tracing::info!("Web服务监听于{}", &cfg.web.addr);
    let addr = &cfg.web.addr.parse().unwrap();
    let app = router::init().layer(Extension(Arc::new(state::AppState { conn })));
    axum::Server::bind(addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
    
}

async fn handler() -> Html<&'static str> {
    Html("<h1>Hello, World!</h1>")
}