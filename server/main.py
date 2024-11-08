# server/main.py

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import Product, ProductCreate, CartItem, FavoriteItem, CartItemResponse, FavoriteItemResponse
from fastapi import Request
from fastapi.responses import JSONResponse
from typing import List, Optional  # Добавлен импорт Optional и List

app = FastAPI(default_response_class=JSONResponse)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # В продакшене укажите конкретные источники
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Временные хранилища данных
products_db: List[Product] = []
cart_db: List[CartItem] = []
favorites_db: List[FavoriteItem] = []

# Генерация ID
product_id_counter = 1

# --- Продукты ---

@app.get("/products", response_model=List[Product])
def get_all_products(organic: Optional[bool] = None, category: Optional[str] = None):
    filtered_products = products_db
    if organic is not None:
        filtered_products = [p for p in filtered_products if p.organic == organic]
    if category is not None:
        filtered_products = [p for p in filtered_products if p.category == category]
    return filtered_products

@app.exception_handler(Exception)
async def validation_exception_handler(request: Request, exc):
    print(f"Исключение при обработке запроса: {exc}")
    return JSONResponse(
        status_code=500,
        content={"detail": str(exc)},
    )

@app.get("/products/{product_id}", response_model=Product)
def get_product_by_id(product_id: int):
    for product in products_db:
        if product.id == product_id:
            return product
    raise HTTPException(status_code=404, detail="Product not found")

@app.post("/products", response_model=Product, response_class=JSONResponse)
def add_new_product(product: ProductCreate):
    print("Получен продукт:", product)
    print("Тип полученного продукта:", type(product))
    global product_id_counter
    new_product = Product(
        id=product_id_counter,
        name=product.name,
        price=product.price,
        image=product.image,
        organic=product.organic,
        category=product.category
    )
    product_id_counter += 1
    products_db.append(new_product)
    return new_product

@app.put("/products/{product_id}", response_model=Product)
def update_product(product_id: int, updated_product: ProductCreate):
    for index, product in enumerate(products_db):
        if product.id == product_id:
            products_db[index] = Product(id=product_id, **updated_product.dict())
            return products_db[index]
    raise HTTPException(status_code=404, detail="Product not found")

@app.delete("/products/{product_id}")
def delete_product(product_id: int):
    for product in products_db:
        if product.id == product_id:
            products_db.remove(product)
            return {"detail": "Product deleted"}
    raise HTTPException(status_code=404, detail="Product not found")

# --- Избранное ---

@app.get("/favorites", response_model=List[FavoriteItemResponse])
def get_all_favorites():
    favorites_response = []
    for item in favorites_db:
        product = next((p for p in products_db if p.id == item.product_id), None)
        if product:
            favorites_response.append(FavoriteItemResponse(product=product))
    return favorites_response

@app.get("/favorites/{product_id}", response_model=FavoriteItemResponse)
def get_favorite_by_id(product_id: int):
    for item in favorites_db:
        if item.product_id == product_id:
            product = next((p for p in products_db if p.id == product_id), None)
            if product:
                return FavoriteItemResponse(product=product)
    raise HTTPException(status_code=404, detail="Favorite not found")

@app.post("/favorites", response_model=FavoriteItemResponse)
def add_to_favorites(item: FavoriteItem):
    # Проверка, существует ли продукт
    product = next((p for p in products_db if p.id == item.product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    # Проверка, не добавлен ли уже в избранное
    if any(f.product_id == item.product_id for f in favorites_db):
        raise HTTPException(status_code=400, detail="Product already in favorites")
    favorites_db.append(item)
    return FavoriteItemResponse(product=product)

@app.delete("/favorites/{product_id}")
def remove_from_favorites(product_id: int):
    for item in favorites_db:
        if item.product_id == product_id:
            favorites_db.remove(item)
            return {"detail": "Item removed from favorites"}
    raise HTTPException(status_code=404, detail="Favorite not found")

# --- Корзина ---

@app.get("/cart", response_model=List[CartItemResponse])
def get_all_cart_items():
    cart_response = []
    for item in cart_db:
        product = next((p for p in products_db if p.id == item.product_id), None)
        if product:
            cart_response.append(CartItemResponse(product=product, quantity=item.quantity))
    return cart_response

@app.post("/cart", response_model=CartItemResponse)
def add_to_cart(item: CartItem):
    # Проверка, существует ли продукт
    product = next((p for p in products_db if p.id == item.product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    # Проверка, есть ли уже этот продукт в корзине
    for cart_item in cart_db:
        if cart_item.product_id == item.product_id:
            cart_item.quantity += item.quantity
            return CartItemResponse(product=product, quantity=cart_item.quantity)
    cart_db.append(item)
    return CartItemResponse(product=product, quantity=item.quantity)

@app.delete("/cart/{product_id}")
def remove_from_cart(product_id: int):
    for item in cart_db:
        if item.product_id == product_id:
            cart_db.remove(item)
            return {"detail": "Item removed from cart"}
    raise HTTPException(status_code=404, detail="Cart item not found")

@app.post("/cart/{product_id}/increase", response_model=CartItemResponse)
def increase_quantity(product_id: int):
    for item in cart_db:
        if item.product_id == product_id:
            item.quantity += 1
            product = next((p for p in products_db if p.id == product_id), None)
            if product:
                return CartItemResponse(product=product, quantity=item.quantity)
    raise HTTPException(status_code=404, detail="Cart item not found")

@app.post("/cart/{product_id}/decrease", response_model=CartItemResponse)
def decrease_quantity(product_id: int):
    for item in cart_db:
        if item.product_id == product_id:
            if item.quantity > 1:
                item.quantity -= 1
                product = next((p for p in products_db if p.id == product_id), None)
                if product:
                    return CartItemResponse(product=product, quantity=item.quantity)
            else:
                cart_db.remove(item)
                return {"detail": "Item removed from cart"}
    raise HTTPException(status_code=404, detail="Cart item not found")
