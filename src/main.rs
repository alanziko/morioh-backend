use axum::{Router, http::StatusCode, routing::get};

#[tokio::main]
async fn main() {
    let app = Router::<()>::new()
        .route("/", get(status));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn status() -> StatusCode {
    StatusCode::OK
}
